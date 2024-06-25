//
//  LoadingView.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/27.
//

import UIKit
import SnapKit

final class LoadingView: UIView {
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        return view
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray
        return indicator
    }()
    
    private lazy var searchingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "検索中..."
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    
    var isLoading = false {
        didSet {
            isHidden = !isLoading
            isLoading ? loadingIndicatorView.startAnimating() : loadingIndicatorView.stopAnimating()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadingView {
    private func setupUI() {
        setAddSubViews()
        setupConstraints()
    }
    
    private func setAddSubViews() {
        addSubview(backgroundView)
        addSubview(loadingIndicatorView)
        addSubview(searchingLabel)
    }
    
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { constraint in
            constraint.edges.equalToSuperview()
        }
        
        loadingIndicatorView.snp.makeConstraints { constraint in
            constraint.center.equalToSuperview()
        }
        
        searchingLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(loadingIndicatorView.snp.bottom).offset(8)
            constraint.centerX.equalTo(loadingIndicatorView)
        }
    }
}
