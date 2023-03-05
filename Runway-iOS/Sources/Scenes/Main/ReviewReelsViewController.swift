//
//  ReviewReelsViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ReviewReelsViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        
        return view
    }()
    
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
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .runwayBlack
        
        view.addSubviews([scrollView])
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.getSafeArea().top)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-view.getSafeArea().bottom)
        }
    }
    
    private func addReelsViewsToScrollView(view: [RWReviewReelsView]) {
//        for i in 0..<images.count {
//            let xPos = scrollView.frame.width * CGFloat(i)
//            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
//            imageView.image = images[i]
//            scrollView.addSubview(imageView)
//            scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
//        }
    }
    
    
}

extension ReviewReelsViewController: View {
    func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeReactor) {
        
    }
    
    private func bindState(reactor: HomeReactor) {
        
    }
}
