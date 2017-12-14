//
//  UIImageView+LoadImageUsingCache.swift
//  tvSeries
//
//  Created by mobile consulting on 12/9/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImageUsingCacheWithUrl(url : URL)
    {
        let urlString = url.absoluteString
        self.image = nil;        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject)  as? UIImage {
            self.image = cachedImage;
            print("I have been already saved")
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if  let downloadedImage = UIImage(data: data!){
                    print("Done")
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
            }
        }).resume()
    }
}
