//
//  SavedNewsTableViewCell.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import UIKit

class SavedNewsTableViewCell: UITableViewCell {
    static let identifier = "SavedNewsTableViewCell"
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorLabel, sourceLabel,descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SavedNewsTableViewCell {
    func configureViews() {
        authorLabel.numberOfLines = 0
        sourceLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}

extension SavedNewsTableViewCell {
    func configureCell(with data: SavedNewsModel) {
        authorLabel.text = data.author
        descriptionLabel.text = data.articleDescription
        sourceLabel.text = data.source?.name
    }
}
