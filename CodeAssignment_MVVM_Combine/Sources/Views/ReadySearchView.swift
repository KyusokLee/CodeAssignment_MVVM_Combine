//
//  EmptyResultView.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/27.
//

import UIKit
import SnapKit

final class ReadySearchView: UIView {
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "doc.text.magnifyingglass")?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "GitHubのリポジトリが検索できる"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text = "ここに検索結果が表示されます"
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReadySearchView {
    private func setupUI() {
        setAddSubViews()
        setupConstraints()
    }
    
    private func setAddSubViews() {
        [imageView, titleLabel, descriptionLabel].forEach {
            backgroundView.addSubview($0)
        }
        addSubview(backgroundView)
    }
    
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { constraint in
            constraint.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { constraint in
            constraint.top.equalTo(backgroundView.snp.top).offset(80)
            constraint.centerX.equalTo(backgroundView.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(imageView.snp.bottom).offset(15)
            constraint.centerX.equalTo(imageView.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(titleLabel.snp.bottom).offset(8)
            constraint.centerX.equalTo(imageView.snp.centerX)
        }
    }
}
