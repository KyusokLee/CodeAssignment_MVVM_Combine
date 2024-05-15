//
//  ErrorType.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import Foundation

/// HTTPStatusCodeに合わせてErrorのタイプが把握ができるようにTypeを再設定
enum ErrorType: Error {
    case apiServerError
    case noResponseError
    case decodeError
    case unknownError
}
