//
//  DetailViewController.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/16.
//
import UIKit
import Combine
import SnapKit
import SDWebImage

private enum Const {
    /// layout設定で使うleftPadding
    static let leftPadding: CGFloat = 20
    /// layout設定で使うRightPadding
    static let rightPadding: CGFloat = 20
    /// DetailViewControllerで表すLanguageColorViewのサイズ
    static let colorViewSize: CGFloat = 20
}

final class DetailViewController: UIViewController {

    private var viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()
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
    
    /// UserImageViewを入れるためのContentView
    private lazy var userImageContentView: UIView = {
        let view = UIView()
        return view
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
    
    /// 当該リポジトリのStarの数も一緒に表示するStarボタン
    private lazy var starButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "star")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        config.baseBackgroundColor = .white
        config.imagePlacement = .leading
        // imageとtext間のSpace
        config.imagePadding = 8
        config.contentInsets = .init(top: 10, leading: 8, bottom: 10, trailing: 8)
        config.cornerStyle = .large
        
        // borderLayerの設定
        var backgroundConfig = UIBackgroundConfiguration.clear()
        backgroundConfig.strokeColor = .systemGray2
        backgroundConfig.strokeWidth = 2
        config.background = backgroundConfig

        let button = UIButton(configuration: config)
        button.addAction(.init { [weak self] _ in
            guard let self else { return }
            self.didTapStarButton()
        }, for: .touchUpInside)
        return button
    }()
    
    /** 言語ごとに色をつけて表示させるためのView
    - starButtonをUIButton.Configurationを用いた作成に変えた後、layoutSubViewsでcornerRadiusを設定しようとしたら、反映されなかった。
    - そのため、インスタンス生成時にcornerRadiusをするようにした
     */
    private lazy var languageColorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Const.colorViewSize / 2.0
        view.backgroundColor = .systemPink
        return view
    }()
    
    private lazy var languageNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        // byCharWrapping: 単語ごとじゃなく、一文字ごとに改行する
        label.lineBreakMode = .byCharWrapping
        label.textColor = .black.withAlphaComponent(0.8)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var watchersCountLabel: UILabel = makeCountLabel()
    private lazy var forksCountLabel: UILabel = makeCountLabel()
    private lazy var openIssuesCountLabel: UILabel = makeCountLabel()
    /// starButton, languageColorView, languageNameLabelを持つStackView
    private lazy var starLanguageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starButton, languageColorView, languageNameLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
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
    /// backgroundViewに入れるSubViewを持つStackView
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userImageContentView, userNameLabel, repositoryNameLabel, descriptionLabel, starLanguageStackView, countStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    init(repository: Repositories.Repository) {
        // Swiftではクラスの属性がsuper.initの前に呼び出されないといけない。そのため、initの前に記述
        self.viewModel = .init(repository: repository)
        super.init(nibName: nil, bundle: nil)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
}

extension DetailViewController {
    private func configure() {
        let defaultImage = UIImage(systemName: "person.circle")?.withTintColor(.systemMint, renderingMode: .alwaysOriginal)
        let repository = viewModel.repository

        repositoryNameLabel.text = repository.name
        descriptionLabel.text = repository.description
        userNameLabel.text = repository.owner.userName
        languageNameLabel.text = repository.language
        setStarButtonAttributedTitle(with: formatNumberToStringWithSeparator(repository.stargazersCount))
        watchersCountLabel.text = "\(formatNumberToStringWithSeparator(repository.watchersCount)) watchers"
        forksCountLabel.text = "\(formatNumberToStringWithSeparator(repository.forksCount)) forks"
        openIssuesCountLabel.text = "\(formatNumberToStringWithSeparator(repository.openIssuesCount)) issues"

        guard let url = URL(string: repository.owner.profileImageString) else {
            userImageView.image = defaultImage
            return
        }
        userImageView.sd_setImage(with: url, placeholderImage: defaultImage) { [weak self] (image, error, _, _) in
            guard let self else { return }
            guard let error else {
                self.userImageView.image = image
                return
            }
            // ロード中にエラーが発生する場合や、URLが無効な場合はdefaultの画像を表示
            self.userImageView.image = defaultImage
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
    
    private func bind() {
        viewModel.$repository
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repository in
                guard let self else { return }
                self.setStarButtonAttributedTitle(with: formatNumberToStringWithSeparator(repository.stargazersCount))
            }
            .store(in: &cancellables)

        viewModel.$isStarred
            .receive(on: DispatchQueue.main)
            .sink { [weak self] starState in
                guard let self else { return }
                self.updateStarButtonImageAndColor(with: starState)
            }
            .store(in: &cancellables)

        viewModel.$errorType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self, let error else { return }
                self.presentErrorAlert(error: error)
            }
            .store(in: &cancellables)
    }

    /// エラーTitleとメッセージを表示
    private func presentErrorAlert(error: ErrorType) {
        let alert = UIAlertController(
            title: error.errorTitle,
            message: error.errorDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "確認", style: .default))
        present(alert, animated: true, completion: nil)
    }

    /// StarButtonのImageと色の更新
    private func updateStarButtonImageAndColor(with state: Bool) {
        starButton.configuration?.image = state ? .init(systemName: "star.fill") : .init(systemName: "star")
        starButton.configuration?.baseForegroundColor = state ? .systemYellow : .systemGray3
    }

    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        
        setupNavigationController()
        setAddSubViews()
        setupConstraints()
    }

    // StarButtonのUIButton.Configurationのtitleの設定
    private func setStarButtonAttributedTitle(with title: String) {
        starButton.configuration?.attributedTitle = AttributedString(
            "\(title) stars",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 20, weight: .regular),
                .foregroundColor: UIColor.black.withAlphaComponent(0.8)
            ])
        )
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
        userImageContentView.addSubview(userImageView)
        backgroundCardView.addSubview(mainStackView)
        scrollView.addSubview(backgroundCardView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        // StarButtonのcontent priorityを設定し、buttonのconstraintsが意図通りに設定されないことを防ぐ
        starButton.setContentHuggingPriority(.required, for: .horizontal)
        starButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        starButton.titleLabel?.setContentHuggingPriority(.required, for: .horizontal)
        starButton.titleLabel?.setContentCompressionResistancePriority(.required, for: .horizontal)

        scrollView.snp.makeConstraints { constraint in
            // ScrollIndicatorの挙動がBottomのSafeAreaを超えてしまうので、equalToSuperViewに変更
            constraint.edges.equalToSuperview()
        }
        
        backgroundCardView.snp.makeConstraints { constraint in
            constraint.top.equalTo(scrollView.contentLayoutGuide.snp.top).offset(30)
            constraint.width.equalTo(scrollView.snp.width).offset(-(Const.leftPadding + Const.rightPadding))
            constraint.centerX.equalTo(scrollView.snp.centerX)
            constraint.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom).offset(-30)
        }
        
        userImageView.snp.makeConstraints { constraint in
            constraint.top.equalTo(userImageContentView.snp.top)
            constraint.height.equalTo(250)
            constraint.width.equalTo(250)
            constraint.centerX.equalTo(userImageContentView.snp.centerX)
            constraint.bottom.equalTo(userImageContentView.snp.bottom)
        }
        
        languageColorView.snp.makeConstraints { constraint in
            constraint.height.equalTo(Const.colorViewSize)
            constraint.width.equalTo(Const.colorViewSize)
        }
        
        starLanguageStackView.snp.makeConstraints { constraint in
            constraint.height.equalTo(70)
        }
        
        mainStackView.snp.makeConstraints { constraint in
            constraint.top.equalTo(backgroundCardView.snp.top).offset(20)
            constraint.leading.equalTo(backgroundCardView.snp.leading).offset(Const.leftPadding)
            constraint.trailing.equalTo(backgroundCardView.snp.trailing).offset(-Const.rightPadding)
            constraint.bottom.equalTo(backgroundCardView.snp.bottom).offset(-20)
        }
        
        // mainStackViewのSubViewの中、カスタムでSpacing調整を適用したいViewを特定
        mainStackView.setCustomSpacing(10, after: userImageContentView)
        mainStackView.setCustomSpacing(10, after: repositoryNameLabel)
        // starLanguageStackViewのSubViewの中、カスタムでSpacing調整を適用したいViewを特定
        starLanguageStackView.setCustomSpacing(20, after: starButton)
    }
    
    private func didTapStarButton() {
        viewModel.changeRepositoryStarStatus()
    }
}
