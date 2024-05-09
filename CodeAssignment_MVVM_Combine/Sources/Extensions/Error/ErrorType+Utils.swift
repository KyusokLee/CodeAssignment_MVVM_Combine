//
//  ErrorType+Utils.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import Foundation

/// ErrorTypeごとにどういったErrorかを表示するためのExtension
extension ErrorType {
    var errorTitle: String {
        switch self {
        case .apiServerError:
            return "APIサーバーエラー"
        case .noResponseError:
            return "レスポンスエラー"
        case .decodeError:
            return "デコーディングエラー"
        case .unknownError:
            return "知られていないエラー "
        }
    }
    
    var errorDescription: String {
        switch self {
        case .apiServerError:
            return "サーバーにエラーが起きました。\nもう一度、お試しください。"
        case .noResponseError:
            return "レスポンスがないです。\nもう一度、確認してください。"
        case .decodeError:
            return "データを正しく表示できませんでした。\nもう一度、お試しください。"
        case .unknownError:
            return "不特定エラーが返ってきました。\nもう一度、確認ください。"
        }
    }
}
