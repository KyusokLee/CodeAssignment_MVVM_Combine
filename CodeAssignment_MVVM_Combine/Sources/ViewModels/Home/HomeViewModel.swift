//
//  HomeViewModel.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/07.
//

import Foundation
import UIKit
import Combine

final class HomeViewModel {
    /// HomeViewController側で監視しているSubject
    var getAPIButtonColorSubject = PassthroughSubject<UIColor, Never>()
    
    
    /// 初期状態を設定
    init() {
        getAPIButtonColorSubject.send(UIColor.systemBackground)
    }
    
    /// GET リクエストを送信し、repositoryを持ってくるメソッド
    func didTapGetAPIButton() {
        getAPIButtonColorSubject.send(UIColor.blue)
    }
}
