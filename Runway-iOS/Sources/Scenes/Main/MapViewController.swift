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
        sheet.sheetPanMaxTopConstant = UIScreen.getDeviceHeight() - (self.tabBarController?.tabBar.frame.height ?? 0.0)
        sheet.sheetPanMinTopConstant = UIScreen.getDeviceHeight() - 276 - (self.tabBarController?.tabBar.frame.height ?? 0.0)
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
    
    private lazy var searchView: RWMapSearchView = {
        let view = RWMapSearchView()
        view.isHidden = true
        return view
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
    
    enum MapMode {
        case normal
        case search
    }
    
    private var mapMode: MapMode = .normal {
        didSet {
            switch mapMode {
            case .normal:
                self.tabBarController?.tabBar.isHidden = false
                mapSearchBar.isHidden = false
                searchButton.isHidden = false
                break
            case .search:
                self.tabBarController?.tabBar.isHidden = true
                mapSearchBar.isHidden = true
                searchButton.isHidden = true
                break
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
    private var isFetchingMore = false

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
        setRx()
    }
    
    override func configureUI() {
        super.configureUI()
        self.view.addSubviews([mapView, mapSearchBar, searchButton, setLocationButton, bottomSheet, searchResultBottomSheet, searchView])
        
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
        searchResultBottomSheet.frame = CGRect(x: 0,
                                               y: UIScreen.getDeviceHeight() - (self.tabBarController?.tabBar.frame.height ?? 0),
                                               width: UIScreen.getDeviceWidth(),
                                               height: 276 + (self.tabBarController?.tabBar.frame.height ?? 0))
        
        searchView.frame = self.view.bounds
        
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
    
    private func setRx() {
        
        searchView.backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.mapMode = .normal
                self?.searchView.isHidden = true
                self?.searchView.searchField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
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
        
        mapSearchBar.searchView.rx.gesture(.tap())
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                self?.mapMode = .search
                self?.searchView.isHidden = false
                self?.searchView.searchField.becomeFirstResponder()
                self?.searchView.layoutMode = .IsHistoryEmpty
                self?.reactor?.action.onNext(.searchFieldDidTap)
            }).disposed(by: disposeBag)
        
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
        
        searchView.searchField.rx.text
            .distinctUntilChanged()
            .compactMap({$0})
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.searchFieldInput($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bottomSheet.aroundView.collectionView.rx.didEndDecelerating // infiniteScrolling
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                let height = self.bottomSheet.aroundView.collectionView.frame.height
                let contentHeight = self.bottomSheet.aroundView.collectionView.contentSize.height
                let reachesBottom = (self.bottomSheet.aroundView.collectionView.contentOffset.y > contentHeight - height)
                
                if reachesBottom && !self.isFetchingMore {
                    self.reactor?.action.onNext(.bottomSheetScrollReachesBottom)
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindState(reactor: MapReactor) {
        
        reactor.state.map { $0.mapCategoryFilters }
            .bind(to: mapSearchBar.categoryCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                if index == 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RWMapSearchBarCollectionViewBookmarkCell.identifier, for: indexPath) as? RWMapSearchBarCollectionViewBookmarkCell else { return UICollectionViewCell() }
                    cell.setSelectedLayout(reactor.currentState.mapFilterSelected[item] ?? false)
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RWMapSearchBarCollectionViewCell.identifier, for: indexPath) as? RWMapSearchBarCollectionViewCell else { return UICollectionViewCell() }
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
                        marker.touchHandler = { [weak self] (overlay) -> Bool in
                            let action = Reactor.Action.selectMapMarker(data.storeID)
                            self?.reactor?.action.onNext(action)
                            self?.searchResultBottomSheet.showSheet(atState: .expanded)
                            return true
                        }
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
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: url))
            }.disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.mapMarkerSelectData }
            .subscribe(onNext: { [weak self] data in
                guard let url = URL(string: data.storeImage) else { return }
                self?.searchResultBottomSheet.searchResultView.tagRelay.accept(data.category)
                self?.searchResultBottomSheet.searchResultView.storeNameLabel.text = data.storeName
                self?.searchResultBottomSheet.searchResultView.imageView.kf.setImage(with: ImageResource(downloadURL: url))
            })
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.mapSearchHistories }
            .do(onNext: { [weak self] in
                self?.searchView.layoutMode = $0.isEmpty ? .IsHistoryEmpty : .IsHistoryExists
            })
            .bind(to: searchView.historyTableView.rx.items(cellIdentifier: RWMapSearchHistoryTableViewCell.identifier, cellType: RWMapSearchHistoryTableViewCell.self)) { indexPath, item, cell in
                cell.titleLabel.text = item.name
                let formatter = DateFormatter()
                formatter.dateFormat = "MM.dd"
                cell.dateLabel.text = formatter.string(from: item.date)
                cell.iconImageView.image = item.isStore ? UIImage(named: "icon_search_store") : UIImage(named: "icon_search_location")
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.mapKeywordSearchData }
            .do(onNext: { [weak self] _ in
                self?.searchView.layoutMode = .IsSearchResultExists
            })
            .bind(to: searchView.searchTableView.rx.items(cellIdentifier: RWMapSearchTableViewCell.identifier, cellType: RWMapSearchTableViewCell.self)) { [weak self] indexPath, item, cell in
                guard let self = self, let searchText = self.searchView.searchField.text else { return }
                cell.addressLabel.text = item.address
                if let storeName = item.storeName, let storeId = item.storeID  { // 매장 검색결과
                    cell.iconImageView.image = UIImage(named: "icon_search_store")
                    cell.storeId = storeId
                    let titleText = NSMutableAttributedString(string: storeName, attributes: [.font: UIFont.body1, .foregroundColor: UIColor.runwayBlack])
                    let attributeRange = (storeName as NSString).range(of: searchText)
                    titleText.addAttributes([.font: UIFont.body1M, .foregroundColor: UIColor.primary], range: attributeRange)
                    cell.titleLabel.attributedText = titleText
                } else if let regionName = item.region, let regionId = item.regionID { // 장소 검색결과
                    cell.iconImageView.image = UIImage(named: "icon_search_location")
                    cell.regionId = regionId
                    let titleText = NSMutableAttributedString(string: regionName, attributes: [.font: UIFont.body1, .foregroundColor: UIColor.runwayBlack])
                    let attributeRange = (regionName as NSString).range(of: searchText)
                    titleText.addAttributes([.font: UIFont.body1M, .foregroundColor: UIColor.primary], range: attributeRange)
                    cell.titleLabel.attributedText = titleText
                } else {
                    return
                }
            }.disposed(by: disposeBag)
    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        switch mapMode {
        case .normal:
            isHiddenHelperViews.toggle()
        case .search:
            searchResultBottomSheet.showSheet(atState: .folded)
        }
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
