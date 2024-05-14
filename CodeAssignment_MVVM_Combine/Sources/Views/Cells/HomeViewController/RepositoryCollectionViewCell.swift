//
//  RepositoryCollectionViewCell.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/13.
//

import UIKit
import Combine
import SnapKit

final class RepositoryCollectionViewCell: UICollectionViewCell {
    /// リポジトリ名を表示するlabel
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    /// Descriptionを表示するlabel
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        // Descriptionを全て表示するために 0に設定
        label.numberOfLines = 2
        return label
    }()
    
    /// Userのプロフィール画像と名前を括って表示するためのaccessoryView
    private lazy var userAccessoryView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .systemGray4
        return view
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
        view.layer.cornerRadius = view.frame.height / 2
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
    
    /** Cellのデータの設定を行う
     - 今後、RepositoriesForViewのModelのデータに基づいて、Cellのデータを確立させる
    */
    func configure(with model: Repository) {
        nameLabel.text = model.repositoryName ?? ""
        descriptionLabel.text = model.description ?? ""
        userNameLabel.text = model.owner.userName ?? ""
        starCountsLabel.text = "\(model.stargazersCount ?? 0)"
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
    
    /// Layoutの制約を設定
    private func setupConstraints() {
        setupNameLabelConstraints()
        setupDescriptionLabelConstraints()
        setupUserAccessoryViewConstraints()
        setupUserImageViewConstraints()
        setupUserNameLabelConstraints()
        setupStarButtonConstraints()
        setupStarCountsLabelConstraints()
        setupLanguageColorViewConstraints()
        setupLanguageNameLabelConstraints()
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { constraint in
            constraint.height.equalTo(30)
            constraint.leading.equalTo(contentView.snp.leading).offset(20)
            constraint.trailing.greaterThanOrEqualTo(contentView.snp.trailing).offset(-20)
            constraint.top.equalTo(contentView.snp.top).offset(10)
        }
    }
    
    private func setupDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { constraint in
            constraint.height.lessThanOrEqualTo(70)
            constraint.top.equalTo(nameLabel.snp.bottom).offset(8)
            constraint.leading.equalTo(contentView.snp.leading).offset(20)
            constraint.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
    }
    
    private func setupUserAccessoryViewConstraints() {
        userAccessoryView.snp.makeConstraints { constraint in
            constraint.height.equalTo(50)
            constraint.width.equalTo(200).priority(750)
            constraint.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            constraint.bottom.equalTo(starButton.snp.top).offset(-20)
            constraint.leading.equalTo(contentView.snp.leading).offset(20)
        }
    }
    
    private func setupUserImageViewConstraints() {
        userImageView.snp.makeConstraints { constraint in
            constraint.height.equalTo(25)
            constraint.width.equalTo(25)
            constraint.top.equalTo(userAccessoryView.snp.top).offset(5)
            constraint.bottom.equalTo(userAccessoryView.snp.bottom).offset(-5)
            constraint.leading.equalTo(userAccessoryView.snp.leading).offset(12)
            constraint.trailing.equalTo(userNameLabel.snp.leading).offset(-10)
        }
    }
    
    private func setupUserNameLabelConstraints() {
        userNameLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(userAccessoryView.snp.top).offset(5)
            constraint.bottom.equalTo(userAccessoryView.snp.bottom).offset(-5)
            constraint.trailing.equalTo(userAccessoryView.snp.trailing).offset(-12)
        }
    }
    
    private func setupStarButtonConstraints() {
        starButton.snp.makeConstraints { constraint in
            constraint.height.equalTo(20)
            constraint.width.equalTo(20)
            constraint.top.equalTo(userAccessoryView.snp.bottom).offset(20)
            constraint.bottom.equalTo(contentView.snp.bottom).offset(-8)
            constraint.leading.equalTo(contentView.snp.leading).offset(20)
        }
    }
    
    private func setupStarCountsLabelConstraints() {
        starCountsLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(userAccessoryView.snp.bottom).offset(20)
            constraint.bottom.equalTo(contentView.snp.bottom).offset(-8)
            constraint.leading.equalTo(starButton.snp.trailing).offset(5)
        }
    }
    
    private func setupLanguageColorViewConstraints() {
        
    }
    
    private func setupLanguageNameLabelConstraints() {
        
    }
}
