[![Swift 5.9](https://img.shields.io/badge/swift-5.9-ED523F.svg?style=flat)](https://swift.org/download/) [![Xcode 15.2](https://img.shields.io/badge/Xcode-15.2-ED523F.svg?style=flat&color=blue)](https://swift.org/download/)

# GitHub Repository Search Project

> `GitHub API`を参考にしてGitHub上のリポジトリを検索し、`Personal Access Token`を用いてお気に入りのリポジトリに星付け・解除ができる検索アプリ

&nbsp;

## デモ動画
> リポジトリを検索

https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/c45bb097-48d4-4c5b-9c4f-1bcb6915754a

# 

> リポジトリ詳細画面

https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/0a22c318-116b-48cf-a554-91cd18ca2285

# 

> リポジトリに星付け・解除

https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/f2886f49-ecfe-4049-b3e4-9968a78318ce

# 

> 入力ワード切り替え

https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/e9845d62-3495-4181-96df-976f16d8fafe

&nbsp;

## 参考資料

> [GitHub API: - 検索用 REST API エンドポイント](https://docs.github.com/ja/rest/search/search?apiVersion=2022-11-28#search-repositories) <br>
> [GitHub API: - 星付け用 REST API エンドポイント](https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28#star-a-repository-for-the-authenticated-user)

&nbsp;

## 目次

* [ディレクトリ構成](#-ディレクトリ構成)
* [技術スタック](#-技術スタック)
* [機能及びUI](#-機能及びUI)
* [設計及び実装](#-設計及び実装)
* [技術的チャレンジ](#-技術的チャレンジ)
    * [MVVM](#MVVM)
    * [Combine](#Combine)
    * [UICollectionViewDiffableDataSource](#UICollectionViewDiffableDataSource)
    * [UICollectionViewCompositionalLayout](#UICollectionViewCompositionalLayout)
* [実装時に意識したこと](#-実装時に意識したこと)
    * [Extension活用](#Extension活用) 
    * [AutoLayout](#AutoLayout)
    * [Life Cycle](#Life-Cycle)
    * [参照](#参照)
    * [エラーの分岐](#エラーの分岐)
    * [DRY原則](#DRY原則)
* [工夫点](#-工夫点)
    * [Personal Access Token の管理方法](#Personal-Access-Token-の管理方法)
* [学び](#-学び)
    * [画面表示用のレスポンスの結合モデルの作成](#画面表示用のレスポンスの結合モデルの作成)
* [Trouble Shooting](#trouble-Shooting)

## 🗂 ディレクトリ構成

```
CodeAssignment_MVVM_Combine
 ├── Resources
 │   ├── Info.plist
 │   └── Assets.xcassets
 └── Sources
     ├── Apps
     │   ├── SceneDelegate
     │   └── AppDelegate
     ├── Extensions
     │   ├── HTMLURLResponse
     │   │   └── HTMLURLResponse+Utils
     │   ├── Error
     │   │   └── ErrorType+Utils
     │   └── UIColor
     │       └── UIColor+Utils
     ├── Controllers
     │   ├── HomeViewController
     │   └── DetailViewController
     ├── ViewModels
     │   ├── Home
     │   │   └── HomeViewModel
     │   └── DetailView
     │       └── DetailViewModel
     ├── Views
     │   ├── LoadingView
     │   ├── ReadySearchView
     │   └── Cells
     │       └── HomeViewController
     │           └── RepositoryCollectionViewCell
     └── Models
         ├── Enums
         │   ├── ErrorType
         │   ├── GitHubAPIType
         │   ├── Constants
         │   └── Tokens
         ├── Network
         │   └── APIClient
         ├── Entities
         │   └── RepositoriesRespone
         └── Presentations
             └── Repositories
```

&nbsp;

## 🛠 技術スタック

### アーキテクチャ

* MVVM

### データ・UIイベント処理

* Combine

### AutoLayout実装
* SnapKit

### Web画像の処理
* SDWebImage

&nbsp;

## 📱 機能及びUI

|機能/UI|説明|
|:-|:-|
|検索|`GitHub REST API`を使用して検索ワードをパラメータとして渡すことで、GitHub上のリポジトリを検索できます。|
|一覧リスト|リポジトリ検索結果を一覧として表示します。一覧リストで表示するデータは`リポジトリ名`, `リポジトリのDescription`, `ユーザ名`, `ユーザプロフィール写真`, `スター数`, `使用言語`です。|
|詳細画面|一覧リストで確認したいリポジトリのセルをタッチすると、そのリポジトリの詳細情報を表示した画面に遷移します。詳細画面では、一覧リストで表示したリポジトリのデータに加えて`Watchersの数`, `forksの数`, `issuesの数`を表示します。|
|星付け・解除|詳細画面の星ボタンをタッチすると、リポジトリに星を付けたり解除したりできます。`Personal Access Token`を用いてGitHub認証を行うことで、自分のアカウントでこれらの操作が可能になります。|

&nbsp;

## 💻 設計及び実装

### MVVM

(実際のアプリ画面間の関係をModel/ViewModel/Viewの役割に基づいた画像を作成し、ここに挿入するつもり)

&nbsp;

### 役割分担

|class/struct|役割|
|:-|:-|
|`HomeViewController`|`UISearchController`の`searchBar`を用いて検索ワードを入力し、リポジトリを検索してその結果を一覧リストで表示する画面です。|
|`DetailViewController`|`HomeViewController`でタッチしたリポジトリの詳細データを表示する画面です。|
|`RepositoriesResponse`|API叩きから得られたリポジトリのデータモデルを直接管理します。|
|`Repositories`|`RepositoriesResponse`のデータを`ViewController`の画面に表示するためのデータモデルです。|


&nbsp;

### Utilities

|class/struct|役割|
|:-|:-|
|`APIClient`|APIを呼び出すために必要な処理を管理するクラス。HTTPリクエストのビルドと送信、データの取得・デコーディング、エラーの分岐を担当します。|

&nbsp;

## 💪🏻 技術的チャレンジ

### MVVM
これまでの開発はほぼアーキテクチャ未導入かMVPアーキテクチャを用いて開発してましたが、リアクティブプログラミングの理解のための座学ということで、今回の開発でMVVMアーキテクチャを導入することにしました。<br>
MVVMアーキテクチャの特徴をまとめると、`ViewController`と`View`は画面を描く役割だけに集中させ、画面上で必要なデータ管理とロジックは`ViewModel`で進められるようにし、関心事を分離することです。

&nbsp;





MVVM は Model-View-ViewModel の略称であり、ソフトウェア開発で使われるアーキテクチャパターンの一つを指します。MVVMはアプリケーションを上記のように３つのコンポーネントに分離して管理し、各コンポーネントが特定の役割を果たします。





&nbsp;

### Combine
Appleの基本APIである`Combine`を利用してリアクティブプログラミングの実装にチャレンジしました。<br>
連続したescaping closureを避け、宣言型プログラミングを通じた高い可読性とオペレーターを通じた効率的な非同期処理のためにCombineを採択しました。

&nbsp;

### UICollectionViewDiffableDataSource


&nbsp;

### UICollectionViewCompositionalLayout


&nbsp;

## 🎯 実装時に意識したこと

### Extension活用

```swift
/// Status Codeの値ごとに有効であるか無効であるかを定義しておくためのExtension
extension HTTPURLResponse {
    func isResponseAvailable() -> Bool {
        return (200...299).contains(self.statusCode)
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    /// Return(検索)キーをタップしたときの処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
    }
    // 他は省略
}

// MARK: - Life Cycle & Variables
class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    private let loadingView = LoadingView()
    private let readyView = ReadySearchView()

    // 他は省略
}

// MARK: - Functions & Logics
extension HomeViewController {
    /// ViewControllerのUIをセットアップする
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        
        setupNavigationController()
        setupDataSource()
        setAddSubViews()
        setupConstraints()
    }

    // 他は省略
}
```

- `extension`を用いて、既存のオブジェクトやタイプを修正することなく、新しい機能を追加することができます。

- 上記のコードに記載した`HTTPURLResponse`のように `isResponseAvailable` の関数を追加することで、複数の場所で同様の機能が使用できるようにし、コードの重複を減らすことを意識しました。

- `UISearchBarDelegate`のように deleage パターンは `extension`を使って責任の分離をしておき、特定の機能に関するコードを一箇所にまとめて管理しやすくしました。

- 人の好みによると思いますが、`ViewController`や `View`の`class`の定義する際に、`extension`を用いて「ライフサイクル・プロパティ」と「ロジック・関数」を分離するようにしました。
  - 理由としては、`class`のコードが長くなり過ぎないように一度 `extension` で区切って整理することで、コードの可読性を向上させたかったからです。
  - また、delegateパターンを `extension`を使って責任分離を行なうのと同様に、ロジックの部分とクラスのライフサイクルを分離しました。

&nbsp;

### AutoLayout

本アプリでは `SnapKit`を用いて AutoLayoutの設定をしました。今回、コードベースで画面のUIを設定するのが技術的な制限として設けられたので、`Storyboard`なしで開発を進めました。
`SnapKit` を利用した経緯は過去の経験から以下のことを感じたからです。
  > "画面の数が多くて複雑になって、Storyboard の数が増えている.. Storybard自体も重くなってファイルを開くたびにXcodeが落ちちゃう..."<br>
  > "Storyboardって使わなくていいよね？"<br>
  > "Storyboardなしでプロパティの constraint をコードで実装してみよう！"<br>
  > "あれ？やってみたら、constraint を追加するコードも長くなちゃったな.."<br>
  > "SnapKit 使ってみたら、便利..!"<br>

なぜ、`SnapKit` を使って便利だと思ったかについては以下のコードを参考にしながら、説明します。

```swift
// SnapKit 未使用
mainStackView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(mainStackView)

NSLayoutConstraint.activate([
    mainStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true,
    mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true,
    mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true,
    mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
])

// SnapKit 使用
mainStackView.snp.makeConstraints { constraint in
    constraint.edges.equalToSuperview()
    // 上記と下記のコードは同じ動作をする
    // constraint.leading.top.trailing.bottom.equalToSuperview()
}

// または
mainStackView.snp.makeConstraints {
    $0.edges.equalToSuperview()
}
```

- 上記に示した「SnapKit　使用」のコードを見ると、「未使用の例」より簡潔で直感的になっており、可読性が向上されたと感じます。

- また、`SnapKit`は `constraint.edges.equalToSuperview()` や　`constraint.leading.top.trailing.bottom.equalToSuperview()` のようにメソッドチェーンで複数のプロパティに一度に制約を設定することができ、`NSLayoutConstraints`よりコードの量を減らせることができます。

- これは実装中に気づいたことですが、`SnapKit`は内装コードに `translatesAutoresizingMaskIntoConstraints`を `false`にする設定があるため、別途に同様のコードを記載する必要がないので便利でした。

- 今度は `VFL (Visual Format Language)`を導入して、制約の設定をより視覚的に実装することにチャレンジしようと思っています。

&nbsp;

### Life Cycle

&nbsp;

### 参照

&nbsp;

### 例外処理・通信時のエラー処理
#### 例外処理

```swift
/// 通常の関数
func decode(from data: Data) -> RepositoriesResponse? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
        let response = try decoder.decode(RepositoriesResponse.self, from: data)
        return response
    } catch {
        // エラーのとき、メッセージの表示と同時に nil を返す
        print("Failed to decode JSON: \(error)")
        return nil
    }
}

/// throw関数
func decode(from data: Data) throws -> RepositoriesResponse {
   let decoder = JSONDecoder()
   decoder.keyDecodingStrategy = .convertFromSnakeCase
   return try decoder.decode(RepositoriesResponse.self, from: data)
}

/// 使う側でのコード
do {
   let results = try requestProtocol.decode(from: data)
   completion(.success(results))
} catch {
   completion(.failure(ErrorType.decodeError))
}
```

- `throws`関数を用いて、Errorの発生可能性があることを`throws`キーワードで明示し、エラーを投げるようにしました。

- 関数内部の `try catch`のコードブロックの記載が不要になり、実際に使う側でロジックを実行するときにエラー処理を行うようにし、コードの可読性と保守性を意識しました。

#### 通信時のエラー処理

```swift
/// ErrorTypeの定義
enum ErrorType: Error {
    case apiServerError
    case noResponseError
    case decodeError
    case unknownError
}

extension ErrorType {
    var errorTitle: String {
        switch self {
        case .apiServerError:
            return "APIサーバーエラー"
        case .noResponseError:
            return "レスポンスエラー"
        case .decodeError:
            return "デコードエラー"
        case .unknownError:
            return "不明なエラー"
        }
    }
    
    var errorDescription: String {
        switch self {
        case .apiServerError:
            return "サーバーにエラーが起きました。\nもう一度、お試しください。"
        case .noResponseError:
            return "レスポンスがないです。\nもう一度、確認してください。"
        case .decodeError:
            return "デコードエラーが発生しました。\nもう一度、お試しください。"
        case .unknownError:
            return "不明なエラーが返ってきました。\nもう一度、確認ください。"
        }
    }
}

/// 使う側でのコード例
func presentError(_ error: ErrorType) {
    print("Error: \(error.errorTitle)")
    print("Description: \(error.errorDescription)")
}

let error = ErrorType.apiServerError
presentError(error)
```

- APIリクエスト処理時に発生の可能性があるエラーを明示し、可読性とコードの保守性の向上を意識しました。

- 各エラータイプに対して明確に定義されたタイトル `errorTitle` と説明 `errorDescription` を提供することで、ユーザにエラーが発生した時の詳細情報を表示することができます。

- エラー発生時の情報を定義することで、ユーザ目線だけでなく開発者も問題を把握しやすくなり、デバッグも容易になります。

&nbsp;

### DRY原則
重複コードを避け、汎用的なコードを書くよう意識しました。

#### 重複コードのメソッド化
```swift
private lazy var watchersCountLabel: UILabel = makeCountLabel()
private lazy var forksCountLabel: UILabel = makeCountLabel()
private lazy var openIssuesCountLabel: UILabel = makeCountLabel()

private func makeCountLabel() -> UILabel {
   let label = UILabel()
   label.font = .systemFont(ofSize: 18, weight: .regular)
   label.textColor = .black.withAlphaComponent(0.7)
   return label
}

/// フォントのサイズやテキストカラーに差を付与してインスタンスを生成するときは、以下のように応用できるメリットがある
private func makeCountLabel(fontSize: CGFloat, color: UIColor) -> UILabel {
   let label = UILabel()
   label.font = .systemFont(ofSize: 18, weight: .regular)
   label.textColor = .black.withAlphaComponent(0.7)
   return label
}
```  
- `UILabel`インスタンス定義時に同じコードを使用しているものはメソッドとしてまとめ、重複コードを避けました。

&nbsp;

#### ジェネリックとプロトコルの使用
```swift
class APIClient {
    /// ジェネリック(Tタイプ)を使用することで、GitHubAPIClientProtocolを準拠する全てのタイプのリクエスト処理が可能になる
    func request<T: GitHubAPIClientProtocol>(_ requestProtocol: T, type: GitHubAPIType, completion: @escaping(Result<T.Model?, ErrorType>) -> Void) {
        guard let request = requestProtocol.buildUpRequest() else { return }
        /// 他は省略
    }
}

/// リポジトリ検索用のリクエスト
struct GitHubSearchRepositoriesRequest: GitHubAPIClientProtocol {
   /// リクエストを立てる処理とリクエストを実際に送る処理を分離し、コードの可読性とテストおよび保守時のメンテナンス性を向上させる
   func buildUpRequest() -> URLRequest? {
      let urlString = "[URL string you want to use]"
      guard let url = URL(string: urlString) else { return nil }
      var request = URLRequest(url: url)
      request.httpMethod = "GET"

      return request
   }
   /// 他は省略
}

```
- 本アプリは`GitHub Rest API`の中、検索用のエンドポイントと星付けー・解除用のエンドポイントを使用しています。検索用の`strcut`である`GitHubSearchRepositoriesRequest`と星付けー・解除用である`GitHubStarRepositoriesRequest`はそれぞれ異なるリクエストを処理しているが、ジェネリックとプロトコルを用いることでコードの再利用性を増やすことができます。

- `GitHubSearchRepositoriesRequest`と`GitHubStarRepositoriesRequest`が共通のプロトコル`GitHubAPIClientProtocol`を準拠するように定義し、`APIClient`クラスでジェネリックを使用してリクエストを送信するようにすると、重複したコードの削減と、複数のAPIリクエストに対して同じロジックを使用できるようになります。

- 各リクエストタイプが自分自身のリクエストを組み立てるロジック`buildUpRequest`を持つようにし、`APIClient`はリクエストタイプに応じた処理を行う必要がなくなり、関心事の分離が実現されます。

&nbsp;

#### カスタムコンポーネント

```swift
final class LoadingView: UIView {
    /// didSetを用いてプロパティの値が更新された直後に実行し、古い値を新しい値に置き換えることが可能
    var isLoading = false {
        didSet {
            isHidden = !isLoading
            isLoading ? loadingIndicatorView.startAnimating() : loadingIndicatorView.stopAnimating()
        }
    }
    /// 他は省略
}

/// loadingViewを使う側で以下のように定義することで、どの画面でも利用できる
private let loadingView = LoadingView()
loadingView.isLoading = true

/// 他は省略

```
- ローディング中であることをユーザに示す`LoadingView`をカスタムコンポーネント化し、コードの再利用性を増やした。同じ機能やUI要素を一つの箇所にカプセル化したため、`ViewController`や`View`などどの場所でもこれらを利用することができます。

- UIやロジックを修正する際、当該コンポーネントだけ修正すればいいので、コードの保守がしやすくなります。例えば、`UIActivityIndicatorView`の色や表示するテキストを変えたいときは、`LoadingView`クラスを修正すればいいので、関心事の分離ができ、テストも容易にします。


&nbsp;

## 🧐 工夫点

### Personal Access Token の管理方法
星付け・解除の機能を使うにあたって、自分自身のGitHubアカウントの認証が必要だったため、アクセストークンをどのように使うかを悩みました。<br>
本アプリの認証機能の実装において、下記の4つの方法を工夫しました。

#### UserDefaults
```swift
func getAccessToken() -> String? {
    UserDefaults.standard.string(forKey: "accessToken")
}

func saveAccessToken(_ accessToken: String) {
    UserDefaults.standard.set(accessToken, forKey: "accessToken")
}
```

- 既存の個人開発では簡単な環境設定などの管理は`UserDefaults`を用いて実装しました。コードの書き方も上記のようにとても簡単なため、よく使っていました。

- しかし、`UserDefaults`上のデータはproperty list （.plistファイル）に保存されるため、特定のツールなどを使用すると、`UserDefaults` にアクセスできるようになり、データの確認・修正が可能になるという脆弱性があります。そのため、トークンなどの機密情報の保存には適していないらしいです。

- 上記の理由から、`UserDefaults`を用いた方法は採用しませんでした。

#### ProcessInfo を用いる方法
```swift
func loadTokenFromProcessInfo() -> String? {
    return ProcessInfo.processInfo.environment["PERSONAL_ACCESS_TOKEN"]
}

// 使い方
if let token = loadTokenFromProcessInfo() {
    print("Loaded token: \(token)")
} else {
    print("Token not found")
}
```

- `ProcessInfo`を用いた方法は、Xcodeの Scheme設定の修正を通して実装可能になります。Xcode上の環境変数として保存して使えばいいので、コードの書き方が簡単です。

- しかし、Xcode上でビルドしない限り、設定したトークンが正常に反映されないので、トークンの保存方法としては不適合だと判断しました。そのため、この方法も採用しませんでした。

#### Keychain を用いる方法
- `Keychain` を使用すると、ユーザのパスワードに限らず、クレジットカード情報、あるいは短いメモなどもユーザが暗号化したいものであれば、`Keychain` データベースに暗号化して保存することができます。

- Appleは `Keychain Services API`を通して、主に以下のことを提供しています。
  1. 長くて難しいパスワードなどの機密情報を作っても私が代わりに覚えてあげます！
  2. パスワードの奪取が心配ですか？こっちの方で暗号化して持っているので、心配しないで！
 
- つまり、この `Keychain`の実装方法を用いて、ユーザは簡単で便利にパスワードやトークンなどの機密情報を管理することができます。

- また、追加でAPIで自動的に暗号化が必要なものに対する処理をしてくれるので、開発者も簡単で便利に使用できるというメリットがあります。詳しくは下記に貼った公式文書を参考にしてください。

- しかし、`Keychain`は実装の方法が複雑であり、ある程度理解度が必要であると感じ、今回は採用しないことにしました。

- また、今回の実装はあくまでも自分のアカウントで任意のリポジトリに星付け・解除機能の実現有無だけを確認する目的であるため、採択しないことにしました。

- 今後、Keychainについて勉強したあと、リファクタリングにチャレンジする予定です。

> [公式ドキュメントに行く (Keychainについて) ](https://developer.apple.com/documentation/security/keychain_services)

#### gitignore を用いる方法
```plaintext
# gitignore ファイルに無視したいファイルまでのパスを全部記載
# 以下は例
CodeAssignment_MVVM_Combine/Sources/Token.swift
```

- 今回の実装の目的は、自分のアカウントで任意のリポジトリに星付け・解除することができるかを確かめることです。そのため、トークンを記載したファイルを作成し、GitHubで公開する際には gitignore を使用してそのファイルをプロジェクトから除外する方法を採用しました。

- 上記のように、gitignore ファイルにトークンを記載したファイルまでのパスをすべて記録することで対応は完了です。ただし、gitignore ファイルの位置によってパスが異なるため、注意が必要です。

&nbsp;

## 📚 学び

### 画面表示用のレスポンスの結合モデルの作成
```swift
func loadTokenFromProcessInfo() -> String? {
    return ProcessInfo.processInfo.environment["PERSONAL_ACCESS_TOKEN"]
}

// 使い方
if let token = loadTokenFromProcessInfo() {
    print("Loaded token: \(token)")
} else {
    print("Token not found")
}
```

`背景`<br>
- 今回のアプリを実装するまでは、無意識でAPIを叩いて返ってくるレスポンスを`APIClient`で処理してViewControllerで直接渡すようなコードを書いていた。これはレスポンスの形に依存しちゃうのでは？と考えていてこの依存度をどう分離するかを悩んていたものの、依存度を分離せずに普段から慣れていたコードを書きました。<br>
- すると、レビュアーの方からまさにここの部分を指摘され、API叩きから得られるレスポンス用のデータモデルと画面に表示する用のデータモデルを分岐することで依存度を減らせることを教わりました。

`解決`<br>
- レスポンスの形式に依存することはアンチパターンであると考え、ビューに表示するためのモデルを生成して適用しました。<br>
- データモデルをAPIから取得するリポジトリのデータ用の `RepositoriesResponse` と、それらを画面に表示するための `Repositories` に分けました。これにより、`Codable` を継承する `struct` 内の不要な `CodingKeys` ロジックを排除することができます。<br>
- また、ビュー表示用のモデルを用意して関心事の分離をすることで、テストも容易になります。例えば、API処理のテストを行うときは `RepositoriesResponse`を、 UIのテストを行うときは `Repositories`のみをテストすればいいので、コード作成の効率性も上がります。

&nbsp;

## 🔥 Trouble Shooting
