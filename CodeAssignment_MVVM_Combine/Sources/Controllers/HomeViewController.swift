//
//  ViewController.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import UIKit
import SnapKit
import Combine

// MARK: - Life Cycle & Variables
class HomeViewController: UIViewController {
    
    /// Get リクエストのための簡易Button
    private lazy var getAPIButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("GET", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        /// Snapkitライブラリで既にtranslatesAutoresizingMaskIntoConstraintsをfalseにしているので、記載不要
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        /// addActionを使うことで、objc funcを使わなくても済む
        /// UIActionのclosureを用いて関数を呼び出す
        button.addAction(UIAction.init { [weak self] _ in
            self?.didTapGetAPIButton()
        }, for: .touchUpInside)
        
        return button
    }()
    
    /// ViewModel
    private let viewModel = HomeViewModel()
    /// Cancellables
    /// storeを利用するため : AnyCancellableを保存しておいて、当該の変数がdeinitされるとき、subscribeをキャンセルする方法
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setupController()
        setupConstraints()
    }
}

// MARK: - Functions & Logics
extension HomeViewController {
    /// Controllerをセットアップする
    private func setupController() {
        view.backgroundColor = .systemBackground
        setupObservers()
    }
    
    /// ViewModelなどViewController側で常に監視しておくべき対象を、セットアップ
    /// イベント発生時に正常にデータバインドをするために、Observerを設定する感じ
    private func setupObservers() {
        viewModel.getAPIButtonColorSubject.sink { [weak self] buttonColor in
            self?.getAPIButton.backgroundColor = buttonColor
        }
        .store(in: &cancellables)
    }
    
    /// カスタムで作ったViewを全部追加する
    private func setAddSubViews() {
        view.addSubview(getAPIButton)
    }
    
    /// Layoutの制約を調整する
    private func setupConstraints() {
        setupGetAPIButtonConstraints()
    }
    
    /// GetAPI ButtonのConstraints
    /// SnapKitを用いて、実装する
    private func setupGetAPIButtonConstraints() {
        getAPIButton.snp.makeConstraints { constraint in
            constraint.height.equalTo(80)
            constraint.width.equalTo(80)
            constraint.centerX.equalToSuperview()
            constraint.centerY.equalToSuperview()
        }
    }
    
    /// GETメソッドのAPI Request を送信するボタンをタップ
    private func didTapGetAPIButton() {
        viewModel.didTapGetAPIButton()
    }
}
