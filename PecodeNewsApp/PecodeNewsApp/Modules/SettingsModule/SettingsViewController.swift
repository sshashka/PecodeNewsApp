//
//  SettingsViewController.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import UIKit

enum Section: String, CaseIterable {
    case sources = "Sources"
    case country = "Country"
    case category = "Category"
}

class SettingsViewController: UIViewController {
    var presenter: SettingsModulePresenter?
    var settings = [SourcesModel]()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
    private lazy var dataSource = UITableViewDiffableDataSource<Section, AnyHashable>(
        tableView: tableView,
        cellProvider: {
            (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case let item as SourcesModel:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = item.name
                return cell
            case let item as Country:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = item.rawValue
                return cell
            case let item as TopicsModel:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = item.rawValue
                return cell
            default:
                return UITableViewCell()
            }
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupConstraints()
        tableView.delegate = self
        presenter?.getSettings()
    }
}

private extension SettingsViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Section.allCases[indexPath.section] == .sources {
            presenter?.didChangeFilter(filter: .bySources, with: indexPath.row)
        } else if Section.allCases[indexPath.section] == .country {
            presenter?.didChangeFilter(filter: .byCountry, with: indexPath.row)
        } else {
            presenter?.didChangeFilter(filter: .byTopics, with: indexPath.row)
        }
    }
}


extension SettingsViewController: SettingsModuleViewProtocol {
    func showTopics(topics: [TopicsModel]) {
        snapshot.appendSections([.category])
        snapshot.appendItems(topics, toSection: .category)
        dataSource.apply(snapshot)
    }
    
    func showSources(sources: [SourcesModel]) {
        snapshot.appendSections([.sources])
        snapshot.appendItems(sources, toSection: .sources)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func showCountries(countries: [Country]) {
        snapshot.appendSections([.country])
        snapshot.appendItems(countries)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
