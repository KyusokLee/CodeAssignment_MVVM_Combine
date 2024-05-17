//
//  DetailViewController.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/16.
//

import UIKit
import SnapKit
import SDWebImage

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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    /// Descriptionを表示するlabel
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    /// Userのプロフィール画像
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    /// User名を表示するためのlabel
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
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
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.8)
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
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    private lazy var watchersCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    private lazy var forksCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    private lazy var openIssuesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.8)
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
    private func configure(with model: Repositories.Repository) {
        let defaultImage = UIImage(systemName: "person.circle")?.withTintColor(.systemMint, renderingMode: .alwaysOriginal)
        
        repositoryNameLabel.text = model.name
        descriptionLabel.text = model.description
        userNameLabel.text = model.owner.userName
        languageNameLabel.text = model.language
        starCountsLabel.text = formatNumberToStringWithSeparator(model.stargazersCount ?? 0) + Constants.starsExplainString
        watchersCountLabel.text = formatNumberToStringWithSeparator(model.watchersCount ?? 0) + Constants.watchersExplainString
        forksCountLabel.text = formatNumberToStringWithSeparator(model.forksCount ?? 0) + Constants.forksExplainString
        openIssuesCountLabel.text = formatNumberToStringWithSeparator(model.openIssuesCount ?? 0) + Constants.openIssuesExplainString
        
        if let urlString = model.owner.profileImageString,
           let url = URL(string: urlString) {
            userImageView.sd_setImage(with: url, placeholderImage: defaultImage) { [weak self] (image, error, _, _) in
                guard let self else { return }
                if let error {
                    // ロード中にエラーが発生する場合や、URLが無効な場合はdefaultの画像を表示
                    print("error: \(error.localizedDescription)")
                    self.userImageView.image = defaultImage
                }
                self.userImageView.image = image
            }
        } else {
            userImageView.image = defaultImage
        }
    }
    
    /** 数字をdecimal StyleのString型としてformatする
     - Repositoryの中に、funcやcomputed propertyとして定義するより、ここで関数として作った理由は、format作業をする対象が複数だからである
    */
    private func formatNumberToStringWithSeparator(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
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
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            constraint.leading.equalTo(view.snp.leading).offset(20)
            constraint.trailing.equalTo(view.snp.trailing).offset(-20)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        userImageView.snp.makeConstraints { constraint in
            constraint.top.equalTo(backgroundCardView.snp.top).offset(20)
            constraint.height.equalTo(250)
            constraint.width.equalTo(250)
            constraint.centerX.equalTo(backgroundCardView.snp.centerX)
        }
        
        userNameLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(userImageView.snp.bottom).offset(10)
            constraint.leading.greaterThanOrEqualTo(backgroundCardView.snp.leading).offset(20)
            constraint.trailing.lessThanOrEqualTo(backgroundCardView.snp.trailing).offset(-20)
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
        }
        
        starButton.snp.makeConstraints { constraint in
            constraint.height.equalTo(50)
            constraint.width.equalTo(50)
            constraint.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            constraint.leading.equalTo(backgroundCardView.snp.leading).offset(20)
        }
        
        starCountsLabel.snp.makeConstraints { constraint in
            constraint.centerY.equalTo(starButton.snp.centerY)
            constraint.leading.equalTo(starButton.snp.trailing).offset(8)
        }
        
        languageColorView.snp.makeConstraints { constraint in
            constraint.height.equalTo(20)
            constraint.width.equalTo(20)
            constraint.centerY.equalTo(starCountsLabel.snp.centerY)
            constraint.leading.equalTo(starCountsLabel.snp.trailing).offset(20)
        }
        
        languageNameLabel.snp.makeConstraints { constraint in
            constraint.centerY.equalTo(languageColorView.snp.centerY)
            constraint.leading.equalTo(languageColorView.snp.trailing).offset(8)
            constraint.trailing.lessThanOrEqualTo(backgroundCardView.snp.trailing).offset(-20)
        }
        
        watchersCountLabel.snp.makeConstraints { constraint in
            constraint.top.greaterThanOrEqualTo(languageNameLabel.snp.bottom).offset(20)
            constraint.bottom.equalTo(forksCountLabel.snp.top).offset(-12)
            constraint.leading.greaterThanOrEqualTo(backgroundCardView.snp.leading).offset(20)
            constraint.trailing.equalTo(backgroundCardView.snp.trailing).offset(-20)
        }
        
        forksCountLabel.snp.makeConstraints { constraint in
            constraint.bottom.equalTo(openIssuesCountLabel.snp.top).offset(-12)
            constraint.leading.greaterThanOrEqualTo(backgroundCardView.snp.leading).offset(20)
            constraint.trailing.equalTo(backgroundCardView.snp.trailing).offset(-20)
        }
        
        openIssuesCountLabel.snp.makeConstraints { constraint in
            constraint.bottom.equalTo(backgroundCardView.snp.bottom).offset(-20)
            constraint.leading.greaterThanOrEqualTo(backgroundCardView.snp.leading).offset(20)
            constraint.trailing.equalTo(backgroundCardView.snp.trailing).offset(-20)
        }
    }
}
