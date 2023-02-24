//
//  RWBottomSheet.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class RWBottomSheet: UIView {
    
    // MARK: - UI Components
    
    private let grabber: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray200
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    private let touchAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - properties
    
    private let disposeBag = DisposeBag()
    
    // Snap 효과를 위한 케이스
    enum SheetViewState {
        case expanded // 펼침
        case folded // 접음
        case cover // 완전히 덮기
    }
    
    // 펼친 상태 Top
    private lazy var sheetPanMinTopConstant: CGFloat = 138 + getSafeArea().top
    // 접힌 상태 Top
    private lazy var sheetPanMaxTopConstant: CGFloat = UIScreen.getDeviceHeight() - getSafeArea().bottom - 121
    // 덮기 상태 Top
    private lazy var sheetPanCoverTopConstant: CGFloat = UIScreen.getDeviceHeight() - 118 - getSafeArea().top + 14
    // 드래그 하기 전에 Bottom Sheet의 top Constraint value를 저장하기 위한 프로퍼티
    private lazy var sheetPanStartingTopConstant: CGFloat = frame.origin.y
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - func
    
    private func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubviews([grabber, touchAreaView])
        
        grabber.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(38)
            $0.top.equalToSuperview().offset(5.5)
        }
        
        touchAreaView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(14)
        }
    }
    
    private func setupViews() {
        rx.panGesture()
            .when(.began, .changed, .ended)
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                let transition = event.translation(in: self)
                
                switch event.state {
                case .began:
                    self.sheetPanStartingTopConstant = self.frame.origin.y
                case .changed:
                    if self.sheetPanStartingTopConstant + transition.y > self.sheetPanMinTopConstant {
                        self.frame = CGRect(x: 0, y: self.sheetPanStartingTopConstant + transition.y, width: self.frame.width, height: self.frame.height)
                    }
                case .ended:
                    let nearestValue = self.nearest(to: self.frame.origin.y, inValues: [self.sheetPanMinTopConstant, self.sheetPanMaxTopConstant])
                    
                    if nearestValue == self.sheetPanMinTopConstant { // 시트를 펼쳐야 한다
                        self.showSheet(atState: .expanded)
                    } else { // 시트를 접어야 한다
                        self.showSheet(atState: .folded)
                    }
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 여러 후보 값들 중 어느 것이 가장 number값에 가까운지 판별하는 메서드.
    /// - Parameters:
    ///   - number: 기준 값
    ///   - values: 후보값들
    /// - Returns: 후보값들 중 가장 기준 값에 가까운 값
    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) }) else { return number }
        return nearestVal
    }
    
    func showSheet(atState: SheetViewState = .folded) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
            if atState == .folded {
                self.frame = CGRect(x: 0, y: self.sheetPanMaxTopConstant, width: self.frame.width, height: self.frame.height)
            } else {
                self.frame = CGRect(x: 0, y: self.sheetPanMinTopConstant, width: self.frame.width, height: self.frame.height)
            }
        })
//        }, completion: { _ in // 바뀐 시트 상태로 오토레이아웃을 업데이트 시킨다. 해주지 않으면 티켓 뷰 추가시 강제로 내려가는 버그 발생.
//            let currentTop = self.frame.minY
//            self.snp.remakeConstraints {
//                $0.top.equalTo(currentTop)
//                $0.trailing.leading.equalToSuperview()
//                $0.height.equalTo(482 * heightRatio)
//            }
//        })
    }
}
