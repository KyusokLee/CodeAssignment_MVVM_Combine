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
//    /// HomeViewController側で監視しているSubject
//    var getAPIButtonColorSubject = PassthroughSubject<UIColor, Never>()
    
    /// 値が送られるたびに何かを更新させる必要があるときはPassthrough
    /// ボタンなどのコンポーネントがあるStateを保持していて、値が送られたら更新したい場合は、CurrentValue
    var getAPIButtonColor = CurrentValueSubject<UIColor, Never>.init(.systemBackground)
//    /// 初期状態を設定
//    init() {
//        getAPIButtonColorSubject.send(UIColor.systemBackground)
//    }
    
    /// GET リクエストを送信し、repositoryを持ってくるメソッド
    func didTapGetAPIButton() {
        getAPIButtonColor.send(UIColor.blue)
    }
}
