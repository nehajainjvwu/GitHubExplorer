//
//  Service.swift
//  GitHubExplorer
//
//  Created by Neha2 Jain on 23/08/21.
//

import Foundation
import GithubAPI

typealias OnResponse = (_ response: SearchRepositoriesResponse?, _ error: Error?) -> Void

func getSearchResults(for text: String, onResponse: @escaping OnResponse) {
    SearchAPI().searchRepositories(q: text, page: 1, per_page: 20) { (response, error) in
        if let response = response {
            onResponse(response, nil)
        } else {
            print(error ?? "")
        }
    }
}



