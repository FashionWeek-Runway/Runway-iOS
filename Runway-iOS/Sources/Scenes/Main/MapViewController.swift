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
    
    private let mapSearchView: RWMapSearchView = RWMapSearchView()
    
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
    
    private var helpViewToggle: Bool = false {
        didSet {
            if helpViewToggle {
                showTabbar()
                showSearchView()
            } else {
                hideTabbar()
                hideSearchView()
            }
        }
    }

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
        self.view.addSubviews([mapView, mapSearchView, setLocationButton])
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        mapSearchView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.getSafeArea().top + 118)
        }
        mapSearchView.setGradientLayer()
        
        setLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.getSafeArea().bottom).offset(-136)
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
        helpViewToggle.toggle()
    }
}

extension MapViewController: NMFMapViewCameraDelegate {

}
