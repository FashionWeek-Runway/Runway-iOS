//
//  ShowRoomDetailViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ShowRoomDetailViewController: BaseViewController {
    
    
    
    
    // MARK: - initializer
    
    init(with reactor: ShowRoomDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
//        backButton.setBackgroundImage(UIImage(named: <#T##String#>), for: <#T##UIControl.State#>)
    }
    
    override func configureUI() {
        super.configureUI()
        self.backButton.imageView?.image = UIImage(named: "")
    }
}

extension ShowRoomDetailViewController: View {
    func bind(reactor: ShowRoomDetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ShowRoomDetailReactor) {
        
    }
    
    private func bindState(reactor: ShowRoomDetailReactor) {
        
    }
}
