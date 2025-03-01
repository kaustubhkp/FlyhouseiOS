//
//  Storyboardable.swift
//

import Foundation
import UIKit

protocol Storyboardable: AnyObject{
    static var storyboardName: StoryBoardName { get }
}

extension Storyboardable where Self: UIViewController {
    static var storyboardName: String {
        return storyboardName.rawValue
    }
    
    static func storyboardViewController() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let name = String(describing: self)
        guard let vc = storyboard.instantiateViewController(withIdentifier: name) as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(storyboardName)")
        }
        return vc
    }
}
