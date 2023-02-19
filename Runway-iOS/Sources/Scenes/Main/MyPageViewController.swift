//
//  MyPageViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class MyPageViewController: BaseViewController {
    
    
    // MARK: - initializer
    
    init(with reactor: MyPageReactor) {
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

extension MyPageViewController: View {
    func bind(reactor: MyPageReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MyPageReactor) {
        
    }
    
    private func bindState(reactor: MyPageReactor) {
        
    }
}
