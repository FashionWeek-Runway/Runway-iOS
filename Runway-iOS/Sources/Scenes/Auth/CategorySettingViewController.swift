//
//  CategorySettingViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class CategorySettingViewController: BaseViewController {
    
    var userName: String? = nil
    
    private lazy var guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "\(self.userName ?? "")님의 옷 스타일을\n선택해주세요"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.subheadline1])
        attributedString.addAttributes([.font: UIFont.headline3,
            .foregroundColor: UIColor.primary], range: (text as NSString).range(of: "\(self.userName ?? "")"))
        label.attributedText = attributedString
        label.numberOfLines = 2
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 스타일을 기반으로 매장을 추천해드려요."
        label.textColor = .gray700
        label.font = .body1
        return label
    }()
    
    private let fashionStyleCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 14
        view.collectionViewLayout = layout
        return view
    }()
    
    private let nextButton: RWButton = {
        let button = RWButton()
        button.title = "다음"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<FashionStyleCollectionViewSectionModel> { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .defaultCell(let reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FashionStyleCollectionViewCell.identifier, for: indexPath) as? FashionStyleCollectionViewCell else { return UICollectionViewCell() }
            cell.reactor = reactor
            return cell
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addProgressBar()
        self.progressBar.setProgress(1, animated: false)
        
        self.view.addSubviews([guideTextLabel, captionLabel, fashionStyleCollectionView, nextButton])
        
        guideTextLabel.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }

}


