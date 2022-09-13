//
//  NetworkErrorViewController.swift
//  PuneMetro
//
//  Created by Admin on 16/11/21.
//

import UIKit

class NetworkErrorViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var RetryButton: FilledButton!
    var isNetworkError: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        // Do any additional setup after loading the view.
    }
    func prepareViewModel() {
    }
    
    func prepareUI() {
        var Title = "Timeout Error"
        var MsgStr = "Looks like there are some connectivity issues at this time! Please try again later"
        var RetryTitle = "TRY AGAIN"
        if !isNetworkError {
            Title = "Service Error"
            MsgStr = "Looks like there is a problem with one of our services. Please try again later"
            RetryTitle = "GO TO HOME"
        }
        metroNavBar.setup(titleStr: Title.localized(using: "Localization"), leftImage: nil, leftTap: {}, rightImage: nil, rightTap: {})
        
        titleContainer.layer.borderColor = CustomColors.COLOR_LIGHT_GRAY.cgColor
        titleContainer.layer.borderWidth = 0.5
        
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        titleLabel.text = MsgStr.localized(using: "Localization")
        titleLabel.textColor = .black
       
        RetryButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        RetryButton.setAttributedTitle(title: NSAttributedString(string: RetryTitle.localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        RetryButton.onTap = RetryButtonTap
        RetryButton.setEnable(enable: true)
    }
    @objc func RetryButtonTap() {
        if isNetworkError {
            if LocalReachability.isConnectedToNetwork() {
                print("Internet Connection Available!")
            } else {
                print("Internet Connection not Available!")
                //return
            }
        }
//        DispatchQueue.main.async {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let splashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
//            splashViewController.modalPresentationStyle = .fullScreen
//            self.present(splashViewController, animated: true, completion: nil)
//        }
         self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
