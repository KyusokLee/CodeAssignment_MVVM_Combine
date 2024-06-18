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

https://github.com/KyusokLee/CodeAssignment_MVVM_Combine/assets/89962765/c150f77e-80b1-4693-a1c0-4e6cad482269

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
* [Trouble Shooting](#-trouble-Shooting)
    * [CompositionalLayout](#CompositionalLayout)
    * [NSDiffableDatasourceSnapshot](#NSDiffableDatasourceSnapshot)
* [工夫点](#-工夫点)
    * [Personal Access Token の管理方法](#Personal-Access-Token-の管理方法)
    * [エラー処理](#エラー処理)
    * [UI/UX 設計](#UI/UX-設計)

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

&nbsp;

### データ・UIイベント処理

* Combine

&nbsp;

## 📱 機能及びUI

|機能/UI|説明|
|:-|:-|
|検索||
|閲覧リスト||
|詳細画面||
|星付け||
|星付け解除||

&nbsp;

## 💻 設計及び実装

### MVVM


&nbsp;

### 役割分担

|class/struct|役割|
|:-|:-|


&nbsp;

### Utilities

|class/struct|役割|
|:-|:-|
|`APIClient`|APIを呼び出すために必要な処理を管理するクラス。HTTPリクエスト、データの取得、エラーハンドリングなどを担当する。|

&nbsp;

## 💪🏻 技術的チャレンジ

### MVVM



&nbsp;

### Combine

連続したescaping closureを避け、宣言型プログラミングを通じた高い可読性とオペレーターを通じた効率的な非同期処理のためにCombineを採択しました。

&nbsp;

## 🔥 Trouble Shooting

### CompositionalLayout

&nbsp;

### NSDiffableDatasourceSnapshot

&nbsp;


## 😵‍💫 工夫点

### Personal Access Token の管理方法
    


&nbsp;

### エラー処理


&nbsp;

### UI/UX 設計

> [ホーム画面UIの参考資料URL]() <br>
