//
//  ViewController.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 26.11.2022.
//
import UIKit

final class MainScreenViewController: UIViewController {
    var presenter: MainScreenModulePresenterProtocol?
    private var isLoadingData: Bool = false
    private let refreshControll = UIRefreshControl()
    private var data = MainScreenNews()
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "MainScreenTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getNews()
        setupView()
        setupConstraints()
    }
    
}

private extension MainScreenViewController {
    
    // MARK: Configuring view
    func setupView() {
        view.addSubview(tableView)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControll
        
        refreshControll.addTarget(self, action: #selector(refreshEverything), for: .valueChanged)
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh settings to default")
        
        let sortingButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortingBarButtonItemDidTap))
        let filteringButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.3x2.fill"), style: .plain, target: self, action: #selector(filteringBarButtonItemDidTap))
        
        navigationItem.rightBarButtonItems = [sortingButton, filteringButton]
    }
    
    @objc func refreshEverything() {
        refreshControll.beginRefreshing()
        WebImageManager.shared.removeCache()
        presenter?.resfreshData()
        refreshControll.endRefreshing()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    // MARK: Configuring sorting action
    @objc func sortingBarButtonItemDidTap() {
        let alert = UIAlertController(title: "Sorting by publishedAt", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: publishedAtDidTap))
        
        present(alert, animated: true)
    }
    
    func publishedAtDidTap(_ action: UIAlertAction) {
        presenter?.sortTypeDidChange(sortingMethod: .publishedAt)
    }
    
    //MARK: Configuring filtering action
    @objc func filteringBarButtonItemDidTap() {
        let alert = UIAlertController(title: "Select filter", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .white
        alert.addAction(UIAlertAction(title: "By category", style: .default, handler: byCategoryActionDidTap))
        alert.addAction(UIAlertAction(title: "By country", style: .default, handler: byCountryActionDidTap))
        alert.addAction(UIAlertAction(title: "By sources", style: .default, handler: bySourcesActionDidTap))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func byCategoryActionDidTap(_ action: UIAlertAction) {
        presenter?.filterMethodDidChange(filteringMethod: .byTopics)
        
    }
    
    func byCountryActionDidTap(_ action: UIAlertAction) {
        presenter?.filterMethodDidChange(filteringMethod: .byCountry)
        
    }
    
    func bySourcesActionDidTap(_ action: UIAlertAction) {
        presenter?.filterMethodDidChange(filteringMethod: .bySources)
        
    }
    
    func loadMoreNews() {
        if !isLoadingData {
            isLoadingData.toggle()
            presenter?.loadMoreNews()
        }
    }
    
}

extension MainScreenViewController: MainScreenModuleViewProtocol {
    func addNews(news: MainScreenNews) {
        data.append(contentsOf: news)
//        let indexPath = [IndexPath(row: data.count - 1, section: 0)]
//        self.tableView.performBatchUpdates {
//            self.tableView.insertRows(at: indexPath, with: .automatic)
//        }
        tableView.reloadData()
        isLoadingData.toggle()
    }
    
    func showNews(news: MainScreenNews) {
        self.data = news
        tableView.reloadData()
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Oops", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return data.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainScreenTableViewCell
            guard let cell = cell else { return UITableViewCell() }
            cell.configureCell(with: data[indexPath.row])
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier, for: indexPath) as? LoadingTableViewCell
            guard let cell = cell else { return UITableViewCell() }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = data[indexPath.row].url
        let vc = WebKitView()
        vc.urlString = url
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1, !isLoadingData {
            loadMoreNews()
        }
    }
}

extension MainScreenViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text != "" else { return }
        presenter?.searchForNews(with: text)
    }
}

extension MainScreenViewController: MainScreenTableViewCellDelegate {
    
    func didTapSaveButton(_ cell: MainScreenTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            presenter?.saveArticle(article: data[indexPath.row])
            let alert = UIAlertController(title: "Saved", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(alert, animated: true)
        }
        
    }
}
