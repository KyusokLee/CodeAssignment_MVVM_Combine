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
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    /// Descriptionを表示するlabel
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        // Descriptionを全て表示するために 0に設定
        label.numberOfLines = 0
        return label
    }()
    
    /// Userのプロフィール画像と名前を括って表示するためのaccessoryView
    private lazy var userAccessoryView: UIView = {
        let view = UIView()
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
        return label
    }()
    
    /// お気に入りに入れるためのStarボタン
    // Starボタンは、VCからのInput 処理をbindする必要があるので、currentValueSubjectの方に変えた方がいいかも
    private lazy var starButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    /// starの数を表示するLabel
    private lazy var starCountsLabel: UILabel = {
        let label = UILabel()
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
    
    /// RepositoriesForViewのModelのデータに基づいて、Cellのデータを確立させる
//    func configure(with model: Reposit) {
//        
//    }
    
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
            constraint.left.equalTo(contentView.snp.leading).offset(15)
            constraint.right.greaterThanOrEqualTo(contentView.snp.trailing).offset(-15)
            constraint.top.equalTo(contentView.snp.top).offset(15)
        }
    }
    
    private func setupDescriptionLabelConstraints() {
        
    }
    
    private func setupUserAccessoryViewConstraints() {
        
    }
    
    private func setupUserImageViewConstraints() {
        
    }
    
    private func setupUserNameLabelConstraints() {
        
    }
    
    private func setupStarButtonConstraints() {
        
    }
    
    private func setupStarCountsLabelConstraints() {
        
    }
    
    private func setupLanguageColorViewConstraints() {
        
    }
    
    private func setupLanguageNameLabelConstraints() {
        
    }
}
