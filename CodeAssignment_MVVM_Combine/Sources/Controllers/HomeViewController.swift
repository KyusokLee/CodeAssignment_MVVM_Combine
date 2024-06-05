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
    
    private let layout: UICollectionViewLayout = {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .none
        config.footerMode = .none
        return UICollectionViewCompositionalLayout.list(using: config)
    }()
    
    private lazy var repositoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.contentInsetAdjustmentBehavior = .always
        
        return collectionView
    }()
    
    /** RepositoryCollectionViewCellをCellRegistrationで設定
    - <CellのType(クラス名とか), Itemで表示するもの>
     */
    private let repositoryCell = UICollectionView.CellRegistration<RepositoryCollectionViewCell, Repositories.Repository>() { cell, indexPath, repository in
        cell.backgroundColor = .white
        cell.configure(with: repository)
        // cellにUICellAccessory（accessories）を追加
        cell.accessories = [
            .disclosureIndicator()
        ]
    }
    
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
        view.backgroundColor = .secondarySystemBackground
        
        setupNavigationController()
        setAddSubViews()
        setupConstraints()
    }
    
    /// NavigationControllerのセットアップ
    private func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .secondarySystemBackground
        // NavigationBarの下部線を隠す
        appearance.shadowColor = .clear
        navigationController?.navigationBar.topItem?.backButtonTitle = "戻る"
        navigationController?.navigationBar.standardAppearance = appearance
        setupSearchController()
    }
    
    /** SearchControllerのセットアップ
    - NavigationControllerの中で表示するアニメーション付きのsearchBarはSearchControllerで実現できる
     */
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
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
            .sink { [weak self] _ in
                guard let self else { return }
                self.repositoryCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    /// カスタムで作ったViewを全部追加する
    private func setAddSubViews() {
        view.addSubview(repositoryCollectionView)
    }
    
    /// Layoutの制約を調整する
    private func setupConstraints() {
        repositoryCollectionView.snp.makeConstraints { constraint in
            constraint.edges.equalToSuperview()
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
   /// Return(検索)キーをタップしたときの処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
        // Returnキーを押して ViewModelで定義したsearch logicを実行
        viewModel.search(queryString: searchWord)
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

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.repositoriesSubject.value?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: repositoryCell, for: indexPath, item: viewModel.repositoriesSubject.value?.items[indexPath.row])
    }
}
