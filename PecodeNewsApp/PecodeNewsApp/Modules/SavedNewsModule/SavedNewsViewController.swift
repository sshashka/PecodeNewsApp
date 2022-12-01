//
//  SavedNewsViewController.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import UIKit

final class SavedNewsViewController: UIViewController {
    var presenter: SavedNewsPresenterProtocol?
    private var data = [SavedNewsModel]()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SavedNewsTableViewCell.self, forCellReuseIdentifier: SavedNewsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.loadNews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupView()
        setupConstraints()
        
    }
}

private extension SavedNewsViewController {
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension SavedNewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedNewsTableViewCell.identifier, for: indexPath) as? SavedNewsTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.configureCell(with: data[indexPath.row])
        return cell
    }
}

extension SavedNewsViewController: SavedNewsViewProtocol {
    func showNews(news: [SavedNewsModel]) {
        data = news
        tableView.reloadData()
    }
}
