//
//  HomeBannerCell.swift
//  PuneMetro
//
//  Created by Venkat Rao Sandhi on 09/04/22.
//

import UIKit
class HomeBannerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
    }
    func setimage(url: String) {
        guard let URL = URL(string: url) as? URL else { return }
       // self.imageView.load(url: URL)
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
