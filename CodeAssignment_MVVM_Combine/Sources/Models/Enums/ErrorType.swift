//
//  ErrorType.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import Foundation

/// HTTPStatusCodeに合わせてErrorの把握ができるように
enum ErrorType: Error {
    case apiServerError
    case noResponseError
    case decodeError
    case unknownError(error: Error)
}
