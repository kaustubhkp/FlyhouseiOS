//
//  SafetyRatingCell.swift
//  FlyHouse
//
//  Created by Atul on 05/09/24.
//

import UIKit
import Alamofire

class SafetyRatingCell: UICollectionViewCell {
    
    @IBOutlet weak var actIndicator:UIActivityIndicatorView!
    @IBOutlet weak var rateImage:UIImageView!
    //For Rating
    static let imageCache = NSCache<NSString, UIImage>() // Shared image cache

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        rateImage.layer.cornerRadius = rateImage.frame.size.height/2
        rateImage.clipsToBounds = true
    }
    
    // Configure the cell with an image URL
    func configure(with urlString: String) {
            rateImage.image = nil // Reset image to avoid showing wrong images when reusing cells
            self.actIndicator.startAnimating()
            // Check cache before downloading the image
            if let cachedImage = SafetyRatingCell.imageCache.object(forKey: urlString as NSString) {
                self.actIndicator.stopAnimating()
                self.rateImage.image = cachedImage
                return
            }
            
            // Download the image using Alamofire
            Alamofire.request(urlString).responseData { response in
                if let data = response.data, let image = UIImage(data: data) {
                    // Cache the downloaded image
                    SafetyRatingCell.imageCache.setObject(image, forKey: urlString as NSString)
                    
                    // Update the image on the main thread
                    DispatchQueue.main.async {
                        self.actIndicator.stopAnimating()
                        self.rateImage.image = image
                    }
                }
            }
        }

}
