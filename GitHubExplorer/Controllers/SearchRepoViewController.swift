//
//  SearchRepoViewController.swift
//  GitHubExplorer
//
//  Created by Neha2 Jain on 23/08/21.
//

import UIKit
import GithubAPI

class SearchRepoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var gitIcon: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var informativeView: UIView!

    var selectedIndexes: [Int] = []
    var wishlist = [SearchRepositoriesItem]()
    var searchedResults: SearchRepositoriesResponse?
    var searchedItems: [SearchRepositoriesItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loader.stopAnimating()
                self.searchedItems.count > 0 ? self.hideInformationView() : self.showInformationView()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setupUI()
        registerTableCell()
        selectedIndexes = UserDefaults.standard.value(forKey: "SelectedIndexes") as? [Int] ?? []
        wishlist = Wishlist().decodeWishlistForUserDefaults()
    }

    func registerTableCell() {
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SearchedResultTableViewCell.self)
    }

    func setupUI() {
        gitIcon.image = UIImage(named: "github")
        message.text = "Please click on search button to search any repo."
        message.numberOfLines = 0
        showInformationView()
    }

    // Wishlist
    @objc func addToWishlist(sender: UIButton) {
        let index = sender.tag
        if wishlist.contains(where: {$0.id == searchedItems[index].id}) {
            let result = wishlist.filter({$0.id != searchedItems[index].id})
            let allIndexes = selectedIndexes.filter({$0 != index})
            wishlist = result
            selectedIndexes = allIndexes
        } else {
            selectedIndexes.append(index)
            wishlist.append(searchedItems[index])
        }
        UserDefaults.standard.setValue(selectedIndexes, forKey: "SelectedIndexes")
        Wishlist().encodeWishlistForUserDefaults(list: wishlist)
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }

    @IBAction func tappedOnWishlist() {
        let wishlistController = WishlistViewController.instantiateFromMain()
        wishlistController.wishlist = Wishlist().decodeWishlistForUserDefaults()
        self.navigationController?.pushViewController(wishlistController, animated: true)
    }

    // Information View Show/Hide
    func hideInformationView() {
        tableView.isHidden = false
        informativeView.isHidden = true
    }

    func showInformationView() {
        tableView.isHidden = true
        informativeView.isHidden = false
    }
}

// TableView DataSource
extension SearchRepoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchedResultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.follow.tag = indexPath.row
        cell.follow.addTarget(self, action: #selector(addToWishlist), for: .touchUpInside)
        if selectedIndexes.contains(indexPath.row) {
            cell.setImageForFollowButton("followed")
        } else {
            cell.setImageForFollowButton("following")
        }
        cell.result = searchedItems[indexPath.row]
        return cell
    }
}

// TableView Delegate
extension SearchRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchedItems[indexPath.row]
        if let url = URL(string: result.htmlUrl ?? "") {
            UIApplication.shared.open(url)
        }
    }
}

// SearchBar Delegate
extension SearchRepoViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loader.startAnimating()
        if searchText.isEmpty {
            showInformationView()
        } else {
            hideInformationView()
        }

        getSearchResults(for: searchText) { (response, error) in
            if let result = response {
                self.searchedResults = response
                self.searchedItems = result.items ?? []
            } else {
                self.loader.stopAnimating()
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


