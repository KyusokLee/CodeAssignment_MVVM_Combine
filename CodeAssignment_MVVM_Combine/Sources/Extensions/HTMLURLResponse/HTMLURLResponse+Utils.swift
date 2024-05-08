//
//  HTMLURLResponse+Utils.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/08.
//

import Foundation

/// Status Codeを一目でもわかるようにわかておく
extension HTTPURLResponse {
    func isResponseAvailable() -> Bool {
        return (200...299).contains(self.statusCode)
    }
}
