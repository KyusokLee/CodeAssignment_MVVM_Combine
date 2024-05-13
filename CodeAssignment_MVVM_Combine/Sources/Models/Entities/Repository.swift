//
//  Repository.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/08.
//

import Foundation


/** Repositoryから取りたい値だけをModelとして設定
- リポジトリ名(path含めないやつ)、リポジトリのdescription、スター数、language、プロフィール画像、UserNameを表示したい
- itemsの中にRepositoryのデータが入っている構造
- itemsの中のownerの中に特定したuserのデータが格納されている
- 言語は、今後色もつけて画面に表示したい
- JSONDecoderのkeyDecodingStrategyの設定で、snake caseをcamelCaseにすることも可能だったが、今回はもっとわかりやすい変数名にしたいため、以下のようにCoding keysを使った。.customは少しコードの書き方が一目でぱっと入らなかったので、今回をスキップ
 -  APIで定義したKeyの名前を変えたのは、ViewControllerとかでそのkeyのデータを用いるとき、わかりやすくするためである。そんため、decodingのStrategyは自動で変換されるメソッドを使うのが良さそう
*/
struct Repositories: Codable {
    /// queryに当てはまる結果の数
    let totalCount: Int?
    /// リポジトリの詳細データが入っている配列形
    let items: [Repository]
}

struct Repository: Codable {
    var owner: RepositoryUser
    var name: String?
    var description: String?
    var language: String?
    var stargazersCount: Int?
    
    /// decodeのkeyDecodingStrategyメソッドを用いて、converFromSnakeCaseで自動的も変換されるStructの中身にしておく
    struct RepositoryUser: Codable {
        var login: String?
        var avatarUrl: String?
    }
}
