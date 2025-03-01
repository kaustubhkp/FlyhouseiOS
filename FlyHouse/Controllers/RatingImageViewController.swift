//
//  RatingImageViewController.swift
//  FlyHouse
//
//  Created by Atul on 06/09/24.
//

import UIKit

class RatingImageViewController: UIViewController,Storyboardable {
    
    static let storyboardName :StoryBoardName = .RequestConfirm

    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var backgroundView:UIView!
    @IBOutlet weak var ratingImageView:UIView!
    @IBOutlet weak var ratingImage:UIImageView!
    var rateImageType:String! = ""
    @IBOutlet weak var actIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configuerView()
    }
    
    func configuerView(){
        self.view.backgroundColor = .clear
        //self.ratingImageView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backgroundView.alpha = 0
        self.ratingImageView.alpha = 1
        self.ratingImageView.layer.cornerRadius = 10
        self.closeButton.layer.cornerRadius = 10
        self.actIndicator.startAnimating()
        let imageUrlStr = String(format: "%@%@",APPUrls.ratingImageBaseUrl,self.rateImageType!)
        self.configure(with: imageUrlStr)
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true)
    }
    
    // Method to configure the cell with an image URL
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Clear the old image
        self.ratingImage.image = nil
        
        // Load the image from the URL asynchronously
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.actIndicator.stopAnimating()
                    self.ratingImage.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
}


