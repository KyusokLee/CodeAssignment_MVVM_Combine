//
//  ViewController.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import UIKit
import SnapKit
import Combine

// MARK: - Life Cycle & Variables
class HomeViewController: UIViewController {
    /// ViewModel
    private let viewModel = HomeViewModel()
    /** storeでAnyCancellableを保存しておいて、当該の変数がdeinitされるとき、subscribeをキャンセルする方法
    - Setで複数のSubscription（購読）を１つにまとめることができ、Subscriptionの値を保持する
     */
    private var cancellables = Set<AnyCancellable>()
    private var repositories = [Repository]()
    private var searchWord: String?
    private lazy var repositoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 画面をTapしてもkeyboardをdismissするようにする
        self.navigationItem.searchController?.searchBar.endEditing(true)
    }
}

// MARK: - Functions & Logics
extension HomeViewController {
    /// ViewControllerのUIをセットアップする
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupNavigationController()
        setAddSubViews()
        setupConstraints()
    }
    
    /// NavigationControllerのセットアップ
    private func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        // NavigationBarの下部線を隠す
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        setupSearchController()
    }
    
    /** SearchControllerのセットアップ
     - NavigationControllerの中で表示するアニメーション付きのsearchBarはSearchControllerで実現できる
     */
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.placeholder = "リポジトリを検索"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
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
                guard let self = self else { return }
                self.repositories = repositories
                print(self.repositories)
            }
            .store(in: &cancellables)
    }
    
    /// カスタムで作ったViewを全部追加する
    private func setAddSubViews() {
        
    }
    
    /// Layoutの制約を調整する
    private func setupConstraints() {
        
    }
}

// MARK: - UISearchController Deleage
// 今後、検索候補とか表示したい
extension HomeViewController: UISearchControllerDelegate {
    
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("SearchBar text didChange")
        searchWord = searchText
    }
    
    /// Return(検索)キーをタップしたときの処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Returnキーを押して ViewModelで定義したsearch logicを実行
        viewModel.search(queryString: searchWord ?? "")
        print("Search")
    }
    
    /// Cancelキーをタップしたときの処理
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel")
    }
}
