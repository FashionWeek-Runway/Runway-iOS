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

final class MapViewController: BaseViewController {

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
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
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
