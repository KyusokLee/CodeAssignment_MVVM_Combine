//
//  GitHubAPIType.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/08.
//

import Foundation

/// 利用するGitHub APIのエンドポイントを分類して定義し、今後 Userなども検索できるようにする
enum GitHubAPIType {
    // リポジトリを検索
    case searchRepositories
    // リポジトリに星付け・解除
    case starRepository
}
