//
//  DetailViewModel.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/22.
//

import Foundation
import UIKit
import Combine

final class DetailViewModel {
    private let apiClient = APIClient()
    /** HomeViewController側に渡すSubject（通路ってイメージ）
     - PassThroughSubjectは、値を保持しないので、CurrentValueSubjectを通してVCに値を渡す
     - RepositoriesForViewはただ、HomeViewControllerに渡す用のModelである
     */
    var repositorySubject = CurrentValueSubject<Repositories.Repository, Never>(nil)
    /// AnyPublisher：他のTypeでwrapしたものをなくして、AnyPublisherで返す
    var repositoryPublisher: AnyPublisher<Repositories.Repository, Never> {
        return repositorySubject.eraseToAnyPublisher()
    }
    
    /// POST リクエストを送信し、repositoryにスターをつけるメソッド
    func starRepository(owner: String, repo: String) {
        
    }
}
