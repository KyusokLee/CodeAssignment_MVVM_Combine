//
//  ErrorType+Utils.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import Foundation

extension ErrorType {
    var alertTitle: String {
        switch self {
        case .apiServerError:
            return "APIサーバーエラー"
        case .noResponseError:
            return "レスポンスエラー"
        case .decodeError:
            return "デコーディングエラー"
        case .unknownError(status: let status, data: let data, error: let error):
            return "エラー \(error) statusCode: \(status), data: \(data)"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .apiServerError:
            return "サーバーにエラーが起きました。\nもう一度、お試しください。"
        case .noResponseError:
            return "レスポンスがないです。\nもう一度、確認してください。"
        case .decodeError:
            return "データを正しく表示できませんでした。\nもう一度、お試しください。"
        case .unknownError(status: let status, data: let data, error: let error):
            return "エラー \(error): 不特定のStatus Code \(status)と データ \(data)が返ってきました。\nもう一度、確認ください。"
        }
    }
}
