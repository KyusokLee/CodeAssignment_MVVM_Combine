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
        // Snapkitライブラリで既にtranslatesAutoresizingMaskIntoConstraintsをfalseにしているので、記載不要
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        // addActionを使うことで、objc funcを使わなくても済む
        // UIActionのclosureを用いて関数を呼び出す
        button.addAction(.init { [weak self] _ in
            self?.didTapGetAPIButton()
        }, for: .touchUpInside)
        
        return button
    }()
    
    /// ViewModel
    private let viewModel = HomeViewModel()
    /** storeでAnyCancellableを保存しておいて、当該の変数がdeinitされるとき、subscribeをキャンセルする方法
    - Setで複数のSubscription（購読）を１つにまとめることができ、Subscriptionの値を保持する
     */
    private var cancellables = Set<AnyCancellable>()
    private var repositories = [Repository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
}

// MARK: - Functions & Logics
extension HomeViewController {
    /// ViewControllerのUIをセットアップする
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setAddSubViews()
        setupConstraints()
    }
    
    /** ViewModelなどViewController側で常に監視しておくべき対象を、セットアップ
     イベント発生時に正常にデータバインドをするために、Observerを設定する感じ
     
    - Combineで流れたきたデータのアウトプットsinkする
    - sink : Publisherからのイベントを購読する.  つまり、イベントを受信したときの処理を指定できる。
    - receive(on:)：イベントを受け取るスレッドを指定する
    - store: cancellabeなどを保
     */
    private func bind() {
        viewModel.repositoriesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositories in
                guard let self = self else { return }
                self.repositories = repositories
                print(self.repositories)
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
    
    /// GetAPI ButtonのConstraints (SnapKit利用)
    private func setupGetAPIButtonConstraints() {
        getAPIButton.snp.makeConstraints { constraint in
            constraint.height.equalTo(80)
            constraint.width.equalTo(80)
            constraint.centerX.equalToSuperview()
            constraint.centerY.equalToSuperview()
        }
    }
    
    /// GETメソッドのAPI Request を送信するボタンをタップ
    func didTapGetAPIButton() {
        viewModel.didTapGetAPIButton()
    }
}
