//
//  ErrorType.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import Foundation

/// HTTPStatusCodeに合わせてErrorの把握ができるように
enum ErrorType {
    case apiClientError
    case apiServerError
    case networkError
    case parseError
    case loadDataError
    case unspecifiedError(status: Int, data: Data)
}
