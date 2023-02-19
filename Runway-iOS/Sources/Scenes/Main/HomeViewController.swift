//
//  HomeViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class HomeViewController: BaseViewController {
    
    
    // MARK: - initializer
    
    init(with reactor: HomeReactor) {
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
}

extension HomeViewController: View {
    func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeReactor) {
        
    }
    
    private func bindState(reactor: HomeReactor) {
        
    }
}
