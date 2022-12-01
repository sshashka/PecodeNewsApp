//
//  LoadingTableViewCell.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 29.11.2022.
//

import UIKit



final class LoadingTableViewCell: UITableViewCell {
    static let identifier = "LoadingTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
