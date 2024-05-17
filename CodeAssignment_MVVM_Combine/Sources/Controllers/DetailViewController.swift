//
//  DetailViewController.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/16.
//

import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    
    /// リポジトリのデータを入れるbackgroundView
    private lazy var backgroundCardView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    
    /// リポジトリ名を表示するlabel
    private lazy var repositoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    /// Descriptionを表示するlabel
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        // Descriptionを全て表示するために 0に設定
        label.numberOfLines = 0
        return label
    }()
    
    /// Userのプロフィール画像
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// User名を表示するためのlabel
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    /// お気に入りに入れるためのStarボタン
    // Starボタンは、VCからのInput 処理をbindする必要があるので、currentValueSubjectの方に変えた方がいいかも
    private lazy var starButton: UIButton = {
        let button = UIButton()
        let starImage = UIImage(systemName: "star")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        button.setImage(starImage, for: .normal)
        return button
    }()
    
    /// starの数を表示するLabel
    private lazy var starCountsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    /// 言語ごとに色をつけて表示させるためのView
    private lazy var languageColorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemPink
        return view
    }()
    
    private lazy var languageNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var watchersCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var forksCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var openIssuesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    static func instantiate(with repository: Repositories.Repository) -> DetailViewController {
        let controller = DetailViewController()
        controller.loadViewIfNeeded()
        controller.configure(with: repository)
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        languageColorView.layer.cornerRadius = languageColorView.frame.height / 2
    }
}

extension DetailViewController {
    private func configure(with repository: Repositories.Repository) {
        
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        
        setupNavigationController()
        setAddSubViews()
        setupConstraints()
    }
    
    private func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        // NavigationBarの下部線を隠す
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setAddSubViews() {
        view.addSubview(backgroundCardView)
        view.addSubview(repositoryNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(starButton)
        view.addSubview(starCountsLabel)
        view.addSubview(languageColorView)
        view.addSubview(languageNameLabel)
        view.addSubview(watchersCountLabel)
        view.addSubview(forksCountLabel)
        view.addSubview(openIssuesCountLabel)
    }
    
    private func setupConstraints() {
        backgroundCardView.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            constraint.leading.equalTo(view.snp.leading).offset(20)
            constraint.trailing.equalTo(view.snp.trailing).offset(-20)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        userImageView.snp.makeConstraints { constraint in
            constraint.top.equalTo(backgroundCardView.snp.top).offset(20)
            constraint.height.equalTo(150)
            constraint.width.equalTo(150)
            constraint.centerX.equalTo(backgroundCardView.snp.centerX)
        }
        
        userNameLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(userImageView.snp.bottom).offset(10)
            constraint.leading.greaterThanOrEqualTo(backgroundCardView.snp.leading).offset(20)
            constraint.trailing.greaterThanOrEqualTo(backgroundCardView.snp.trailing).offset(-20)
            constraint.centerX.equalTo(userImageView.snp.centerX)
        }
        
        repositoryNameLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(userNameLabel.snp.bottom).offset(20)
            constraint.leading.equalTo(backgroundCardView.snp.leading).offset(20)
            constraint.trailing.equalTo(backgroundCardView.snp.trailing).offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(repositoryNameLabel.snp.bottom).offset(10)
            constraint.leading.equalTo(backgroundCardView.snp.leading).offset(20)
            constraint.trailing.equalTo(backgroundCardView.snp.trailing).offset(-20)
            constraint.bottom.equalTo(starButton.snp.top).offset(-10)
        }
        
        starButton.snp.makeConstraints { constraint in
            constraint.height.equalTo(25)
            constraint.width.equalTo(25)
            constraint.leading.equalTo(backgroundCardView.snp.leading).offset(20)
        }
        
        starCountsLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            constraint.leading.equalTo(view.snp.leading).offset(20)
            constraint.trailing.equalTo(view.snp.trailing).offset(-20)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        languageColorView.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            constraint.leading.equalTo(view.snp.leading).offset(20)
            constraint.trailing.equalTo(view.snp.trailing).offset(-20)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        languageNameLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            constraint.leading.equalTo(view.snp.leading).offset(20)
            constraint.trailing.equalTo(view.snp.trailing).offset(-20)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        watchersCountLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            constraint.leading.equalTo(view.snp.leading).offset(20)
            constraint.trailing.equalTo(view.snp.trailing).offset(-20)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        forksCountLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            constraint.leading.equalTo(view.snp.leading).offset(20)
            constraint.trailing.equalTo(view.snp.trailing).offset(-20)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        openIssuesCountLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            constraint.leading.equalTo(view.snp.leading).offset(20)
            constraint.trailing.equalTo(view.snp.trailing).offset(-20)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}
