//
//  LaunchScreenViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/16.
//

import UIKit
import Lottie

final class LaunchScreenViewController: UIViewController {
    
    private let animationView: AnimationView = {
        let view = AnimationView(name: "logo_moving")
        view.loopMode = .playOnce
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let streetImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image_street_short"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.onboardBlue
        configureUI()
        animationView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.stop()
    }
    
    private func configureUI() {
        view.addSubviews([animationView, streetImage])
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(view.getSafeArea().top + 104)
        }
        
        streetImage.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.getDeviceWidth() * 0.772)
        }
    }
}
