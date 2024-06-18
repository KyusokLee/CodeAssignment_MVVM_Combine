//
//  ViewController.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import UIKit
import SnapKit
import Combine

/** DiffableDataSourceで用いるSectionIdentifierType
- CaseIterableを採択したenum(列挙型)は、自動的に全てのケースのコレクションを提供するallCases属性を持つようになる
- これにより、enumのすべてのケースを繰り返ししたり、容易にアクセスできる
 */
private enum Section: CaseIterable {
    // 今回はsection１つしか使わないので、mainだけ定義
    case main
}

// MARK: - Life Cycle & Variables
class HomeViewController: UIViewController {
    /// ViewModel
    private let viewModel = HomeViewModel()
    /// Custom Loading View
    private let loadingView = LoadingView()
    /// 検索開始前に表示するReadyView
    private let readyView = ReadySearchView()
    /** storeでAnyCancellableを保存しておいて、当該の変数がdeinitされるとき、subscribeをキャンセルする方法
    - Setで複数のSubscription（購読）を１つにまとめることができ、Subscriptionの値を保持する
     */
    private var cancellables = Set<AnyCancellable>()
    /** リポジトリデータを管理するUICollectionViewDiffableDataSource
    - UICollectionViewDiffableDataSource<SectionIdentifierType: Hashable & Sendable, ItemIdentifierType: Hashable & Sendable>
    - CollectionViewに表示する各SectionもHashableを採択する必要があるが、CaseIterable採択でも可能
    - CaseIterableを採択すると、自動的にallCasesが取得される。ただし、associated typeがないことが条件。
    - enumタイプにassociated typeがなければ、自動的にHashableを遵守することになる
    - Hashable プロトコルの採択が必須
     */
    private var datasource: UICollectionViewDiffableDataSource<Section, Repositories.Repository>!
    /** DataSourceに表示するSectionとItemの現在のUIの状態
    - appendSections: snapShotを適用するSectionを追加
    - apply(_ :animatingDifferences:) : 表示されるデータを完全にリセットするのではなく、incremental updates(増分更新)を実行してDataSourceにSnapshotを適用する
     */
    private var snapshot: NSDiffableDataSourceSnapshot<Section, Repositories.Repository>!
    private let layout: UICollectionViewLayout = {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .none
        config.footerMode = .none
        return UICollectionViewCompositionalLayout.list(using: config)
    }()
    
    private lazy var repositoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
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
        setupDataSource()
        setAddSubViews()
        setupConstraints()
    }
    
    /// CollectionViewのDatasource 設定
    private func setupDataSource() {
        // DiffableDataSourceの初期化
        datasource = UICollectionViewDiffableDataSource<Section, Repositories.Repository>(collectionView: repositoryCollectionView) { [weak self] collectionView, indexPath, repository in
            // weak selfを用いて、メモリリークを防ぐ
            // Closure内でselfを弱い参照でキャプチャすることで、HomeViewControllerインスタンスが解除されたとき、Closureが自動でnilに設定されるので、メモリの解除ができる
            guard let self else { return UICollectionViewCell() }
            return collectionView.dequeueConfiguredReusableCell(using: self.repositoryCell, for: indexPath, item: repository)
        }
        snapshot = NSDiffableDataSourceSnapshot<Section, Repositories.Repository>()
        // Snapshotの初期化
        snapshot.appendSections([.main])
        datasource.apply(snapshot, animatingDifferences: true)
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
            .sink { [weak self] repositories in
                guard let self else { return }
                guard let repositories else { return }
                self.updateSnapshot(repositories: repositories.items)
                self.loadingView.isLoading = false
            }
            .store(in: &cancellables)
        
        viewModel.loadingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                self.loadingView.isLoading = isLoading
            }
            .store(in: &cancellables)
    }
    
    private func updateSnapshot(repositories: [Repositories.Repository]) {
        /// DataSourceに適用した現在のSnapShotを取得
        var snapshot = datasource.snapshot()
        // reloadItemsは既存セルの特定のCellだけをReloadするので、deleteしたあとに改めてappendする形でSnapshot適用
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(repositories, toSection: .main)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    /// カスタムで作ったViewを全部追加する
    private func setAddSubViews() {
        view.addSubview(repositoryCollectionView)
        view.addSubview(loadingView)
        view.addSubview(readyView)
    }
    
    /// Layoutの制約を調整する
    private func setupConstraints() {
        repositoryCollectionView.snp.makeConstraints { constraint in
            constraint.edges.equalToSuperview()
        }
            
        loadingView.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide)
            constraint.leading.trailing.bottom.equalToSuperview()
        }
        
        readyView.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide)
            constraint.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    /// Return(検索)キーをタップしたときの処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
        // Loading View表示
        loadingView.isLoading = true
        // readyViewのisHidden処理
        if readyView.isBeforeSearch {
            readyView.isBeforeSearch = false
        }
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
