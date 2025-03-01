//
//  TransportInflightServiceCell.swift
//  FlyHouse
//
//  Created by Atul on 02/09/24.
//

import UIKit

@objc protocol TransportInflightServiceCellDelegate{
    
    @objc optional
    func transportBtnPressed(option:String,value:Int)
    
    @objc optional
    func inflightServiceBtnPressed(option:String,value:Int)
}

class TransportInflightServiceCell: UITableViewCell {
    
    var delegate : TransportInflightServiceCellDelegate?
    
    @IBOutlet weak var transportationNeedTF:UITextField!
    @IBOutlet weak var InflightServiceTF:UITextField!
    @IBOutlet weak var transportationSwitch:UISwitch!
    @IBOutlet weak var inflightServiceSwitch:UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let color = UIColor.black
        let placeholder = transportationNeedTF.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        transportationNeedTF.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color,NSAttributedString.Key.font:UIFont.RegularWithSize(size: 15)])
        
        let placeholder1 = InflightServiceTF.placeholder ?? ""
        //There should be a placeholder set in storyboard or elsewhere string or pass empty
        InflightServiceTF.attributedPlaceholder = NSAttributedString(string: placeholder1, attributes: [NSAttributedString.Key.foregroundColor : color,NSAttributedString.Key.font:UIFont.RegularWithSize(size: 15)])
        
        self.transportationSwitch.isOn = false
        self.inflightServiceSwitch.isOn = false
    }
    
    @IBAction func transportSwitchValueChanged(_ sender:UISwitch){
        if sender.isOn{
            //sender.thumbTintColor = UIColor.black
            delegate?.transportBtnPressed!(option: "Yes", value: 1)
        }else{
            //sender.thumbTintColor = UIColor.hexStringToUIColor(hex: "A09387")
            delegate?.transportBtnPressed?(option: "No",value:0)
        }
    }
    
    @IBAction func inflightSwitchValueChanged(_ sender:UISwitch){
        if sender.isOn{
            //sender.thumbTintColor = UIColor.black
            delegate?.inflightServiceBtnPressed?(option: "Yes", value: 1)
        }else{
            //sender.thumbTintColor = UIColor.hexStringToUIColor(hex: "A09387")
            delegate?.inflightServiceBtnPressed?(option: "No",value:0)
        }
    }

    @IBAction func transportButtonClicked(_ sender:UIButton){
        
        ASPicker.selectOption(dataArray: ["Yes","No"]) { value, atIndex in
            self.transportationNeedTF.text = value
            
            if value == "Yes"{
                self.delegate?.transportBtnPressed!(option: value, value: 1)
            }else{
                self.delegate?.transportBtnPressed?(option: value,value:0)
            }
        }
    }
    
    @IBAction func inflightButtonClicked(_ sender:UIButton){
       
        ASPicker.selectOption(dataArray: ["Yes","No"]) { value, atIndex in
            self.InflightServiceTF.text = value
            
            if value == "Yes"{
                self.delegate?.inflightServiceBtnPressed?(option: value,value:1)
            }else{
                self.delegate?.inflightServiceBtnPressed?(option: value,value:0)
            }
        }
    }
    
}
