//
//  UICollectionView+Register.swift
//  PayCraft
//
//  Created by Venkat Rao Sandhi on 10/18/21.
//

import Foundation
import UIKit

extension UICollectionView {
    public func register<T: UICollectionViewCell>(cellType: T.Type,
                                                  bundle: Bundle? = nil) {
        let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
        register(nib, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
                                                             for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self),
                                        for: indexPath) as! T
    }
}
