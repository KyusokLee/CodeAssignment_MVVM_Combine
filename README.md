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
    * [Combine](#combine)
* [工夫点](#-工夫点)
    * [画面表示用のレスポンスの結合モデルの作成](#画面表示用のレスポンスの結合モデルの作成)
    * [Personal Access Token の管理方法](#Personal-Access-Token-の管理方法)
    * [エラー処理](#エラー処理)
    * [UI/UX 設計](#UI/UX-設計)
* [Trouble Shooting](#-trouble-Shooting)
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

連続したescaping closureを避け、宣言型プログラミングを通じた高い可読性とオペレーターを通じた効率的な非同期処理のためにCombineを採択しました。

&nbsp;

## 🧐 工夫点

### 画面表示用のレスポンスの結合モデルの作成

### Personal Access Token の管理方法

### エラー処理


&nbsp;

## 🔥 Trouble Shooting

### CompositionalLayout

&nbsp;

### NSDiffableDatasourceSnapshot

&nbsp;

### UI/UX 設計

> [ホーム画面UIの参考資料URL]() <br>
