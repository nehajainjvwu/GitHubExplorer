//
//  WishlistViewController.swift
//  GitHubExplorer
//
//  Created by Neha2 Jain on 23/08/21.
//

import UIKit
import GithubAPI

class WishlistViewController: UIViewController, Storyboard {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!

    var wishlist = [SearchRepositoriesItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
        setupInformativeView()
        if wishlist.count > 0 {
            tableView.reloadData()
        }  else {
            showInformationView()
        }
    }

    func registerTableCell() {
        tableView.register(SearchedResultTableViewCell.self)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }

    func setupInformativeView() {
        messageLabel.text = "Sorry you didn't add anything yet. Please add something to read in your wishlist"
        messageLabel.numberOfLines = 0
        icon.image = UIImage(named: "NoWishlist")
    }

    // Show Hide Additional Info View
    func hideInformationView() {
        tableView.isHidden = false
        informationView.isHidden = true
    }

    func showInformationView() {
        informationView.isHidden = false
        tableView.isHidden = true
    }

    @objc func tappedFollowedButton(sender: UIButton) {
        let index = sender.tag
        let result = wishlist.filter({$0.id != wishlist[index].id})
        wishlist = result
        Wishlist().encodeWishlistForUserDefaults(list: wishlist)
        tableView.reloadData()
        wishlist.count <= 0 ? showInformationView() : hideInformationView()
    }
}

// TableView DataSource
extension WishlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchedResultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.follow.tag = indexPath.row
        cell.follow.setImage(UIImage(named: "followed"), for: .normal)
        cell.follow.addTarget(self, action: #selector(tappedFollowedButton), for: .touchUpInside)
        cell.result = wishlist[indexPath.row]
        return cell
    }
}

// TableView Delegate
extension WishlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = wishlist[indexPath.row]
        if let url = URL(string: result.htmlUrl ?? "") {
            UIApplication.shared.open(url)
        }
    }
}
