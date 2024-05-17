//
//  RepositoryCollectionViewCell.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/13.
//

import UIKit
import Combine
import SnapKit
import SDWebImage

final class RepositoryCollectionViewCell: UICollectionViewCell {
    /// リポジトリ名を表示するlabel
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
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
    
    /** Userのプロフィール画像と名前を括って表示するためのaccessoryView
     - userAccessoryViewは、userImageViewとuserNameLabelのサイズに合わせて動的に決める予定
     */
    private lazy var userAccessoryView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemGray4
        return view
    }()
    
    /// Userのプロフィール画像
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
//        imageView.image = UIImage(systemName: "person.circle")?.withTintColor(.systemMint, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    /// User名を表示するためのlabel
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    /// お気に入りに入れるためのStarボタン
    // Starボタンは、VCからのInput 処理をbindする必要があるので、currentValueSubjectの方に変えた方がいいかも
    private lazy var starButton: UIButton = {
        let button = UIButton()
//        let config = UIImage.SymbolConfiguration(
//            pointSize: 20,
//            weight: .medium,
//            scale: .medium
//        )
//        let startImage = UIImage(
//            systemName: "star",
//            withConfiguration: config)?
//            .withTintColor(.systemGray5, renderingMode: .alwaysOriginal)
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
    
    // コードベースなので、ここで必須のfuncを実装する
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    // nibファイルを用いて実装していないことをfatalErrorを用いて明確にする
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** Cellレイアウトが確定されたタイミングで呼び出されるので、CellのSubViewのCornerRadiusのような設定が可能
     - lazy varのクロージャ内ではビューのフレームがまだ決定されていないため、frame.heightを使用しても正しい値を取得できない
     - そのため、layoutSubViewsをオーバーライドして設定する
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userAccessoryView.layer.cornerRadius = userAccessoryView.frame.height / 2
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        languageColorView.layer.cornerRadius = languageColorView.frame.height / 2
    }
}

// MARK: - Function and Logics
extension RepositoryCollectionViewCell {
    /** Cellのデータの設定を行う
     - 今後、RepositoriesForViewのModelのデータに基づいて、Cellのデータを確立させる
    */
    func configure(with model: Repositories.Repository) {
        let defaultImage = UIImage(systemName: "person.circle")?.withTintColor(.systemMint, renderingMode: .alwaysOriginal)
        
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        userNameLabel.text = model.owner.userName
        starCountsLabel.text = formatNumberToString(model.stargazersCount ?? 0)
        languageNameLabel.text = model.language
        
        if let urlString = model.owner.profileImageString,
           let url = URL(string: urlString) {
            // completedに入れないと、常にplaceHolderImageしか表示されない仕組み
            // completion handlerを用いて、画像のロード中にエラーが発生した場合や、URLが無効な場合にデフォルトの画像を表示する仕組みである
            userImageView.sd_setImage(with: url, placeholderImage: defaultImage) { [weak self] (image, error, cacheType, url) in
                guard let self else { return }
                if let error = error {
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
    
    /// 数字が１万を超えたら、1.~万みたいにString型としてformatする
    private func formatNumberToString(_ number: Int) -> String {
        if number >= 10000 {
            let formattedNumber = Double(number) / 10000
            return String(format: "%.1f万", formattedNumber)
        } else {
            return String(number)
        }
    }
    
    private func setupUI() {
        setAddSubViews()
        setupConstraints()
    }
    
    private func setAddSubViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        userAccessoryView.addSubview(userImageView)
        userAccessoryView.addSubview(userNameLabel)
        contentView.addSubview(userAccessoryView)
        contentView.addSubview(starButton)
        contentView.addSubview(starCountsLabel)
        contentView.addSubview(languageColorView)
        contentView.addSubview(languageNameLabel)
    }
    
    /* MARK: -
       contentView(W: superView.frame.W, H: superView.frame.H)
              ┣ nameLabel(W: contentView.frame.W - 40, H: textのsizeに合わせる)
              ┣ descriptionLabel(W: contentView.frame.W - 40, H: textのsizeに合わせる)
              ┣ userAccessoryView(W: 25 + userNameLabelのSizeに合わせる, H: 30)
                        ┣ userImageView(W: 25, H: 25)
                        ┣ userNameLabel(W: textのsizeに合わせる, H: 20)
              ┣ starButton(W: 25, H:25)
              ┣ starCountsLabel(W: textのsizeに合わせる, H: textのsizeに合わせる)
              ┣ languageColorView(W: 15, H: 15)
              ┣ languageNameLabel(W: textのsizeに合わせる, H: textのsizeに合わせる)
    */
    
    /// Layoutの制約を設定
    private func setupConstraints() {
        /// ContentViewのConstraints
        contentView.snp.makeConstraints { constraint in
            constraint.edges.equalToSuperview()
            constraint.width.equalToSuperview()
        }
        
        /// NameLabelのConstraints
        nameLabel.snp.makeConstraints { constraint in
            constraint.leading.equalTo(contentView.snp.leading).offset(20)
            constraint.trailing.equalTo(contentView.snp.trailing).offset(-20)
            constraint.top.equalTo(contentView.snp.top).offset(10)
            constraint.bottom.equalTo(descriptionLabel.snp.top).offset(-15)
        }
        
        /// descriptionLabelのConstraints
        descriptionLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(nameLabel.snp.bottom).offset(15)
            constraint.bottom.equalTo(userAccessoryView.snp.top).offset(-15)
            constraint.leading.equalTo(contentView.snp.leading).offset(20)
            constraint.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
        
        /// userAccessoryViewのConstraints
        userAccessoryView.snp.makeConstraints { constraint in
            constraint.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            constraint.bottom.equalTo(starButton.snp.top).offset(-15)
            constraint.leading.equalTo(contentView.snp.leading).offset(20)
            constraint.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-20)
        }
        
        /// userImageViewのConstraints
        userImageView.snp.makeConstraints { constraint in
            constraint.height.equalTo(25)
            constraint.width.equalTo(25)
            constraint.centerY.equalTo(userNameLabel.snp.centerY)
            constraint.leading.equalTo(userAccessoryView.snp.leading).offset(12)
            constraint.trailing.equalTo(userNameLabel.snp.leading).offset(-10)
        }
        
        /// userNameLabelのConstraints
        userNameLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(userAccessoryView.snp.top).offset(5)
            constraint.bottom.equalTo(userAccessoryView.snp.bottom).offset(-5)
            constraint.leading.equalTo(userImageView.snp.trailing).offset(12)
            constraint.trailing.equalTo(userAccessoryView.snp.trailing).offset(-12)
        }
        
        /// starButtonのConstraints
        starButton.snp.makeConstraints { constraint in
            constraint.height.equalTo(25)
            constraint.width.equalTo(25)
            constraint.top.equalTo(userAccessoryView.snp.bottom).offset(20)
            constraint.bottom.equalTo(contentView.snp.bottom).offset(-8)
            constraint.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        /// starCountsLabelのConstraints
        starCountsLabel.snp.makeConstraints { constraint in
//            constraint.top.equalTo(userAccessoryView.snp.bottom).offset(20)
//            constraint.bottom.equalTo(contentView.snp.bottom).offset(-8)
            constraint.centerY.equalTo(starButton.snp.centerY)
            constraint.leading.equalTo(starButton.snp.trailing).offset(5)
        }
        
        /// languageColorViewのConstraints
        languageColorView.snp.makeConstraints { constraint in
            constraint.height.equalTo(15)
            constraint.width.equalTo(15)
            constraint.centerY.equalTo(starCountsLabel.snp.centerY)
            constraint.leading.equalTo(starCountsLabel.snp.trailing).offset(20)
            constraint.trailing.equalTo(languageNameLabel.snp.leading).offset(-5)
        }
        
        /// languageNameLabelのConstraints
        languageNameLabel.snp.makeConstraints { constraint in
            constraint.centerY.equalTo(languageColorView.snp.centerY)
            constraint.leading.equalTo(languageColorView.snp.trailing).offset(5)
        }
    }
}
