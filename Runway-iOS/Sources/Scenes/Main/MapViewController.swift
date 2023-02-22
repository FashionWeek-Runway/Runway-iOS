//
//  MapViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/18.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import NMapsMap
import CoreLocation

final class MapViewController: BaseViewController { // naver map sdk에서 카메라 delegate 프로퍼티 지원하지 않아 delegate pattern 사용
    
    private let mapSearchView: RWMapSearchView = RWMapSearchView()
    
    private lazy var mapView: NMFNaverMapView = {
        let view = NMFNaverMapView()
        view.mapView.touchDelegate = self
        view.mapView.addCameraDelegate(delegate: self)
        view.showLocationButton = false
        return view
    }()
    
    private let bottomSheet: RWBottomSheet = RWBottomSheet()
    
    private lazy var setLocationButton: NMFLocationButton = {
        let button = NMFLocationButton()
        button.clipsToBounds = true
        button.mapView = self.mapView.mapView
        return button
    }()
    
    private var isHiddenHelperViews: Bool = false {
        didSet {
            if isHiddenHelperViews {
                showTabbar()
                showSearchView()
            } else {
                hideTabbar()
                hideSearchView()
            }
        }
    }
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        locationManagerDidChangeAuthorization(manager)
        return manager
    }()

    // MARK: - initializer
    
    init(with reactor: MapReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAuthorization()
    }
    
    override func configureUI() {
        super.configureUI()
        self.view.addSubviews([mapView, mapSearchView, setLocationButton, bottomSheet])
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        mapSearchView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.getSafeArea().top + 118)
        }
        
        setLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.getSafeArea().bottom).offset(-136)
        }
        
        bottomSheet.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(view.frame.height - view.getSafeArea().top - 135 - 154)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().offset(-view.getSafeArea().top - 135)
        }
    }
    
    private func showTabbar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.size.height - frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = frame
        }
    }
    
    private func hideTabbar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = frame
        }
    }
    
    private func showSearchView() {
        mapSearchView.isHidden = false
        var frame = mapSearchView.frame
        frame.origin.y = view.frame.origin.y
        mapSearchView.frame.origin.y = view.frame.origin.y - mapSearchView.frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.mapSearchView.frame = frame
        }
    }
    
    private func hideSearchView() {
        var frame = mapSearchView.frame
        frame.origin.y = view.frame.origin.y - frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.mapSearchView.frame = frame
        } completion: { _ in
            self.mapSearchView.isHidden = true
        }
    }
    
    private func requestLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .denied:
            // 거부 상태: alert 필요
            break
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
        switch locationManager.accuracyAuthorization {
        case .reducedAccuracy:
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "사용자 위치 주변의 정확한 쇼룸 데이터 표시를 위해 정확한 위치 공유가 필요합니다.")
        case .fullAccuracy:
            // 이미 정확한 위치를 공유 중인 경우
            break
        @unknown default:
            break
        }
    }
    
    private func setUserInitialLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat:locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            mapView.mapView.moveCamera(cameraUpdate)
        default:
            break
        }
    }
}

extension MapViewController: View {
    func bind(reactor: MapReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MapReactor) {
        rx.viewDidLoad.map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mapSearchView.categoryCollectionView.rx.modelSelected(String.self)
            .map { Reactor.Action.selectFilter($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindState(reactor: MapReactor) {
        
        reactor.state.map { $0.mapCategoryFilters }
            .bind(to: mapSearchView.categoryCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                if index == 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RWMapSearchViewCollectionViewBookmarkCell.identifier, for: indexPath) as? RWMapSearchViewCollectionViewBookmarkCell else { return UICollectionViewCell() }
                    cell.setSelectedLayout(reactor.currentState.mapFilterSelected[item] ?? false)
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RWMapSearchViewCollectionViewCell.identifier, for: indexPath) as? RWMapSearchViewCollectionViewCell else { return UICollectionViewCell() }
                    cell.titleLabel.text = item
                    cell.setSelectedLayout(reactor.currentState.mapFilterSelected[item] ?? false)
                    return cell
                }
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.mapMarkers }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] markerData in
                markerData.forEach { data in
                    let marker = NMFMarker(position: NMGLatLng(lat: data.latitude, lng: data.longitude))
                    marker.iconImage = NMFOverlayImage(name: data.bookmark ? "bookmark_marker" : "marker")
                    marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
                    marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
                    marker.captionText = data.storeName
                    marker.captionTextSize = 10
                    marker.captionColor = .runwayBlack
                    marker.captionHaloColor = .white
                    marker.mapView = self?.mapView.mapView
                }
            }).disposed(by: disposeBag)
    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        isHiddenHelperViews.toggle()
    }
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        
        let lat = mapView.cameraPosition.target.lat
        let lng = mapView.cameraPosition.target.lng
        let action = Reactor.Action.mapViewCameraPositionDidChanged((lat, lng))
        reactor?.action.onNext(action)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.setUserInitialLocation()
            }
        default:
            break
        }
    }
}
