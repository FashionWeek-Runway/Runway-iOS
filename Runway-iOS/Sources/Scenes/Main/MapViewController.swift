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

final class MapViewController: BaseViewController { // naver map sdk에서 카메라 delegate 프로퍼티 지원하지 않아 delegate pattern 사용
    
    private lazy var mapView: NMFNaverMapView = {
        let view = NMFNaverMapView()
        view.mapView.touchDelegate = self
        view.mapView.addCameraDelegate(delegate: self)
        view.showLocationButton = false
        return view
    }()
    
    private lazy var setLocationButton: NMFLocationButton = {
        let button = NMFLocationButton()
        button.clipsToBounds = true
        button.mapView = self.mapView.mapView
        return button
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
    }
    
    override func configureUI() {
        super.configureUI()
        self.view.addSubviews([mapView, setLocationButton])
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        setLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaInsets).offset(-136)
        }
    }
    
    func toggleTabbar() {
        guard var frame = tabBarController?.tabBar.frame else { return }
        let hidden = frame.origin.y == view.frame.size.height
        frame.origin.y = hidden ? view.frame.size.height - frame.size.height : view.frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = frame
        }
    }
}

extension MapViewController: View {
    func bind(reactor: MapReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MapReactor) {
    }
    
    private func bindState(reactor: MapReactor) {
    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        toggleTabbar()
    }
}

extension MapViewController: NMFMapViewCameraDelegate {

}
