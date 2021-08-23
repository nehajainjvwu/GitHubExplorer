//
//  UIViewController+.swift
//  GitHubExplorer
//
//  Created by Neha2 Jain on 23/08/21.
//

import Foundation
import UIKit

protocol Storyboard { }

extension Storyboard where Self: UIViewController {

    static func instantiateFromMain() -> Self {
        let storyboardIdentifier = String(describing: self)
        // `Main` can be your stroyboard name.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No storyboard with this identifier ")
        }
        return vc
    }
}
