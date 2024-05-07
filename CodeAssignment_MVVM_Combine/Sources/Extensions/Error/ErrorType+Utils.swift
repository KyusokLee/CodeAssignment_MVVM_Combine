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
        case .apiClientError:
            return "APIサービスエラー"
        case .apiServerError:
            return "APIサーバーエラー"
        case .networkError:
            return "ネットワークエラー"
        case .parseError:
            return "パースエラー"
        case .loadDataError:
            return "データ取得エラー"
        case .unspecifiedError(status: let status, data: let data):
            return "エラー statusCode: \(status), data: \(data)"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .apiClientError:
            return "APIサービスにエラーが起きました。\nしばらく時間が経ってから、もう一度お試しください。"
        case .apiServerError:
            return "サーバーにエラーが起きました。\nもう一度、お試しください。"
        case .networkError:
            return "ネットワークに繋がっていません。\nもう一度、確認してください。"
        case .parseError:
            return "データを正しく表示できませんでした。\nもう一度、お試しください。"
        case .loadDataError:
            return "イメージを正しく取得できませんでした。\nしばらく時間が経ってから、もう一度お試しください。"
        case .unspecifiedError(status: let status, data: let data):
            return "不特定のStatus Code \(status)と データ \(data)が返ってきました。\nもう一度、確認ください。"
        }
    }
}
