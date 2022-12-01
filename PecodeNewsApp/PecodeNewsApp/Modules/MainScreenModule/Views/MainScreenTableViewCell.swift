//
//  MainScreenTableViewCell.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 26.11.2022.
//

import UIKit
import SDWebImage

protocol MainScreenTableViewCellDelegate: AnyObject {
    func didTapSaveButton(_ cell: MainScreenTableViewCell)
}

final class MainScreenTableViewCell: UITableViewCell {
    weak var delegate: MainScreenTableViewCellDelegate?
    @IBOutlet private weak var imageV: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        delegate?.didTapSaveButton(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        imageV.image = nil
        sourceLabel.text = nil
        authorLabel.text = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
}

private extension MainScreenTableViewCell {
    func configureView() {
        imageV.layer.masksToBounds = false
        imageV.layer.cornerRadius = 20
        imageV.layer.borderColor = UIColor.black.cgColor
        imageV.layer.borderWidth = 4
        imageV.clipsToBounds = true
        
        saveButton.setTitle("", for: .normal)
    }
    
    
}

extension MainScreenTableViewCell {
    func configureCell(with data: MainScreenModel) {
        imageV.sd_setImage(with: URL(string: data.urlToImage))
        sourceLabel.text = "Source " + data.source.name
        authorLabel.text = "Author " + data.author
        titleLabel.text = data.title
        descriptionLabel.text = data.description
    }
    
    
}

