//
//  FlagListPopupVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 05/02/24.
//

import UIKit


protocol FlagListPopupVCDelegate{
    
    func didSelectedCountry(atIndex:Int,data:CountryData)
}

class FlagListPopupVC: UIViewController,Storyboardable {
    static let storyboardName :StoryBoardName = .Login
    
    var delegate:FlagListPopupVCDelegate?
    @IBOutlet weak var flagsTableView:UITableView!
    @IBOutlet weak var doneButton:UIButton!
    var countryArr = [CountryData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flagsTableView.delegate = self
        self.flagsTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.flagsTableView.register(UINib(nibName: TableCells.FlagListViewCell, bundle: nil), forCellReuseIdentifier: TableCells.FlagListViewCell)
        self.APIGetAllCountryList()
    }
    
    func APIGetAllCountryList(){
        self.view.makeToastActivity(.center)
       
        //POST /api/Country/GetAll
        //finalcode
        let urlStr = String(format: "%@/Country/GetAll", APIUrl.baseUrl)
        
        APICountry.shared.getAllCountry(urlStr: urlStr) { response in
            
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                    self.countryArr = response.data!
                    
                    DispatchQueue.main.async {
                        self.flagsTableView.reloadData()
                    }
                }else{
                    if response.title != nil && response.description != nil{
                        CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                            
                        }
                    }
                }
            }else{
                if response.title != nil && response.description != nil{
                    CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                        
                    }
                }
            }
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton){
        self.dismiss(animated: true)
    }

}

extension FlagListPopupVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.FlagListViewCell, for: indexPath) as! FlagListViewCell
        
        let rowData = self.countryArr[indexPath.row]
        cell.countryName.text = rowData.countryName!
        let url = String(format: "%@%@",APPUrls.imageBaseUrl,rowData.flag!)
        cell.flagImage.loadImageUsingCache(withUrl: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowData = self.countryArr[indexPath.row]
        self.delegate!.didSelectedCountry(atIndex: indexPath.row,data:rowData)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}


let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}

