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
import Kingfisher

final class MapViewController: BaseViewController { // naver map sdk에서 카메라 delegate 프로퍼티 지원하지 않아 delegate pattern 사용
    
    private let mapSearchBar: RWMapSearchBar = RWMapSearchBar()
    
    private lazy var mapView: NMFNaverMapView = {
        let view = NMFNaverMapView()
        view.mapView.touchDelegate = self
        view.mapView.addCameraDelegate(delegate: self)
        view.showLocationButton = false
        return view
    }()
    
    private let bottomSheet: RWBottomSheet = RWBottomSheet()
    private lazy var searchResultBottomSheet: RWBottomSheet = {
        let sheet = RWBottomSheet()
        sheet.sheetPanMaxTopConstant = UIScreen.getDeviceHeight() - 276 - (self.tabBarController?.tabBar.frame.height ?? 0.0)
        sheet.sheetPanMinTopConstant = UIScreen.getDeviceHeight() - (self.tabBarController?.tabBar.frame.height ?? 0.0)
        sheet.searchResultView.isHidden = false
        sheet.aroundView.isHidden = true
        sheet.aroundEmptyView.isHidden = true
        return sheet
    }()
    
    private lazy var setLocationButton: NMFLocationButton = {
        let button = NMFLocationButton()
        button.clipsToBounds = true
        button.mapView = self.mapView.mapView
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: "현 지도에서 검색",
                                                     attributes: [.font: UIFont.body2, .foregroundColor: UIColor.blue600]),
                                  for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setImage(UIImage(named: "icon_refresh"), for: .normal)
        button.imageEdgeInsets.right = 4
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()
    
    private var isHiddenHelperViews: Bool = false {
        didSet {
            if isHiddenHelperViews {
                showTabbar()
                showSearchView()
                bottomSheet.isHidden = false
                searchButton.isHidden = false
                searchResultBottomSheet.isHidden = false
            } else {
                hideTabbar()
                hideSearchView()
                bottomSheet.isHidden = true
                searchButton.isHidden = true
                searchResultBottomSheet.isHidden = true
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
    
    // 표시될 마커들을 담아두기
    private var markers: [NMFMarker] = []

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
        self.view.addSubviews([mapView, mapSearchBar, searchButton, setLocationButton, bottomSheet, searchResultBottomSheet])
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        mapSearchBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.getSafeArea().top + 118)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(147)
            $0.height.equalTo(36)
            $0.top.equalTo(mapSearchBar.snp.bottom).offset(8)
        }
        
        bottomSheet.frame = CGRect(x: 0, y: UIScreen.getDeviceHeight() - view.getSafeArea().bottom - 121, width: UIScreen.getDeviceWidth(), height: UIScreen.getDeviceHeight() - view.getSafeArea().top - 135)
        searchResultBottomSheet.frame = CGRect(x: 0, y: UIScreen.getDeviceHeight() - (self.tabBarController?.tabBar.frame.height ?? 0), width: UIScreen.getDeviceWidth(), height: 276)
        
        setLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(42)
            $0.bottom.equalTo(bottomSheet.snp.top).offset(-19)
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
        mapSearchBar.isHidden = false
        var frame = mapSearchBar.frame
        frame.origin.y = view.frame.origin.y
        mapSearchBar.frame.origin.y = view.frame.origin.y - mapSearchBar.frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.mapSearchBar.frame = frame
        }
    }
    
    private func hideSearchView() {
        var frame = mapSearchBar.frame
        frame.origin.y = view.frame.origin.y - frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.mapSearchBar.frame = frame
        } completion: { _ in
            self.mapSearchBar.isHidden = true
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
        
        mapSearchBar.categoryCollectionView.rx.modelSelected(String.self)
            .map { Reactor.Action.selectFilter($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .do(onNext: { [weak self] in
                self?.searchButton.isHidden = true
            })
            .map { Reactor.Action.searchButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindState(reactor: MapReactor) {
        
        reactor.state.map { $0.mapCategoryFilters }
            .bind(to: mapSearchBar.categoryCollectionView.rx.items) { collectionView, index, item in
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
            .subscribe(onNext: { [weak self] markerData in
                
                self?.markers.forEach { $0.mapView = nil }
                DispatchQueue.global(qos: .default).async {
                    let markers = markerData.map { data in
                        let marker = NMFMarker(position: NMGLatLng(lat: data.latitude, lng: data.longitude))
                        marker.iconImage = NMFOverlayImage(name: data.bookmark ? "bookmark_marker" : "marker")
                        marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
                        marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
                        marker.captionText = data.storeName
                        marker.captionTextSize = 10
                        marker.captionColor = .runwayBlack
                        marker.captionHaloColor = .white
                        DispatchQueue.main.async {
                            marker.mapView = self?.mapView.mapView
                        }
                        return marker
                    }
                    self?.markers = markers
                }
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.aroundDatas }
            .do(onNext: { [weak self] in self?.bottomSheet.aroundEmptyView.isHidden = !$0.isEmpty })
            .bind(to: bottomSheet.aroundView.collectionView.rx.items(cellIdentifier: RWAroundCollectionViewCell.identifier, cellType: RWAroundCollectionViewCell.self)) { indexPath, item, cell in
                cell.storeNameLabel.text = item.storeName
                cell.tagRelay.accept(item.category)
                guard let url = URL(string: item.storeImageURL) else { return }
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: url),
                                           options: [.processor(ResizingImageProcessor(referenceSize: CGSize(width: 320, height: 180), mode: .aspectFit))])
            }.disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.mapMarkerSelectData }
            .subscribe(onNext: { [weak self] data in
                guard let url = URL(string: data.storeImage) else { return }
                self?.searchResultBottomSheet.searchResultView.tagRelay.accept(data.category)
                self?.searchResultBottomSheet.searchResultView.storeNameLabel.text = data.storeName
                self?.searchResultBottomSheet.searchResultView.imageView.kf.setImage(with: ImageResource(downloadURL: url),
                                                                                     options: [.processor(ResizingImageProcessor(referenceSize: CGSize(width: 320, height: 180), mode: .aspectFit))])
            }, onCompleted: { [weak self] in
                self?.searchResultBottomSheet.showSheet()
            })
            .disposed(by: disposeBag)
    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        isHiddenHelperViews.toggle()
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        let action = Reactor.Action.selectMapMarker(symbol.caption)
        reactor?.action.onNext(action)
        return false
    }
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        searchButton.isHidden = false
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
