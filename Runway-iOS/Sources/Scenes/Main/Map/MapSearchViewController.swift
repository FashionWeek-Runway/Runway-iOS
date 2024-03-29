//
//  MapSearchViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/01.
//

import UIKit
import ReactorKit

import FirebaseAnalytics

final class MapSearchViewController: BaseViewController {
    
    let searchField: UITextField = {
        let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.attributedPlaceholder = NSAttributedString(string: "지역, 매장명 검색", attributes: [.font: UIFont.body1, .foregroundColor: UIColor.gray300])
        return field
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    private let emptyImageView = UIImageView(image: UIImage(named: "icon_search_map"))
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "지역이나 매장을 검색하여\n원하는 매장을 찾으세요."
        label.numberOfLines = 0
        label.font = .body1
        label.textColor = .runwayBlack
        label.textAlignment = .center
        return label
    }()
    
    private let resultEmptyImageView = UIImageView(image: UIImage(named: "icon_empty_search_map"))
    let resultEmptyWordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.font = UIFont.headline4
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let resultEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "에 대한 검색결과가 없습니다."
        label.font = .body1
        label.textColor = .runwayBlack
        label.textAlignment = .center
        return label
    }()
    
    private let resultEmptyCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "다른 검색어를 입력해보세요."
        label.font = .body2
        label.textColor = .gray500
        label.textAlignment = .center
        return label
    }()
    
    private let latestLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색"
        label.font = .body2M
        label.textColor = .gray600
        label.isHidden = true
        return label
    }()
    
    let historyClearButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "전체 삭제", attributes: [.font: UIFont.font(.spoqaHanSansNeoRegular, ofSize: 12.0), .foregroundColor: UIColor.gray700]), for: .normal)
        button.isHidden = true
        return button
    }()
    
    let historyTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.rowHeight = 44
        view.showsVerticalScrollIndicator = false
        view.register(RWMapSearchHistoryTableViewCell.self, forCellReuseIdentifier: RWMapSearchHistoryTableViewCell.identifier)
        view.isHidden = true
        return view
    }()
    
    let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 66
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RWMapSearchTableViewCell.self, forCellReuseIdentifier: RWMapSearchTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private let historyRemoveAlertViewController: RWAlertViewController = {
        let controller = RWAlertViewController()
        controller.alertView.titleLabel.text = "검색 내역을 모두 지우시겠어요?"
        controller.alertView.captionLabel.text = "최근 검색어를 삭제하면\n다시 되돌릴 수 없습니다."
        controller.alertView.alertMode = .twoAction
        controller.alertView.leadingButton.title = "아니요"
        controller.alertView.trailingButton.title = "삭제"
        return controller
    }()
    
    
    enum LayoutMode {
        case IsHistoryExists
        case IsHistoryEmpty
        case IsSearchResultExists
        case IsSearchResultEmpty
    }
    
    var layoutMode: LayoutMode = .IsHistoryEmpty {
        didSet {
            switch layoutMode {
            case .IsHistoryEmpty:
                setLayoutIfHistoryIsEmpty()
            case .IsSearchResultEmpty:
                setLayoutIfSearchResultIsEmpty()
            case .IsHistoryExists:
                setLayoutIfHistoryIsExists()
            case .IsSearchResultExists:
                setLayoutIfSearchResultIsExists()
            }
        }
    }
    
    // MARK: - initializer
    
    init(with reactor: MapSearchReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRx()
        
        Analytics.logEvent(Tracking.Event.lookup.rawValue, parameters: [
            "screen_name": Tracking.Screen.map_search_01
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchField.becomeFirstResponder()
    }
    
    override func configureUI() {
        super.configureUI()
        self.view.addSubviews([navigationBarArea,
                          emptyImageView, emptyLabel, resultEmptyImageView, resultEmptyWordLabel, resultEmptyLabel, resultEmptyCaptionLabel,
                          latestLabel, historyClearButton, historyTableView, searchTableView])

        self.navigationBarArea.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(view.getSafeArea().top)
            $0.height.equalTo(51)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBarArea.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        resultEmptyImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBarArea.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        resultEmptyWordLabel.snp.makeConstraints {
            $0.top.equalTo(resultEmptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        resultEmptyLabel.snp.makeConstraints {
            $0.top.equalTo(resultEmptyImageView.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
        }
        
        resultEmptyCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(resultEmptyLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        self.navigationBarArea.addSubviews([backButton, searchField, divider])
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-14)
            $0.height.width.equalTo(24)
        }
        
        searchField.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview()
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        latestLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(divider.snp.bottom).offset(30)
        }
        
        historyClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(latestLabel.snp.centerY)
        }
        
        historyTableView.snp.makeConstraints {
            $0.top.equalTo(latestLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setRx() {
        historyClearButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                self.present(self.historyRemoveAlertViewController, animated: false)
            })
            .disposed(by: disposeBag)
        
        historyRemoveAlertViewController.alertView.leadingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    func setLayoutIfHistoryIsEmpty() {
        self.historyTableView.isHidden = true
        self.searchTableView.isHidden = true
        self.emptyLabel.isHidden = false
        self.emptyImageView.isHidden = false
        self.latestLabel.isHidden = true
        self.historyClearButton.isHidden = true
        
        self.resultEmptyLabel.isHidden = true
        self.resultEmptyImageView.isHidden = true
        self.resultEmptyCaptionLabel.isHidden = true
        self.resultEmptyWordLabel.isHidden = true
    }
    
    func setLayoutIfHistoryIsExists() {
        self.historyTableView.isHidden = false
        self.searchTableView.isHidden = true
        self.emptyLabel.isHidden = true
        self.emptyImageView.isHidden = true
        self.latestLabel.isHidden = false
        self.historyClearButton.isHidden = false
        
        self.resultEmptyLabel.isHidden = true
        self.resultEmptyImageView.isHidden = true
        self.resultEmptyCaptionLabel.isHidden = true
        self.resultEmptyWordLabel.isHidden = true
    }
    
    func setLayoutIfSearchResultIsExists() {
        self.historyTableView.isHidden = true
        self.searchTableView.isHidden = false
        self.emptyLabel.isHidden = true
        self.emptyImageView.isHidden = true
        self.latestLabel.isHidden = true
        self.historyClearButton.isHidden = true
        
        self.resultEmptyLabel.isHidden = true
        self.resultEmptyImageView.isHidden = true
        self.resultEmptyCaptionLabel.isHidden = true
        self.resultEmptyWordLabel.isHidden = true
    }
    
    func setLayoutIfSearchResultIsEmpty() {
        self.historyTableView.isHidden = true
        self.searchTableView.isHidden = true
        self.emptyImageView.isHidden = true
        self.emptyLabel.isHidden = true
        self.latestLabel.isHidden = true
        self.historyClearButton.isHidden = true
        
        self.resultEmptyLabel.isHidden = false
        self.resultEmptyImageView.isHidden = false
        self.resultEmptyCaptionLabel.isHidden = false
        self.resultEmptyWordLabel.isHidden = false
    }
}

extension MapSearchViewController: View {
    func bind(reactor: MapSearchReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MapSearchReactor) {
        
        rx.viewDidLoad.map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap.map { Reactor.Action.backButtonDidtap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchField.rx.controlEvent([.editingChanged, .editingDidEndOnExit])
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { [weak self] _ in Reactor.Action.searchFieldInput(self?.searchField.text ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        historyTableView.rx.itemSelected
            .map { Reactor.Action.selectHistoryItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTableView.rx.itemSelected
            .do(onNext: { _ in
                Analytics.logEvent(Tracking.Event.lookup.rawValue, parameters: [
                    "screen_name": Tracking.Screen.map_02.rawValue
                ])
            })
            .map { Reactor.Action.selectSearchItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        historyRemoveAlertViewController.alertView.trailingButton.rx.tap
            .do(onNext: { [weak self] in self?.dismiss(animated: false)})
            .map { Reactor.Action.historyAllClearButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindState(reactor: MapSearchReactor) {
        
        reactor.state.compactMap { $0.searchHistories }
            .do(onNext: { [weak self] in
                self?.layoutMode = $0.isEmpty ? .IsHistoryEmpty : .IsHistoryExists
            })
            .bind(to: historyTableView.rx.items(cellIdentifier: RWMapSearchHistoryTableViewCell.identifier, cellType: RWMapSearchHistoryTableViewCell.self)) { indexPath, item, cell in
                cell.titleLabel.text = item.name
                cell.selectionStyle = .none
                let formatter = DateFormatter()
                formatter.dateFormat = "MM.dd"
                cell.dateLabel.text = formatter.string(from: item.date)
                cell.iconImageView.image = item.isStore ? UIImage(named: "icon_search_store_small") : UIImage(named: "icon_search_location_small")
                cell.removeButton.rx.tap
                    .map { Reactor.Action.historyRemoveButtonDidTap(item) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.mapKeywordSearchData }.share()
            .bind(to: searchTableView.rx.items(cellIdentifier: RWMapSearchTableViewCell.identifier, cellType: RWMapSearchTableViewCell.self)) { [weak self] indexPath, item, cell in
                guard let self = self, let searchText = self.searchField.text else { return }
                cell.addressLabel.text = item.address
                cell.selectionStyle = .none
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
        
        // TODO: - 정리 필요
        reactor.state.map { $0.mapKeywordSearchData }.share()
            .bind(onNext: { [weak self] in
                if $0.isEmpty == true && self?.searchField.isEditing == false
                    && self?.searchField.text?.isEmpty == false {
                    self?.layoutMode = .IsSearchResultEmpty
                    self?.resultEmptyWordLabel.text = self?.searchField.text
                } else if $0.isEmpty == true && self?.reactor?.currentState.searchHistories?.isEmpty == false {
                    self?.layoutMode = .IsHistoryExists
                } else if $0.isEmpty == false {
                    self?.layoutMode = .IsSearchResultExists
                } else {
                    self?.layoutMode = .IsHistoryEmpty
                }
            }).disposed(by: disposeBag)
        
    }
}
