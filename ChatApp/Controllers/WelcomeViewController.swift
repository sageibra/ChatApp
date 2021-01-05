//
//  WelcomeViewController.swift
//  ChatApp
//
//  Created by Ibragim Akaev on 03/01/2021.
//

import UIKit
import Lottie

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    let animationView = AnimationView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        setupAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("logo")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = view.center
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }

}
