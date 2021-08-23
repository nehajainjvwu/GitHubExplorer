//
//  SearchedResultTableViewCell.swift
//  GitHubExplorer
//
//  Created by Neha2 Jain on 23/08/21.
//

import UIKit
import GithubAPI

class SearchedResultTableViewCell: UITableViewCell {
    @IBOutlet weak var titleIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var follow: UIButton!

    var result: SearchRepositoriesItem? {
        didSet {
            setUpData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setImageForFollowButton(_ imageName: String) {
        follow.setImage(UIImage(named: imageName), for: .normal)
    }

    func setUpData() {
        titleIcon.image = UIImage(named: "titleIcon")
        title.text = result?.fullName
        descriptionLabel.text = result?.descriptionField
        language.text = result?.language
    }
}
