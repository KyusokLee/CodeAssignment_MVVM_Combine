//
//  ViewController.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import UIKit
import SnapKit

/// Life Cycle & Variables
class HomeViewController: UIViewController {
    
    /// Get リクエストのための簡易Button
    lazy var getAPIButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("GET", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        /// addActionを使うことで、objc funcを使わなくても済む
        /// UIActionのclosureを用いて関数を呼び出す
        button.addAction(UIAction { [weak self] _ in
            self?.didTapGetAPIButton()
        }, for: .touchUpInside)
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setupController()
        setupConstraints()
        setupUI()
        checkTest()
    }
}

/// Functions & Logics
extension HomeViewController {
    func checkTest() {
        print("success to present HomeViewController without Storyboard")
    }
    
    /// Controllerをセットアップする
    func setupController() {
        view.backgroundColor = .systemBackground
        
        
    }
    
    /// カスタムで作ったViewを全部追加する
    func setAddSubViews() {
        view.addSubview(getAPIButton)
    }
    
    /// UIをセットアップする
    func setupUI() {
        setupGetAPIButton()
    }
    
    /// Getリクエストを送るボタンをセットアップ
    func setupGetAPIButton() {
        
    }
    
    /// Layoutの制約を調整する
    func setupConstraints() {
        setupGetAPIButtonConstraints()
    }
    
    /// GetAPI ButtonのConstraints
    /// SnapKitを用いて、実装する
    func setupGetAPIButtonConstraints() {
        getAPIButton.snp.makeConstraints { constraint in
            constraint.height.equalTo(80)
            constraint.width.equalTo(80)
            constraint.centerX.equalToSuperview()
            constraint.centerY.equalToSuperview()
        }
    }
    
    /// GetメソッドのAPI Request を送信するボタンをタップ
    func didTapGetAPIButton() {
        print("Tapped GetAPIButton")
    }
}
