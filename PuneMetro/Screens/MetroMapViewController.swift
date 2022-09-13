//
//  MetroMapViewController.swift
//  PuneMetro
//
//  Created by Admin on 09/08/21.
//

import Foundation
import UIKit
class MetroMapViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
   // @IBOutlet weak var mapImage: UIImageView!
    var mapImageView: UIImageView!
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        mapImageView = UIImageView.init(frame: CGRect(x: 5, y: titleContainer.frame.origin.y+titleContainer.frame.height+20, width: self.view.frame.size.width-10, height: 300))
        mapImageView.contentMode = .scaleAspectFill
        mapImageView.image = UIImage(named: "metro-route-map")
        scrollView.addSubview(mapImageView)
        metroNavBar.setup(titleStr: "Metro Map".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = .black
        titleLabel.text = "Metro Map".localized(using: "Localization")
        // mapImage.enableZoom()
        scrollView.delegate = self
        mapImageView.isUserInteractionEnabled = true
        mapImageView.clipsToBounds = false
       
    }
    func prepareViewModel() {
        
    }
}
extension MetroMapViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = mapImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalInset = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalInset = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}
// MARK: - imageView zoomIn zoomOut by using UIPinchGestureRecognizer
extension UIImageView {
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}
