//
//  Wishlist.swift
//  GitHubExplorer
//
//  Created by Neha2 Jain on 23/08/21.
//

import Foundation
import GithubAPI

class Wishlist: NSObject {

    //Encode & Decode Wishlist to store in Userdefaults
    func encodeWishlistForUserDefaults(list: [SearchRepositoriesItem]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(list)
            UserDefaults.standard.set(data, forKey: "wishlist")
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }

    func decodeWishlistForUserDefaults() -> [SearchRepositoriesItem] {
        if let data = UserDefaults.standard.data(forKey: "wishlist") {
            do {
                let decoder = JSONDecoder()
                let wishlist = try decoder.decode([SearchRepositoriesItem].self, from: data)
                return wishlist
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        return []
    }
}
