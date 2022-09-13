//
//  UITableView+Register.swift
//  PayCraft
//
//  Created by Venkat Rao Sandhi on 10/18/21.
//

import Foundation
import UIKit

extension UITableView {
    public func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type,
                                                        for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self),
                                        for: indexPath) as! T
    }
}
