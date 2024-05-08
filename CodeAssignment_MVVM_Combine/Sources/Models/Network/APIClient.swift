//
//  APIClient.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import Foundation

protocol GitHubAPIClientProtocol {
    func decode(from data: Data) throws -> Repositories
    func buildUpRequest(type: GitHubAPIType) -> URLRequest?
}

/// Structにデコードする (指定)
struct GitHubSearchRepositoriesRequest: GitHubAPIClientProtocol {
    /// throwing functionを用いて、Errorを投げる関数であることを明確にする
    /// try catchのコードブロックの記載不要
    /// 呼び出し先にthrowing関数で発生しうるエラーを返すため、上位レベルでエラー処理することが容易である
    func decode(from data: Data) throws -> Repositories {
        let decoder = JSONDecoder()
        // codingKeysを別途に設けずに、decoder.keyDecodingStrategy = .convertFromSnakeCaseを用いてJSONのconvertがしやすい
        // ただし、 _以外の名前はマッチしないといけない
        // 例) JSON上のキーがuserなのに、コード上ではownerという変数として使いたい場合
        return try decoder.decode(Repositories.self, from: data)
    }
    
    /// Requestは、リクエストを立てる と リクエストを実際送る　の２つの流れで行われる
    /// リクエストを立てる処理は分離することで、requestだけの処理ができるのではないかと考える
    func buildUpRequest(type: GitHubAPIType) -> URLRequest? {
        switch type {
        case .searchRepositories(queryString: let queryString):
//            let urlString = "https://api.github.com/search/repositories?q=\(queryString)"
            /// まずは、swiftをクエリに入れて検索する
            let urlString = "https://api.github.com/search/repositories?q=swift"
            guard let url = URL(string: urlString) else { return nil }
            var request = URLRequest(url: url)
            var headers: [String: String] = [:]
            request.httpMethod = "GET"
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            return request
        }
    }
}

/// API Requestを管理するクラスの定義
/// Classでは、Structで定義したfunctionとかインスタンスを受け付けできないので、genericタイプを設ける
/// Result型のエラー処理の特徴
/// 戻り値として、「成功」か「失敗」かのどちらかであることが保証される
/// 非同期的にネットワークのリクエストを送り、そのレスポンスを処理するため
class APIClient {
    func request<T: GitHubAPIClientProtocol>(_ requestProtocol: T, type: GitHubAPIType, completion: @escaping(Result<Repositories, ErrorType>) -> Void) {
        guard let request = requestProtocol.buildUpRequest(type: type) else { return }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error {
                completion(.failure(ErrorType.unknownError(error: error)))
                return
            }
            /// guard let 文は、ブロックの中ではunwrappingしたインスタンスを使うことができない
            /// guart letの外に出てから、やっとそのインスタンスが使える
            guard let data,
                  let response = response as? HTTPURLResponse else {
                completion(.failure(ErrorType.noResponseError))
                return
            }
            
            /// レスポンスが有効なレスポンス（200 ~ 299）であるなら、decodeを実行
            if response.isResponseAvailable() {
                do {
                    let results = try requestProtocol.decode(from: data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(ErrorType.decodeError))
                }
            } else {
                /// レスポンスが無効なレスポンスなら、APIサーバー側にエラーがある
                completion(.failure(ErrorType.apiServerError))
            }
        }
        task.resume()
    }
}
