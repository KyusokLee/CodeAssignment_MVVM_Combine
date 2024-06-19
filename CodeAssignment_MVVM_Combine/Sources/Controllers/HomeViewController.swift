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
                guard let self, let repositories else { return }
                self.updateSnapshot(repositories: repositories.items)
            }
            .store(in: &cancellables)
        
        viewModel.loadingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                self.loadingView.isLoading = isLoading
            }
            .store(in: &cancellables)

        viewModel.readyViewSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isHidden in
                guard let self else { return }
                // readyViewのisHidden処理
                self.readyView.isHidden = !isHidden
            }
            .store(in: &cancellables)
    }
    
    private func updateSnapshot(repositories: [Repositories.Repository]) {
        /// DataSourceに適用した現在のSnapShotを取得
        var snapshot = dataSource.snapshot()
        // reloadItemsは既存セルの特定のCellだけをReloadするので、deleteしたあとに改めてappendする形でSnapshot適用
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(repositories, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /// カスタムで作ったViewを全部追加する
    private func setAddSubViews() {
        view.addSubview(repositoryCollectionView)
        view.addSubview(readyView)
        view.addSubview(loadingView)
    }
    
    /// Layoutの制約を調整する
    private func setupConstraints() {
        repositoryCollectionView.snp.makeConstraints { constraint in
            constraint.edges.equalToSuperview()
        }

        [loadingView, readyView].forEach {
            $0.snp.makeConstraints { constraint in
                constraint.top.equalTo(view.safeAreaLayoutGuide)
                constraint.leading.trailing.bottom.equalToSuperview()
            }
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
