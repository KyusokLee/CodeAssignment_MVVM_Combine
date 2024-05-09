//
//  HTMLURLResponse+Utils.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/08.
//

import Foundation

/// Status Codeの値ごとに有効であるか無効であるかを定義しておくためのExtension
extension HTTPURLResponse {
    func isResponseAvailable() -> Bool {
        return (200...299).contains(self.statusCode)
    }
}
