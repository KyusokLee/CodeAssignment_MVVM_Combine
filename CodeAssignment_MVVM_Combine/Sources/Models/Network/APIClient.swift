//
//  APIClient.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import Foundation

protocol GitHubAPIClientProtocol {
    // Associated Typeを用いてどんな形でも受け付けられるようにしておく
    // Associated Typeは、定義したProtocolが採択される前までは、実際のTypeが明示されない
    // すなわち、Protocolで使用される何かしらのTypeのための、Placeholderのような役割
    associatedtype Model
    
    func decode(from data: Data) throws -> Model
    func buildUpRequest(type: GitHubAPIType) -> URLRequest?
}

struct GitHubSearchRepositoriesRequest: GitHubAPIClientProtocol {
    let searchQueryWord: String
    
    init(searchQueryWord: String) {
        self.searchQueryWord = searchQueryWord
    }
    
    /**
     定義したRepositoriesモデルにデコーディングする
     - throwing functionを用いて、Errorを投げる関数であることを明確にする
     - try catchのコードブロックの記載不要
     - 呼び出し先にthrowing関数で発生しうるエラーを返すため、上位レベルでエラー処理することが容易である
     
     */
    func decode(from data: Data) throws -> RepositoriesResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // codingKeysを別途に設けずに、decoder.keyDecodingStrategy = .convertFromSnakeCaseを用いてJSONのconvertがしやすい
        // ただし、 _以外の名前はマッチしないといけない
        // 例) JSON上のキーがuserなのに、コード上ではownerという変数として使いたい場合
        return try decoder.decode(RepositoriesResponse.self, from: data)
    }
    
    /**
     URLRequestを返す関数. この関数はただリクエストを立てるだけの関数であり、実際にリクエストを送信する作業はしない
     - Requestは、リクエストを立てる と リクエストを実際送る　の２つの流れで行われる
     - リクエストを立てる処理は分離することで、requestだけの処理ができるのではないかと考える
     */
    func buildUpRequest(type: GitHubAPIType) -> URLRequest? {
        
        switch type {
        case .searchRepositories:
            let urlString = "https://api.github.com/search/repositories?q=\(searchQueryWord)"
            guard let url = URL(string: urlString) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            return request
        case .starRepository(let owner, let repo):
            // repository owner usernameと repository name必須
            let urlString = "https://api.github.com/user/starred/\(owner)/\(repo)"
            guard let url = URL(string: urlString) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            // Authorization ヘッダーにトークン設定
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            return request
        }
    }
}

/** API Requestを管理するクラスの定義
- Classでは、Structで定義したfunctionとかインスタンスを受け付けできないので、genericタイプを設ける
- Result型のエラー処理の特徴
- 戻り値として、「成功」か「失敗」かのどちらかであることが保証される
- 非同期的にネットワークのリクエストを送り、そのレスポンスを処理するため
 */
class APIClient {
    func request<T: GitHubAPIClientProtocol>(_ requestProtocol: T, type: GitHubAPIType, completion: @escaping(Result<T.Model?, ErrorType>) -> Void) {
        guard let request = requestProtocol.buildUpRequest(type: type) else { return }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(ErrorType.unknownError))
                return
            }
            // guard let 文は、ブロックの中ではunwrappingしたインスタンスを使うことができない
            // guart letの外に出てから、やっとそのインスタンスが使える
            guard let data,
                  let response = response as? HTTPURLResponse else {
                completion(.failure(ErrorType.noResponseError))
                return
            }
            
            // レスポンスが有効なレスポンス（200 ~ 299）であるなら、decodeを実行
            if response.isResponseAvailable() {
                do {
                    let results = try requestProtocol.decode(from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(ErrorType.decodeError))
                }
            } else {
                // レスポンスが無効なレスポンスなら、APIサーバー側にエラーがある
                completion(.failure(ErrorType.apiServerError))
            }
        }
        task.resume()
    }
}
