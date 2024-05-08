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
    private let apiClient = APIClient()
    var repositoriesSubject = PassthroughSubject<Repositories, Never>()
    
    /// GET リクエストを送信し、repositoryを持ってくるメソッド
    func didTapGetAPIButton() {
        
    }
}
