//
//  LoadingButton.swift
//  tvSeries
//
//  Created by mobile consulting on 12/9/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation
import UIKit

class LoadingButton: UIButton {
    var buttonImage: UIImage?
    var activityIndicator: UIActivityIndicatorView!
    
    @IBInspectable
    let activityIndicatorColor: UIColor = .lightGray
    func showLoading() {
        if self.backgroundImage(for: .normal) == #imageLiteral(resourceName: "custom_download_2") {
            buttonImage = #imageLiteral(resourceName: "custom_trash_1")
        } else {
            buttonImage = #imageLiteral(resourceName: "custom_download_2")
        }
        self.setBackgroundImage(nil, for: .normal)
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
    }
    func hideLoading() {
        activityIndicator.stopAnimating()
        self.setBackgroundImage(self.buttonImage, for: .normal)
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerX,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}




