//
//  AddressListCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class AddressListCell: UITableViewCell {

    @IBOutlet weak var addressLabel1:UILabel!
    @IBOutlet weak var addressLabel2:UILabel!
    @IBOutlet weak var addressLabel3:UILabel!
    @IBOutlet weak var imageV:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let mapImg = UIImage(named: "plane_icon")?.withRenderingMode(.alwaysTemplate)
        imageV.tintColor = UIColor.darkGray
        imageV.image = mapImg
    }
    
    func configuerAirportsCell(indexPath:IndexPath,data:AirportData){
        
        if data.displayLine1 != nil{
            self.addressLabel1.text = data.displayLine1
        }
        
        if data.displayLine2 != nil{
            self.addressLabel2.text = data.displayLine2
        }
        
//        if data.state != nil{
//            if data.state != ""{
//                self.addressLabel2.text?.append(", ")
//                self.addressLabel2.text?.append(data.state!)
//            }
//        }
//
//        if data.country != nil{
//            self.addressLabel3.text = data.country
//        }
    }
}
