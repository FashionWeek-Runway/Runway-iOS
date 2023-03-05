//
//  ReviewReportingViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ReviewReportingViewController: BaseViewController {
    
    
    // MARK: - initializer
    
    init(with reactor: ReviewReportingReactor) {
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

extension ReviewReportingViewController: View {
    func bind(reactor: ReviewReportingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ReviewReportingReactor) {
        
    }
    
    private func bindState(reactor: ReviewReportingReactor) {
        
    }
}
