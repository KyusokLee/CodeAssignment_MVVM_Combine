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
    * [参照及びARC関連](#参照及びARC関連)
    * [エラーの分岐](#エラーの分岐)
    * [DRY原則](#DRY原則)
* [工夫点](#-工夫点)
    * [Personal Access Token の管理方法](#Personal-Access-Token-の管理方法)
* [学び](#-学び)
    * [画面表示用のレスポンスの結合モデルの作成](#画面表示用のレスポンスの結合モデルの作成)

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

### フレームワーク
UIKit
- コードベースのUIで開発しました。
- `UICollectionView` の DataSource に関しては、`UICollectionViewDiffableDataSource` を使用しました。

### アーキテクチャ
MVVM
- UIを担当する `View` の開発をビジネスロジック部分と分離させることで、コードの可読性と保守性を向上させるため、使用しました。
- データバインディングにより、`View` の更新を効率化します。

### データ・UIイベント処理
Combine
- 連続したエスケーピングクロージャを避け、宣言的プログラミングによる高い可読性と、オペレーターを用いた効率的な非同期処理のために使用しました。
- データが発生する時点からビューに描画されるまで、一つの大きなストリームとしてデータをバインドしました。

### AutoLayout実装
SnapKit
- 直感的なコードでコンポーネントのレイアウトの制約を作成・管理できるため、使用しました。

### Web画像の処理
SDWebImage
- 画像の非同期読み込みとキャッシュ機能を提供するため、使用しました。

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

<p align="center">
   <img width="840" alt="スクリーンショット 2024-07-01 17 11 34" src="https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/33eae7ae-9fcd-4ffd-b1ab-ac104c166846">
</p>

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
　これまでの開発はほぼアーキテクチャ未導入かMVPアーキテクチャを用いて開発してましたが、リアクティブプログラミングの理解のための座学ということで、今回の開発でMVVMアーキテクチャを導入することにしました。これをきっかけにMVVM について取り上げてみたいと思います。理解した内容を以下に記載しました。<br>

　MVVMアーキテクチャの特徴をまとめると、`ViewController`と`View`は画面を描く役割だけに集中させ、画面上で必要なデータ管理とロジックは`ViewModel`で進められるようにし、関心事を分離することです。

<p align="center">
   <img width="840" alt="スクリーンショット 2024-06-24 20 18 58" src="https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/9a1161ba-912a-4790-8d4e-185592b24290">
</p>

　MVVM は Model-View-ViewModel の略称であり、ソフトウェア開発で使われるアーキテクチャパターンの一つを指します。MVVMはアプリケーションを上記のように３つのコンポーネントに分離して管理し、各コンポーネントが特定の役割を果たします。

&nbsp;

#### `Model`
- アプリケーションのデータとビジネスロジックを含む
- データベース、ネットワークリクエスト、ローカルストレージなどと相互作用してデータを取得・更新
- アプリケーションの状態とデータを表現し、データの変更を検出して通知を行うことが可能

　本アプリではAPIリクエストロジックを処理する `APIClient`や そのリクエスト時に得られるリポジトリのデータモデル `RepositoriesResponse` などが当てはまります。以下は `RepositoriesResponse` のコードです。

```swift
struct RepositoriesResponse: Codable {
    /// queryに当てはまる結果の数
    let totalCount: Int
    /// リポジトリの詳細データが入っている配列形
    let items: [RepositoryResponse]
    
    struct RepositoryResponse: Codable {
        var owner: RepositoryUserResponse
        var name: String
        var description: String?
        var language: String?
        var stargazersCount: Int
        var forksCount: Int
        var watchersCount: Int
        var openIssuesCount: Int

        struct RepositoryUserResponse: Codable {
            var login: String
            var avatarUrl: String
        }
    }
}
```

&nbsp;

#### `View`
- いやゆるUIを指す
- ユーザがアプリケーションと相互作用できる画面を構成し、ユーザの入力イベントを受け取る
- ユーザにデータを表示し、ユーザの入力イベントを `ViewModel`に伝達
- `UIKit`では `UIViewController`も `View` に当てはまる

　本アプリではリポジトリを検索してその結果を一覧リストで表示する `HomeViewController` と特定のリポジトリの詳細情報が見れる `DetailViewController`がこれに当てはまります。<br>
　以下は `HomeViewController` のコードであり、`ViewModel` とのリアクティブなデータ相互作用を可能にするため、`bind` メソッドでデータバインディング処理をします。

```swift
// MARK: - Life Cycle & Variables
class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Repositories.Repository>!
    private lazy var repositoryCollectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.contentInsetAdjustmentBehavior = .always
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

// MARK: - Functions & Logics
extension HomeViewController {
    
    /// ViewModel と ViewController の間のデータ相互作用のため、bind処理
    private func bind() {
        viewModel.repositoriesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositories in
                guard let self, let repositories else { return }
                self.updateSnapshot(repositories: repositories.items)
            }
            .store(in: &cancellables)
        
    }

    // 他のコードは省略
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
        // Returnキーを押して ViewModelで定義したsearch logicを実行
        viewModel.search(queryString: searchWord)
    }
}

// 他のコードは省略
```

&nbsp;

#### `ViewModel`
- `View` と `Model`の間の中間レイヤーの役割を果たす
- `Model` からデータを取得して、`View` が使いやすい形に加工・フォーマット
- UIに関連するロジックを処理し、`View` にデータを提供
- `View` と完全に分離されており、`View` の `Life Cycle`とは独立して動作
- 主にユーザの入力を処理し、データを常に監視（Observe）して更新事項を `View` に通知

　以下のコードは `HomeViewController` で使用するビューモデル `HomeViewModel` のコードの一部です。<br>
　ここでモデルである `APIClient` のインスタンスを用いて GitHub のリポジトリを検索し、その結果をビューである `HomeViewController`に渡す役割を果たします。<br>
　このビューモデルは、モデル（データ取得と加工）とビュー（データの表示）の間の中間層として機能し、データの取得と加工、ビューへのデータ提供を行います。<br>
　`CurrentValueSubject` や `send`メソッドに関しては後述の `Combine` の箇所で説明します。

```swift
final class HomeViewModel {
    private let apiClient = APIClient()
    var repositoriesSubject = CurrentValueSubject<Repositories?, Never>(nil)
    var repositoriesPublisher: AnyPublisher<Repositories?, Never> {
        return repositoriesSubject.eraseToAnyPublisher()
    }
    
    /// GET リクエストを送信し、repositoryを持ってくるメソッド
    func search(queryString searchWord: String) {
        let trimmedQuery = searchWord.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }

        let requestProtocol = GitHubSearchRepositoriesRequest(searchQueryWord: trimmedQuery)
        apiClient.request(requestProtocol, type: GitHubAPIType.searchRepositories) { result in
            switch result {
            case let .success(repositories):
                // model: API側から持ってくるRepositories
                guard let repositories else { return }
                // VCに渡す用のinstance
                let repositoriesView = Repositories(repositories: repositories)
                // subjectを通してModelを送る
                self.repositoriesSubject.send(repositoriesView)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
```


&nbsp;

----------

### Combine

　2019年 Apple が公表した非同期フレームワーク `Combine` を利用してリアクティブプログラミングの実装にチャレンジしました。<br>
　[Combineの公式ドキュメント](https://developer.apple.com/documentation/combine) によると、`Combine` を下記のようにまとめられます。<br>

 > 時間の経過に応じて変更する値をエクスポートする `Publisher` と、それを受信する `Subscriber` を利用して時間の経過に応じた値を処理する `Swift` API

　つまり、`Publisher` と `Subscriber` を利用して効率的に非同期プログラミングを処理するために登場したと思います。`Combine` の登場前はこの非同期プログラミングの処理に `RxSwift` を使っていました。<br>
　それでは、`Combine` の主要概念である `Publisher` と `Subscriber`、`Operator` についてみていきましょう。

&nbsp;

#### 📍 `Publsiher`
　`Publisher` は時間の経過に応じて、値と完了信号を発行する役割を果たします。この完了信号は、正常に値の発行を完了したか、エラーが起きて失敗したかを表す信号です。<br>

```swift
/// 
public protocol Publisher<Output, Failure> {
    associatedtype Output
    associatedtype Failure : Error

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
}
```
　 `Publisher` は必ず、２つの `Generic Type` を持つ必要があります。上記のコードでわかるように、`OutPut` と `Failure` のタイプを定義する必要があります。意味は下記のようになります。
  - `Output` : `Publisher` が放出する値の種類
  - `Failure` : `Publisher` が放出するかもしれないエラーの種類
　   - `Never` : Error が発生することがないのを明示するタイプ

　後述しますが、`Publisher` から発行されるデータを受け取る `Subscriber` の `Input` & `Failure` も当然に `Publisher` の `Output` & `Failure` タイプと一致しなければならないです。<br>
　この `Publisher` は主に以下のような種類があります。
  - `Just`
  - `Future`
  - `Subject`

本アプリでは `Subject` を用いた開発を進めたため、この文書では `Subject` について説明します。

##### `Subject`
　`Subject` は、`Publisher` プロトコルを採択したプロトコルです。つまり、`Publisher` の一種のオブジェクトです。<br>
  `Publisher` が値を保持する主体だったとすれば、この値に他の値を注入できるのが `Subject` であると理解していただければいいです。<br>
  `Subject` は以下のように２つのクラスで実現されます。
  - `CurrentValueSubject`
  - `PassthroughtSubject`

　後述する `send` メソッドを通して、`Publisher` から発行されたデータを購読者 `Subscriber` に送信することができます。特に、`Subject` クラスのインスタンスで主に使用されます。<br>
　それでは、それぞれについて見ていきましょう。

##### `CurrentValueSubject`
- 常に最新の値を保持し、購読が開始されたときにその値を即座に送信します。
- 初期値の設定が可能です。
- 現在の値にアクセスしたり、値を更新することが可能です。
- 上記の理由より、主に現在の状態を追跡するときに便利です。

```swift
import Combine

// 0に初期値を設定
let currentValueSubject = CurrentValueSubject<Int, Never>(0)
// 初期値にアクセス可能
print(currentValueSubject.value) // 0

// sinkメソッドで発行されるデータを受け取る
let subscription = currentValueSubject.sink { value in
    print("Received value: \(value)")
}

currentValueSubject.send(1) // "Received value: 1"
currentValueSubject.send(2) // "Received value: 2"
print(currentValueSubject.value) // 2
```

##### `PassthroughSubject`
- 値を保持せず、新しい値が発行されたときのみ`Subscriber` に送信します。
- 過去の値にアクセスすることが不可能です。
- 上記の理由より、イベントストリームの送信に適しています。

```swift
import Combine

// 初期値を設定不可
let passthroughSubject = PassthroughSubject<String, Never>()
let subscription = passthroughSubject.sink { value in
    print("Received value: \(value)")
}

// 過去の値にアクセス不可
passthroughSubject.send("Hello") // "Received value: Hello"
passthroughSubject.send("World") // "Received value: World"
```

&nbsp;

-------------


#### 📍 `Subscriber`

　値や完了信号を発行する `Publisher` が存在すれば、それらを受信して処理する存在も必然的に必要になりそうですよね。この存在を `Subscriber` といいます。<br>
　`Subscriber` は `Publisher` を購読することで、が発行するデータ（値、完了信号）を受信し、それらを処理します。<br>
　この `Subscriber` には主に以下のような種類があります。下記のメソッドで `Publisher` と `Subscriber` をバインディング（連結）できます。
  - `subscribe`
  - `assign`
  - `sink`
  - `receive`

それでは、それぞれについてみていきましょう。

##### `subscribe`
- `Subscriber` プロトコルを継承した購読者クラスを直接定義し、生成したクラスを使用して購読します。

　しかし、Apple は、直接実装して購読を実現することをお勧めしないらしいです。<br>
　また、後述する `sink` などのメソッドでは明示的に `subscribe` を実装しなくても暗黙的に処理してくれるので、実務では `sink` や `assign` を使うケースが大多数のようです。<br>
  下記に書いたコード例を見ればわかると思いますが、開発のときに毎度 `Publisher` ごとに `Subscriber` クラスを定義・生成して一つ一つ実現する方法は非効率なので、、

```swift
/// 1 ~ 7を放出する Publisherを生成
let publisher = (1...7).publisher
  
// Subscriber を継承する Custom Subscriberを生成
class IntSubscriber: Subscriber {
  
  // type alias を用いて 生成した publisherの OutputとFailure タイプと一致する Input と Failure　タイプを定義
  typealias Input = Int
  typealias Failure = Never
  
  // publisherから生成された subscriptionを受け取る際に呼び出されれるメソッド
  func receive(subscription: Subscription) {
    // subscription の .request(_:) を呼び出しを通して受信する値の数に制限がないことを知らせる (制限したい場合は .max(数) を使う)
    subscription.request(.unlimited)
  }

// 各値を受信する際に呼び出されるメソッド
  func receive(_ input: Int) -> Subscribers.Demand {
    // 受信した値を print
    print("Received value", input)
    // .none を返して、subscriberの需要に関して調整が不要であることを知らせる (=.max(0))
    return .none
  }

  // 完了イベントを受信される際に呼び出されるメソッド
  func receive(completion: Subscribers.Completion<Never>) {
    // 受信処理を完了したことを print
    print("Received completion", completion)
  }
}
  
// 上記で作成したクラスのインスタンスを生成
let subscriber = IntSubscriber()
// publisherにsubscribeメソッドをつけて使用
publisher.subscribe(subscriber)

// 出力結果
Received value 1
Received value 2
Received value 3
Received value 4
Received value 5
Received value 6
Received value 7
Received completion finished
```

##### `assign`
- オブジェクトのプロパティに直接値を割り当てるときに使用します。
- 完了シグナルやエラーイベントは処理しません。

```swift
class CustomClass {
    var receivedInt: Int = 0 {
        didSet {
            print("Received Int : \(receivedInt)", terminator: "\n")
        }
    }
}

var customObject = CustomClass()
let customRange = (0...3)
cancellable = customRange.publisher
    .assign(to: \.receivedInt, on: customObject)

// 出力結果 (完了信号は出力されない)
Received Int : 0
Received Int : 1
Received Int : 2
Received Int : 3

```

##### `sink`
- 値と完了及びエラーイベントの両方を処理できます。
- 値を処理する際に使われる最も一般的な方法です。

```swift
let customRange = (0...3)
cancellable = customRange.publisher
    .sink(receiveCompletion: { print ("completion: \($0)") },
          receiveValue: { print ("Received Value: \($0)") })

// 出力結果
//  Received Value: 0
//  Received Value: 1
//  Received Value: 2
//  Received Value: 3
//  completion: finished
```

　`sink` メソッドを通して、値が発行された時に呼び出される `receiveValue` と `Publihser` が正常に終了したり、`Error` が起きて終了した時に呼び出される `receiveCompletion` クローザーを用いて、値やイベントを処理することができます。

##### `receive`
- `Publisher` の値を特定のスレッドで受信したり、後述する `Operator` のチェーン内で値を渡すときに使用します。
  - ここで、「チェーン内」といのは、複数の `Operator` を順番に組み合わせて使用することを指します。
- 完了およびエラーイベントは処理しません。

`receive`は `Publisher` と `Subscriber` をバインディングするという認識よりかは、スレッドの指定のときによく使われるので、ここに記載するか迷ったんですが、一応 `受信する`という観点から入れておきました。

```swift
let subject = PassthroughSubject<String, Never>()

let subscription = subject
    .receive(on: DispatchQueue.main) // メインスレッドで受信 (参考：UIの Drawingはメインスレッドで処理する必要がある)
    .sink { value in
        print("Received Value: \(value)")
    }

subject.send("Hello, Combine!")

// 出力結果
//  Received Value: Hello, Combine!
```

次に `Publisher` と `Subscriber` の間の関係を管理し、非同期処理のキャンセル時に使われる `store` と `AnyCancellable` について紹介します。

##### `store`
- `AnyCancellable` オブジェクトをSetに保存し、メモリ管理を支援する役割を担います。
- `Publisher` が生成する `AnyCancellable` インスタンスをこのSetに保存することで、これらのインスタンスがすべてキャンセルされるまで `Publisher` と `Subscriber` の関係を維持します。

##### `AnyCancellable`
- `Subscriber` が `Publisher` を購読する際に返される型です。
- これを使用して `Subscriber` が `Publisher` との購読をキャンセルできます。

　まとめると、`store` で `AnyCancellable` を保持しておいて、当該の変数が `deinit` されるとき、購読をキャンセルする方法になります。<br>
　`Set` で複数のSubscription（購読）を１つにまとめることができ、`Subscription` の値を保持します。<br>
　実際のコード例を下記に示します。

```swift
/// ViewModel
private let viewModel = HomeViewModel()
private var cancellables = Set<AnyCancellable>()

// repositoriesSubjectは viewModel側で定義した CurrentValueSubjectのインスタンス
viewModel.repositoriesSubject
   .receive(on: DispatchQueue.main)
   .sink { [weak self] repositories in
      guard let self, let repositories else { return }
      self.updateSnapshot(repositories: repositories.items)
   }
   .store(in: &cancellables)

// 他のコード省略
```

&nbsp;

-------------

#### 📍 `Operator`
　`Publisher` が発行する値を変換・操作、またはフィルタリングするメソッドです。さまざまな演算子を使用してデータストリームを処理し、希望する形に変換することができます。
　`Operator` を効率的に使うことで、データの処理パイプラインを構築することができます。
  `Operator` には `map`, `filter`, `flatMap`などが当てはまりますが、今回新しく学んだ `CombineLatest` と `eraseToAnyPublisher` について紹介したいと思います。

##### `CombineLatest`
- 複数の `Publisher` からの最新の値を組み合わせて新しい値を生成します。
- 各 `Publisher` が新しい値を出すたびに、それらを組み合わせて新しい出力を生成します。

　実際のコード例を下記に示します。

```swift
import Combine

// Publisher 側の役割として、PassthroughSubject を用意
let publisher1 = PassthroughSubject<Int, Never>()
let publisher2 = PassthroughSubject<String, Never>()

// CombineLatest で組み合わせた Publisher を定義し、出力をコンソールに print する sink を設定する
let combined = Publishers.CombineLatest(publisher1, publisher2)
    .map { "\($0) \($1)" } // 組み合わせた各値を一つの文字列にマップ（タイプの変換）
    .sink { print("Combined value: \($0)") }

publisher1.send(1)
publisher2.send("A")
publisher1.send(2)
publisher2.send("B")

// 出力結果はsendの順（最新の値）
Combined value: 1 A
Combined value: 2 A
Combined value: 2 B
```

##### `eraseToAnyPublisher`
- 型消去を行い、具体的な `Publisher` の型を非公開の `AnyPublisher` 型に変換します。
- `Publisher` の型の詳細を隠蔽できるため、外部に露出せず Type Safety を保ちながらもコードを簡潔に保つことができます。
- API 設計を単純化し、使う側は `Publisher` のタイプに対する知識がなくても、使用しやすくなります。

　[eraseToAnyPublisherの役割・使用利点 (韓国サイト)](https://0urtrees.tistory.com/366) を参考にした実際のコード例を下記に示します。

```swift
// eraseToAnyPublisher 未使用
final class APIClient {
　　// return の方で一番下に書いたメソッド（receive(on: _)）を先に記述する（Publishers.ReceiveOn<>）
   // Operator を多く使用した場合、複雑なタイプを変換することになる
   // 必要に応じてメソッドの中間演算過程が変更されたら、このメソッドを使う全ての既存のコードに影響を与える
   func fetchWeather1(
      city: String
   ) -> Publishers.ReceiveOn<Publishers.Catch<Publishers.Map<Publishers.Decode<Publishers.MapKeyPath<URLSession.DataTaskPublisher, Data>, WeatherResponse, JSONDecoder>, Weather>, Empty<Weather, Error>>, RunLoop> {
      guard let url = URL(string: Constants.weather(city: city)) else { fatalError("Invalid URL!") }
      return URLSession.shared.dataTaskPublisher(for: url)
         .map(\.data) // KeyPathを用いて data, responeの中、dataのみを抽出してdownstreamに移動させる
         .decode(type: WeatherResponse.self, decoder: JSONDecoder()) // デコーディング
         .map { $0.main } // デコードしたWeatherResponseのmain（ Weather フィルド ）のみをdownstreamに移動させる
         .catch { _ in Empty<Weather, Error>() } // エラー発生時に、Empty Typeに返す
         .receive(on: RunLoop.main) // main threadで受け取って動作するようにする
   }
}

// eraseToAnyPublisher 使用
final class APIClient {
   // 中間の演算過程が露出されず、OutPutと Error タイプだけ確認できるようになる
   // 外部からは抽象化された AnyPublisher　タイプを使うので、コードの可読性も向上される
   // つまり、外部のコードに影響与えない
   func fetchWeather2(city: String) -> AnyPublisher<Weather, Error> {
      guard let url = URL(string: Constants.weather(city: city)) else { fatalError("Invalid URL !") }
      return URLSession.shared.dataTaskPublisher(for: url)
         .map(\.data)
         .decode(type: WeatherResponse.self, decoder: JSONDecoder())
         .map { $0.main }
         .catch { _ in Empty<Weather, Error>() }
         .receive(on: RunLoop.main)
         .eraseToAnyPublisher()
   }
}
```

&nbsp;

-------------

### UICollectionViewDiffableDataSource
`UICollectionViewDiffableDataSource` は、`UICollectionView` のデータソースをより簡単かつ安全に管理できるクラスです。<br>
既存に使っていた `UICollectionViewDataSource` との相違点としては、スナップショット(`Snapshot`) を使用して変更事項をアニメーションと共に安全に適用することができることです。

```swift
private enum Section: CaseIterable {
    // 今回はsection１つしか使わないので、mainだけ定義
    case main
}

// MARK: - Life Cycle & Variables
class HomeViewController: UIViewController {

    // 他のコード省略

    private var dataSource: UICollectionViewDiffableDataSource<Section, Repositories.Repository>!
    private lazy var repositoryCollectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.contentInsetAdjustmentBehavior = .always
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
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
    
    /// CollectionViewのDatasource 設定
    private func setupDataSource() {
        /// RepositoryCollectionViewCellをCellRegistrationで設定
        let repositoryCell = UICollectionView.CellRegistration<RepositoryCollectionViewCell, Repositories.Repository>() { cell, indexPath, repository in
            // <CellのType(クラス名とか), Itemで表示するもの>
            cell.backgroundColor = .white
            cell.configure(with: repository)
            // cellにUICellAccessory（accessories）を追加
            cell.accessories = [
                .disclosureIndicator()
            ]
        }

        // DiffableDataSourceの初期化
        dataSource = UICollectionViewDiffableDataSource<Section, Repositories.Repository>(collectionView: repositoryCollectionView) { collectionView, indexPath, repository in
            return collectionView.dequeueConfiguredReusableCell(using: repositoryCell, for: indexPath, item: repository)
        }
        /// DataSourceに表示するSectionとItemの現在のUIの状態
        var snapshot = NSDiffableDataSourceSnapshot<Section, Repositories.Repository>()
        // Snapshotの初期化
        // appendSections: snapShotを適用するSectionを追加
        // apply(_ :animatingDifferences:) : 表示されるデータを完全にリセットするのではなく、incremental updates(増分更新)を実行してDataSourceにSnapshotを適用する
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /** ViewModelなどViewController側で常に監視しておくべき対象を、セットアップ
     イベント発生時に正常にデータバインドをするために、Observerを設定する感じ
     
    - Combineで流れたきたデータのアウトプットsinkする
    - sink : Publisherからのイベントを購読する.  つまり、イベントを受信したときの処理を指定できる。
    - receive(on:)：イベントを受け取るスレッドを指定する
    - store: cancellabeなどを保
     */
    private func bind() {
        viewModel.repositoriesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositories in
                guard let self, let repositories else { return }
                self.updateSnapshot(repositories: repositories.items)
            }
            .store(in: &cancellables)
    }

    // viewModelから受け取った値をsnapShotの更新を通して、画面に反映させる
    private func updateSnapshot(repositories: [Repositories.Repository]) {
        /// DataSourceに適用した現在のSnapShotを取得
        var snapshot = dataSource.snapshot()
        // reloadItemsは既存セルの特定のCellだけをReloadするので、deleteしたあとに改めてappendする形でSnapshot適用
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(repositories, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let repository = viewModel.repositoriesSubject.value?.items[indexPath.row] else { return }
        let detailViewController = DetailViewController(repository: repository)
        navigationController?.pushViewController(detailViewController, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
```
&nbsp;

-------------

### UICollectionViewCompositionalLayout
`UICollectionViewCompositionalLayout` は、複雑で多様なレイアウトを簡単に構成できるようにするレイアウトクラスです。<br>
さまざまなアイテムとグループを組み合わせて、柔軟なレイアウトを作成できます。<br>
また、`UICollectionViewCell` のサイズを動的に計算してくれるので、既存の `Cell` の `height` や `width` のようなサイズを動的に計算するために使用した `UICollectionViewDelegateFlowLayout` プロトコルの `sizeForItemAt` メソッドを使う必要がなくなります。<br>

```swift
var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
let layout = UICollectionViewCompositionalLayout.list(using: config)
```
`UICollectionLayoutListConfiguration` は、リストスタイルの CollectionView のレイアウトを設定するために使用しました。<br>
`appearance` はリストの外観を設定しており、ここで `insetGrouped` はグループ化されたスタイルを指します。<br>
`UICollectionViewCompositionalLayout.list(using:)` は、リストスタイルのレイアウトを作成します。<br>
上記のコードを使うことで、リストスタイルの `UICollectionView` を簡単に設定できるようにしてくれます。<br>
本アプリでは、設定アプリの TableView に似たUIを作成さたかったので、`UICollectionLayoutListConfiguration` を採用しました。

&nbsp;

-------------

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

### 参照及びARC関連
Swiftでは、メモリ使用を追跡して管理するために、それらを自動的に処理する ARC(Automatic Reference Counting) を使用します。<br>
　
ARC は、オブジェクトのライフサイクルを管理してメモリ漏れを防止し、オブジェクトがもはや必要ないときにメモリを解除します。<br>
つまり、メモリの参照回数を計算して、参照回数が 0 になれば、これ以上使わないメモリだと思って解除してくれるという仕組みになっています。<br>
ここで、RC とは、あるインスタンスを現在誰が指しているかどうかを数字で表したものです。
この ARC において重要な概念は、以下のようになります。
  - 強参照（strong reference）
  - 弱参照（weak reference）
  - 循環参照（retain cycle）

#### 強参照
- デフォルトの参照タイプで、オブジェクトのライフサイクルを維持します。
- オブジェクトが強参照で接続されていると、参照カウントが増加し、このカウントが 0 になるまで、オブジェクトはメモリから解放されません。

```swift
class Person {
    // 強参照
    var name: String
    var city: City? // Optionalタイプの有無は 参照の強度とは関係ない
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class City {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

var person: Person? = Person(name: "Kyulee")
var city: City? = City(name: "Tokyo")

person?.city = city  // person が city を強く参照
city = nil  // city インスタンスは nil であるが、 person が強参照を維持
person = nil  // ここで、person と pet 、両方とも deinit される

// 出力結果 (上からの順番)
Kyulee is being deinitialized
Tokyo is being deinitialized

```

#### 弱参照
- 弱参照は参照カウントを増加させることはなく、参照対象オブジェクトが解除されると自動的に `nil` に設定されます。
- 弱参照は常に `Optional` タイプである必要があります。理由としては、オブジェクトが解除されたときに `nil` が割り当てられる可能性があるからです。
- 弱参照は、参照対象オブジェクトが解放された後も安全にアクセスできます。
- 主に強い参照循環を避けるために使用されます。
- `weak` キーワードを使って、参照カウントの増加を防げます。 

```swift
class Person {
    var name: String
    // 弱参照
    weak var friend: Person?
    
    init(name: String) {
        self.name = name
    }
}

var person1: Person? = Person(name: "Kyu")
var person2: Person? = Person(name: "Lee")

person1?.friend = person2
person2?.friend = person1

person1 = nil
// person2はまだ存在するが、person1に対する弱参照がnilになる
```

#### 循環参照
- 2つのオブジェクトが互いを強く参照し、互いの参照カウントを減少させることができない状況を指します。これにより、メモリのリークが発生します。
- 循環参照によるメモリリークを回避するために、弱参照（`weak`）、または無所有参照（`unowned`）を使用します。

ここで、無所有参照について軽く見ていきましょう。

##### `unowned` 無所有参照
- 参照するオブジェクトがメモリから解放されても、無所有参照は自動で `nil` に割り当てされません。
- 無所有参照は `Optional` タイプでなくてもよいです。これは、オブジェクトが常に有効であると仮定するときに使用されます。
- 参照対象オブジェクトが解除された後、無所有参照にアクセスすると、ランタイムエラーが発生する可能性があります。
- 上記の理由から、無所有参照は、オブジェクトが同じライフサイクルを共有するか、オブジェクトが解除されないと確信している場合にのみ使用する必要があります。

```swift
class Customer {
    var name: String
    var card: CreditCard?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    var number: UInt64
    unowned var customer: Customer  // 無所有参照
    
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    
    deinit {
        print("Card \(number) is being deinitialized")
    }
}

var customer: Customer? = Customer(name: "Kyu Lee")
customer?.card = CreditCard(number: 1234_5678_9012_3456, customer: customer!)

customer = nil
// customerが解除されcardも解除される
```

 今回の開発において、closure 内の循環参照を避けることを意識し、`weak self` を使うことにしました。

 ```swift
let button = UIButton(configuration: config)
button.addAction(.init { [weak self] _ in
   guard let self else { return }
   self.didTapStarButton()
}, for: .touchUpInside)
```

上記のコードの closure 内で `weak self` を使う理由はメモリリークの発生可能性のある強い循環参照を避けるためです。<br>
`UIButton` の `addAction` メソッドに closure を渡すとき、clousure は `self` をキャプチャーして参照することになります。<br>
もし、`closure` が `self` を強く参照すると、`UIButton` が `self` を強く参照し、`self` も `closure` を強く参照する循環参照が発生します。<br>
この循環参照により、両方のオブジェクトがメモリから正常に解放されないという問題が生じます。<br>
これを防止するために、`closure` が `self` を弱く参照するように `weak` 弱参照のキーワードを使いました。


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
- 本アプリは`GitHub Rest API`の中、検索用のエンドポイントと星付け・解除用のエンドポイントを使用しています。検索用の`struct`である`GitHubSearchRepositoriesRequest`と星付け・解除用である`GitHubStarRepositoriesRequest`はそれぞれ異なるリクエストを処理していますが、ジェネリックとプロトコルを用いることでコードの再利用性を増やすことができます。

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

`背景`<br>
- 今回のアプリを実装するまでは、無意識でAPIを叩いて返ってくるレスポンスを`APIClient`で処理してViewControllerで直接渡すようなコードを書いていた。これはレスポンスの形に依存しちゃうのでは？と考えていてこの依存度をどう分離するかを悩んていたものの、依存度を分離せずに普段から慣れていたコードを書きました。<br>
- すると、レビュアーの方からまさにここの部分を指摘され、API叩きから得られるレスポンス用のデータモデルと画面に表示する用のデータモデルを分岐することで依存度を減らせることを教わりました。

`解決`<br>
- レスポンスの形式に依存することはアンチパターンであると考え、ビューに表示するためのモデルを生成して適用しました。<br>
- データモデルをAPIから取得するリポジトリのデータ用の `RepositoriesResponse` と、それらを画面に表示するための `Repositories` に分けました。これにより、`Codable` を継承する `struct` 内の不要な `CodingKeys` ロジックを排除することができます。<br>
- また、ビュー表示用のモデルを用意して関心事の分離をすることで、テストも容易になります。例えば、API処理のテストを行うときは `RepositoriesResponse`を、 UIのテストを行うときは `Repositories`のみをテストすればいいので、コード作成の効率性も上がります。

&nbsp;
