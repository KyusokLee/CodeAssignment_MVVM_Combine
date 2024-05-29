//
//  DetailViewController.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/16.
//
import UIKit
import SnapKit
import SDWebImage

private enum Const {
    /// layout設定で使うleftPadding
    static let leftPadding: CGFloat = 20
    /// layout設定で使うRightPadding
    static let rightPadding: CGFloat = 20
    /// DetailViewControllerで表すLanguageColorViewのHeight
    static let colorViewHeight: CGFloat = 20
}

final class DetailViewController: UIViewController {
    /** Vertical方向のScrollView
    - ScrollViewで、backgroundCardViewをScroll可能にする
     */
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
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
        imageView.image = UIImage(systemName: "person.circle")?.withTintColor(.systemMint, renderingMode: .alwaysOriginal)
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
    private lazy var starButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "star")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        config.contentInsets = .zero
        config.imagePadding = .zero
        config.imagePlacement = .all
        return UIButton(configuration: config)
    }()
    
    /// starの数を表示するLabel
    private lazy var starCountLabel: UILabel = {
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
        view.layer.cornerRadius = Const.colorViewHeight / 2.0
        view.backgroundColor = .systemPink
        return view
    }()
    
    private lazy var languageNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    private lazy var watchersCountLabel: UILabel = makeCountLabel()
    private lazy var forksCountLabel: UILabel = makeCountLabel()
    private lazy var openIssuesCountLabel: UILabel = makeCountLabel()
    /** descriptionLabelとrepositoryNameLabelを持つStackView
    - StackViewを用いることでconstraintを一概に設定しやすいし、layout設定に関するコードが長くなることを防ぐ
     */
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [repositoryNameLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    /// starButtonとstarCountsLabelを持つStackView
    private lazy var starStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starButton, starCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    /// languageColorViewとlanguageNameLabelを持つStackView
    private lazy var languageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [languageColorView, languageNameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    /// starStackViewとlanguageStackViewを持つStackView
    private lazy var starLanguageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starStackView, languageStackView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    /** starCountLabelを除いたCountLabelを持つStackView
    - constraintを一概に設定しやすいし、layout設定に関するコードが長くなることを防ぐ
     */
    private lazy var countStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [watchersCountLabel, forksCountLabel, openIssuesCountLabel])
        stackView.axis = .vertical
        // subView間のspacing設定
        stackView.spacing = 12
        stackView.alignment = .trailing
        return stackView
    }()
    /// userImageViewとuserNameLabelを除いたUIを持つStackView
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionStackView, starLanguageStackView, countStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    init(repository: Repositories.Repository) {
        super.init(nibName: nil, bundle: nil)
        self.configure(with: repository)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        starCountLabel.text = "\(formatNumberToStringWithSeparator(model.stargazersCount)) stars"
        watchersCountLabel.text = "\(formatNumberToStringWithSeparator(model.watchersCount)) watchers"
        forksCountLabel.text = "\(formatNumberToStringWithSeparator(model.forksCount)) forks"
        openIssuesCountLabel.text = "\(formatNumberToStringWithSeparator(model.openIssuesCount)) issues"
        
        if let url = URL(string: model.owner.profileImageString) {
            userImageView.sd_setImage(with: url, placeholderImage: defaultImage) { [weak self] (image, error, _, _) in
                guard let self else { return }
                if let error {
                    // ロード中にエラーが発生する場合や、URLが無効な場合はdefaultの画像を表示
                    print("error: \(error.localizedDescription)")
                    self.userImageView.image = defaultImage
                } else {
                    self.userImageView.image = image
                }
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
        // HomeVCに戻ると、navigationBarの背景が変わってしまうので、ここもbackgroundColorを設定
        appearance.backgroundColor = .secondarySystemBackground
        // NavigationBarの下部線を隠す
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    private func makeCountLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.7)
        return label
    }
    
    private func setAddSubViews() {
        // backgroundCardViewのSubViewを追加
        [userImageView, userNameLabel, mainStackView].forEach {
            backgroundCardView.addSubview($0)
        }
        
        scrollView.addSubview(backgroundCardView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { constraint in
            constraint.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        backgroundCardView.snp.makeConstraints { constraint in
            constraint.top.equalTo(scrollView.contentLayoutGuide.snp.top).offset(30)
            constraint.width.equalTo(scrollView.snp.width).offset(-(Const.leftPadding + Const.rightPadding))
            constraint.centerX.equalTo(scrollView.snp.centerX)
            constraint.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom).offset(-30)
        }
        
        userImageView.snp.makeConstraints { constraint in
            constraint.top.equalTo(backgroundCardView.snp.top).offset(20)
            constraint.height.equalTo(250)
            constraint.width.equalTo(250)
            constraint.centerX.equalTo(backgroundCardView.snp.centerX)
        }
        
        userNameLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(userImageView.snp.bottom).offset(10)
            constraint.leading.equalTo(backgroundCardView.snp.leading).offset(Const.leftPadding)
            constraint.trailing.equalTo(backgroundCardView.snp.trailing).offset(-Const.rightPadding)
        }
        
        mainStackView.snp.makeConstraints { constraint in
            constraint.top.equalTo(userNameLabel.snp.bottom).offset(20)
            constraint.leading.equalTo(backgroundCardView.snp.leading).offset(Const.leftPadding)
            constraint.trailing.equalTo(backgroundCardView.snp.trailing).offset(-Const.rightPadding)
            constraint.bottom.equalTo(backgroundCardView.snp.bottom).offset(-20)
        }
        
        starButton.snp.makeConstraints { constraint in
            constraint.height.equalTo(20)
            constraint.width.equalTo(20)
        }
        
        languageColorView.snp.makeConstraints { constraint in
            constraint.height.equalTo(Const.colorViewHeight)
            constraint.width.equalTo(Const.colorViewHeight)
        }
    }
}
