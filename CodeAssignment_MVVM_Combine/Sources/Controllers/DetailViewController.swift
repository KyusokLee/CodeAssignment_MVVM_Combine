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
    
    /// ScrollViewで、backgroundCardViewをScroll可能にする
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    /// ScrollViewのContentView
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
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
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    /// お気に入りに入れるためのStarボタン
    // Starボタンは、VCからのInput 処理をbindする必要があるので、currentValueSubjectの方に変えた方がいいかも
    private lazy var starButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "star")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        config.contentInsets = .zero
        config.imagePadding = .zero
        config.imagePlacement = .all
        let button = UIButton(configuration: config)
        return button
    }()
    
    /// starの数を表示するLabel
    private lazy var starCountsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    /** 言語ごとに色をつけて表示させるためのView
     - starButtonをUIButton.Configurationを用いた作成に変えた後、layoutSubViewsでcornerRadiusを設定しようとしたら、反映されなかった。
     - そのため、インスタンス生成時にcornerRadiusをするようにした
     */
    private lazy var languageColorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.colorViewHeightSize / 2.0
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
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var forksCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var openIssuesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.7)
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
}

extension DetailViewController {
    private func configure(with model: Repositories.Repository) {
        let defaultImage = UIImage(systemName: "person.circle")?.withTintColor(.systemMint, renderingMode: .alwaysOriginal)
        
        repositoryNameLabel.text = model.name
        descriptionLabel.text = model.description
        userNameLabel.text = model.owner.userName
        languageNameLabel.text = model.language
        starCountsLabel.text = formatNumberToStringWithSeparator(model.stargazersCount) + Constants.starsExplainString
        watchersCountLabel.text = formatNumberToStringWithSeparator(model.watchersCount) + Constants.watchersExplainString
        forksCountLabel.text = formatNumberToStringWithSeparator(model.forksCount) + Constants.forksExplainString
        openIssuesCountLabel.text = formatNumberToStringWithSeparator(model.openIssuesCount) + Constants.openIssuesExplainString
        
        if let url = URL(string: model.owner.profileImageString) {
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
        // backgroundCardViewのSubViewを追加
        [repositoryNameLabel, descriptionLabel, userImageView, userNameLabel, starButton, starCountsLabel, languageColorView, languageNameLabel, watchersCountLabel, forksCountLabel, openIssuesCountLabel].forEach { view in
            backgroundCardView.addSubview(view)
        }
        
        contentView.addSubview(backgroundCardView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { constraint in
            constraint.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { constraint in
            constraint.edges.equalTo(scrollView.contentLayoutGuide)
            constraint.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        // backgroundCardViewのSubViewのUIの equalTo Leading Constraint設定
        [userNameLabel, repositoryNameLabel, descriptionLabel, starButton].forEach { view in
            view.snp.makeConstraints { constraint in
                constraint.leading.equalTo(backgroundCardView.snp.leading).offset(Constants.leftPadding)
            }
        }
        
        // backgroundCardViewのSubViewのUIの greaterThanOrEqualTo Leading Constraint設定
        [watchersCountLabel, forksCountLabel, openIssuesCountLabel].forEach { view in
            view.snp.makeConstraints { constraint in
                constraint.leading.greaterThanOrEqualTo(backgroundCardView.snp.leading).offset(Constants.leftPadding)
            }
        }
        
        // backgroundCardViewのSubViewのUIのtrailing Constraint設定
        [userNameLabel, repositoryNameLabel, descriptionLabel, languageNameLabel, watchersCountLabel, forksCountLabel, openIssuesCountLabel].forEach { view in
            view.snp.makeConstraints { constraint in
                constraint.trailing.equalTo(backgroundCardView.snp.trailing).offset(-Constants.insetRightPadding)
            }
        }
        
        backgroundCardView.snp.makeConstraints { constraint in
            constraint.top.equalTo(contentView.snp.top).offset(30)
            constraint.leading.equalTo(contentView.snp.leading).offset(20)
            constraint.trailing.equalTo(contentView.snp.trailing).offset(-20)
            constraint.bottom.equalTo(contentView.snp.bottom).offset(-30)
        }
        
        userImageView.snp.makeConstraints { constraint in
            constraint.top.equalTo(backgroundCardView.snp.top).offset(20)
            constraint.height.equalTo(250)
            constraint.width.equalTo(250)
            constraint.centerX.equalTo(backgroundCardView.snp.centerX)
        }
        
        userNameLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(userImageView.snp.bottom).offset(10)
            constraint.centerX.equalTo(userImageView.snp.centerX)
        }
        
        repositoryNameLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(userNameLabel.snp.bottom).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(repositoryNameLabel.snp.bottom).offset(10)
        }
        
        starButton.snp.makeConstraints { constraint in
            constraint.height.equalTo(20)
            constraint.width.equalTo(20)
            constraint.top.equalTo(descriptionLabel.snp.bottom).offset(20)
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
        }
        
        watchersCountLabel.snp.makeConstraints { constraint in
            constraint.top.greaterThanOrEqualTo(languageNameLabel.snp.bottom).offset(20)
            constraint.bottom.equalTo(forksCountLabel.snp.top).offset(-12)
        }
        
        forksCountLabel.snp.makeConstraints { constraint in
            constraint.bottom.equalTo(openIssuesCountLabel.snp.top).offset(-12)
        }
        
        openIssuesCountLabel.snp.makeConstraints { constraint in
            constraint.bottom.equalTo(backgroundCardView.snp.bottom).offset(-20)
        }
    }
}
