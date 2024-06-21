[![Swift 5.9](https://img.shields.io/badge/swift-5.9-ED523F.svg?style=flat)](https://swift.org/download/) [![Xcode 15.2](https://img.shields.io/badge/Xcode-15.2-ED523F.svg?style=flat&color=blue)](https://swift.org/download/)

# GitHub Repository Search Project

> `GitHub API`を参考にしてGitHub上のリポジトリを検索し、`Personal Access Token`を用いてお気に入りのリポジトリに星付け・解除ができる検索アプリ

&nbsp;

## デモ動画
> リポジトリを検索

https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/c45bb097-48d4-4c5b-9c4f-1bcb6915754a

> リポジトリ詳細画面

https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/0a22c318-116b-48cf-a554-91cd18ca2285

> リポジトリに星付け・解除

https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/f2886f49-ecfe-4049-b3e4-9968a78318ce

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
* [実装時に意識したこと](#-実装時に意識したこと)
    * [Extension活用](#Extension活用) 
    * [AutoLayout](#AutoLayout)
    * [Life Cycle](#Life-Cycle)
    * [参照](#参照)
    * [エラーの分岐](#エラーの分岐)
    * [DRY原則](#DRY原則)
* [工夫点](#-工夫点)
    * [Personal Access Token の管理方法](#Personal-Access-Token-の管理方法)
    * [エラー処理](#エラー処理)
    * [UI/UX 設計](#UI/UX-設計)
* [学び](#-学び)
    * [画面表示用のレスポンスの結合モデルの作成](#画面表示用のレスポンスの結合モデルの作成)
* [Trouble Shooting](#trouble-Shooting)
    * [CompositionalLayout](#CompositionalLayout)
    * [NSDiffableDatasourceSnapshot](#NSDiffableDatasourceSnapshot)

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
`ViewController`と`View`は画面を描く役割だけに集中させ、データ管理とロジックは`ViewModel`で進められるように構成しました。

&nbsp;

### Combine
Appleの基本APIである`Combine`を利用してリアクティブプログラミングの実装にチャレンジしました。<br>
連続したescaping closureを避け、宣言型プログラミングを通じた高い可読性とオペレーターを通じた効率的な非同期処理のためにCombineを採択しました。

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
    /// ViewModel
    private let viewModel = HomeViewModel()
    /// Custom Loading View
    private let loadingView = LoadingView()
    /// 検索開始前に表示するReadyView
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

### エラー処理

### UI/UX 設計

> [ホーム画面UIの参考資料URL]() <br>


&nbsp;

## 📚 学び

### 画面表示用のレスポンスの結合モデルの作成

`背景`
- 今回のアプリを実装するまでは、無意識でAPIを叩いて返ってくるレスポンスを`APIClient`で処理してViewControllerで直接渡すようなコードを書いていた。これはレスポンスの形に依存しちゃうのでは？と考えていてこの依存度をどう分離するかを悩んていたものの、依存度を分離せずに普段から慣れていたコードを書いた。すると、レビュアーからまさにここの部分を指摘され、API叩きから得られるレスポンス用のデータモデルと画面に表示する用のデータモデルを分岐することで依存度を減らせることを教わった。

`解決`
- データモデルをAPIを叩いてから取得するリポジトリのデータを`RepositoriesResponse`に、それらを画面に表示するためのモデルを`Repositories`に分け、Codableを継承するstructの中に不要なCodingKeysロジックを消す。また、テストを容易にするため、ビューとして表示するためのモデルを容易した。

レスポンスの形に依存しちゃうので、アンチパータンなので、Viewに表示するためのレスポンスの結合モデルを生成して、適用しました

&nbsp;

## 🔥 Trouble Shooting

### CompositionalLayout

&nbsp;

### NSDiffableDatasourceSnapshot

&nbsp;
