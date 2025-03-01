//
//  ManageContactsVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

protocol ManageContactsVCDelegate{
    
    func didSelectContacts(contacts:[SplitContacts],splitContactIDCSV:NSMutableArray)
}

class ManageContactsVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .ManageContacts

    var delegate:ManageContactsVCDelegate?
    @IBOutlet weak var contactListTableView:UITableView!
    var myContcts = [SplitContacts]()
    var selectedCheckRows = NSMutableArray()
    var charterRequestID:Int! = 0
    var splitCharReIDCSV = NSMutableArray()
    var savedSplitPaymentDetail = NSMutableArray()
    var requestedPaxCount:Int! = 0
    var totalSplitPax:Int! = 0
    var totalExtraPax:Int! = 0
    
    @IBOutlet weak var createFriendBtn:UIButton!
    @IBOutlet weak var addSelectedBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setNavigationTitle(title: "Select Friend")
        super.delegateNav = self
        //super.setRightButton(viewC: self, imageName: "", title: "Add")
        super.setBackButton(viewC: self)
        
        // Do any additional setup after loading the view.
        contactListTableView.delegate = self
        contactListTableView.dataSource = self
        contactListTableView.register(UINib(nibName: TableCells.HeaderImageCell, bundle: nil), forCellReuseIdentifier: TableCells.HeaderImageCell)
        contactListTableView.register(UINib(nibName: TableCells.ContactsListCell, bundle: nil), forCellReuseIdentifier: TableCells.ContactsListCell)
        contactListTableView.register(UINib(nibName: TableCells.ContactsHeaderCell, bundle: nil), forCellReuseIdentifier: TableCells.ContactsHeaderCell)
        
        CommonFunction.setRoundedButtons(arrayB: [createFriendBtn], radius: self.createFriendBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: "", textColor: blackColorCode)
        
        CommonFunction.setRoundedButtons(arrayB: [addSelectedBtn], radius: self.addSelectedBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: blackColorCode, textColor: whiteColorCode)
        CommonFunction.setBottomGradientShadowToView(vC: self)
        self.APIGetAllContacts()

    }
    
    func APIGetAllContacts(){
        
        self.view.makeToastActivity(.center)
        //finalcode
        let urlStr = String(format: "%@/SplitPaymentContacts/GetAllChartererContacts", APIUrl.baseUrl)
        
        APISplitContacts.shared.getAllContacts(urlStr: urlStr) { response in
            //
            self.view.hideToastActivity()
            if response.result != nil{
                
                if response.result == "success"{
                    
                    if response.data != nil{
                        self.myContcts = response.data!
                    }
                    
                    for i in 0...self.myContcts.count - 1{
                        
                        let cont = self.myContcts[i]
                        if self.splitCharReIDCSV.contains(cont.splitPaymentContactID!){
                            self.selectedCheckRows.add(i)
                        }
                    }
                    self.totalExtraPax = self.totalSplitPax - self.selectedCheckRows.count
                    self.contactListTableView.reloadData()
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
    
    func saveChartererSplitPaymentContactIDCSV(sContact:[SplitContacts]){
        
        self.view.makeToastActivity(.center)
        
        
        var ids = "0"
        if splitCharReIDCSV.count > 0{
            ids = self.splitCharReIDCSV.componentsJoined(by: ",")
        }
        //finalcode
        let urlStr = String(format: "%@/SplitPayment/SaveChartererSplitPaymentContactIDCSV?chartererRequestID=%d&splitPaymentContactIDCSV=%@", APIUrl.baseUrl,self.charterRequestID,ids)
        
        let parameters = ["chartererRequestID":self.charterRequestID!,"splitPaymentContactIDCSV":ids] as! [String:Any]
        
        APISplitPayment.shared.saveSplitPaymentContactIDCSV(urlStr: urlStr, param: parameters) { response in
            self.view.hideToastActivity()
            
            self.delegate?.didSelectContacts(contacts: sContact,splitContactIDCSV: self.splitCharReIDCSV)
            self.navigationController?.popViewController(animated: true)
            
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    func addSelected() {
        //add selected contacts
        var mContacts = [SplitContacts]()
        self.splitCharReIDCSV.removeAllObjects()
        if self.selectedCheckRows.count > 0{
            for i in 0...selectedCheckRows.count - 1{
                let index = selectedCheckRows[i] as! Int
                var contact = myContcts[index]
                
                // Search for a dictionary where "id" is 2
                let predicate = NSPredicate(format: "SplitPaymentContactID == %d", contact.splitPaymentContactID!)
                let filteredArray = savedSplitPaymentDetail.filtered(using: predicate)
                
                if filteredArray.count > 0{
                   let data = filteredArray[0] as! [String : Any]
                    print((data["NoOfPassengers"] as! Int))
                    contact.noOfPassenger = (data["NoOfPassengers"] as! Int)
                }else{
                    contact.noOfPassenger = 1
                }
                self.splitCharReIDCSV.add(contact.splitPaymentContactID!)
                mContacts.append(contact)
            }
        }
        self.saveChartererSplitPaymentContactIDCSV(sContact: mContacts)
    }
    
    
    @IBAction func addSelectBtnClicked(_ sender: Any) {
       
        if self.selectedCheckRows.count >= self.requestedPaxCount{
            CommonFunction.showToastMesage(msg: "The number of passengers for this trip is \(self.requestedPaxCount!). FriendShare is not allowed.", controller: self, fontSize: 22)
            return
        }
        
        self.totalSplitPax = self.totalExtraPax + self.selectedCheckRows.count
        if self.totalSplitPax >= self.requestedPaxCount{
            CommonFunction.showToastMesage(msg: "The number of passengers for this trip is \(self.requestedPaxCount!). FriendShare is not allowed.", controller: self, fontSize: 22)
            return
        }
        self.addSelected()
    }
    
    @IBAction func createFriendBtnClicked(_ sender: Any) {
        //Add new contacts
        let addVC = AddMyContactsVC.storyboardViewController()
        addVC.isEdit = false
        addVC.delegate = self
        self.navigationController?.pushViewController(addVC, animated: true)
    }
}

extension ManageContactsVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myContcts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.ContactsListCell, for: indexPath) as! ContactsListCell
        
        cell.delegate = self
        let rowData = self.myContcts[indexPath.row]
        cell.configerContactLitCell(indexPath: indexPath, data: rowData)
        
        if rowData.isCharterer == 0{
            
            if self.selectedCheckRows.contains(indexPath.row){
                cell.checkBtn.setImage(UIImage(named: "selected"), for: .normal)
            }else{
                cell.checkBtn.setImage(UIImage(named: "selected_not"), for: .normal)
            }
        }else{
            cell.checkBtn.setImage(UIImage(named: "selected"), for: .normal)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.ContactsHeaderCell) as! ContactsHeaderCell
        let headerView = cell.contentView
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension ManageContactsVC : ContactsListCellDelegate{
    
    func checkBtnPressed(atIndex: Int) {
        let data = myContcts[atIndex]
        if data.isCharterer == 0{
            if self.selectedCheckRows.contains(atIndex){
                self.selectedCheckRows.remove(atIndex)
            }else{
                self.selectedCheckRows.add(atIndex)
            }
            
            //print(self.selectedCheckRows)
            self.contactListTableView.reloadData()
        }
    }
    
    func editBtnPressed(atIndex: Int) {
        let editVC = AddMyContactsVC.storyboardViewController()
        let data = myContcts[atIndex]
        editVC.selectedData = data
        editVC.isEdit = true
        editVC.delegate = self
        //editVC.modalPresentationStyle = .overFullScreen
        //editVC.modalTransitionStyle = .crossDissolve
        //self.present(editVC, animated: true)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}

extension ManageContactsVC : ContactsHeaderCellDelegate{
    
    func addBtnPressed() {
        //Add new contacts
        let addVC = AddMyContactsVC.storyboardViewController()
        addVC.isEdit = false
        addVC.delegate = self
        self.navigationController?.pushViewController(addVC, animated: true)
        
    }
    
    func addSelectedPressed() {
        //add selected contacts
        var mContacts = [SplitContacts]()
        self.splitCharReIDCSV.removeAllObjects()
        if self.selectedCheckRows.count > 0{
            for i in 0...selectedCheckRows.count - 1{
                let index = selectedCheckRows[i] as! Int
                var contact = myContcts[index]
                
                // Search for a dictionary where "id" is 2
                let predicate = NSPredicate(format: "SplitPaymentContactID == %d", contact.splitPaymentContactID!)
                let filteredArray = savedSplitPaymentDetail.filtered(using: predicate)
                
                if filteredArray.count > 0{
                   let data = filteredArray[0] as! [String : Any]
                    print((data["NoOfPassengers"] as! Int))
                    contact.noOfPassenger = (data["NoOfPassengers"] as! Int)
                }else{
                    contact.noOfPassenger = 1
                }
                
                self.splitCharReIDCSV.add(contact.splitPaymentContactID!)
                mContacts.append(contact)
            }
        }
        self.saveChartererSplitPaymentContactIDCSV(sContact: mContacts)
    }
}

extension ManageContactsVC : AddMyContactsVCDelegate{
    
    func didAddedContacts() {
        self.APIGetAllContacts()
    }
}

extension ManageContactsVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onRightButtonClick(sender: NavigationBarView, button: UIButton) {
        let addVC = AddMyContactsVC.storyboardViewController()
        addVC.isEdit = false
        addVC.delegate = self
        addVC.modalPresentationStyle = .overFullScreen
        addVC.modalTransitionStyle = .crossDissolve
        self.present(addVC, animated: true)
    }
}

/*///////////////////////////////////////////////////////////////// */

@objc protocol AddMyContactsVCDelegate{
    
    @objc optional
    func didAddedContacts()
}

class AddMyContactsVC : NavigationBarView,Storyboardable{
    static let storyboardName :StoryBoardName = .ManageContacts

    var delegate:AddMyContactsVCDelegate?
    @IBOutlet weak var fNameLabel:UILabel!
    @IBOutlet weak var lNameLabel:UILabel!
    @IBOutlet weak var mobileLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    
    @IBOutlet weak var fNameTF:UITextField!
    @IBOutlet weak var lNameTF:UITextField!
    @IBOutlet weak var mobileTF:UITextField!
    @IBOutlet weak var emailTF:UITextField!
    @IBOutlet weak var phoneInputView:UIView!
    @IBOutlet weak var numberInputView:UIView!
    @IBOutlet weak var countryCodeButton:UIButton!
    @IBOutlet var AddContactView: UIView!
    @IBOutlet weak var cancelBtn:UIButton!
    @IBOutlet weak var saveBtn:UIButton!
    var selectedData:SplitContacts!
    var splitContactId:Int! = 0
    var requestPaxCount:Int! = 0
    
    var isEdit:Bool! = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setBackButton(viewC: self)
        CommonFunction.setRoundedTextFields(arrayTF: [fNameTF,lNameTF,emailTF], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setRoundedViews(arrayB: [phoneInputView], radius: 0, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        CommonFunction.setTextFieldFontsTypeWithSize(arrayT: [mobileTF], size: 14, type: .fReguler)
        CommonFunction.setRoundedViews(arrayB: [numberInputView], radius: 0, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [countryCodeButton], size: 14, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        self.countryCodeButton.backgroundColor = UIColor.hexStringToUIColor(hex: INPUT_VIEW_BG_COLOR)
        CommonFunction.setTextFieldPlaceHolder(txtF: mobileTF, pholderText: "Enter phone number",size: 12,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        CommonFunction.setRoundedButtons(arrayB: [cancelBtn,saveBtn], radius: 10, borderColorCode: "", borderW: 0, bgColor: blackColorCode, textColor: whiteColorCode)
        //self.AddContactView.layer.borderColor = UIColor.hexStringToUIColor(hex: "ebe5df").cgColor
        //self.AddContactView.layer.borderWidth = 2
        
        if isEdit == true{
            self.setNavigationTitle(title: "Edit Friend")
            self.fNameTF.text = self.selectedData.firstName!
            self.lNameTF.text = self.selectedData.lastName!
            self.mobileTF.text = self.selectedData.mobile!
            self.emailTF.text = self.selectedData.email!
            self.splitContactId = self.selectedData.splitPaymentContactID!
        }else{
            self.setNavigationTitle(title: "Add Friend")
        }
        
        self.mobileTF.delegate = self
    }
    
    @IBAction func countryCodeButtonClicked(_ sender: Any){
        self.view.endEditing(true)
        let flagview = FlagListPopupVC.storyboardViewController()
        //flagview.modalTransitionStyle = .crossDissolve
        flagview.delegate = self
        flagview.modalPresentationStyle = .overFullScreen
        self.present(flagview, animated: true)

    }
    
    @IBAction func cancelBtnClicked(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton){
        
        let fname = self.fNameTF.text?.trimmingCharacters(in: .whitespaces)
        let lname = self.lNameTF.text?.trimmingCharacters(in: .whitespaces)
        let mobile = self.mobileTF.text?.trimmingCharacters(in: .whitespaces)
        let email = self.emailTF.text?.trimmingCharacters(in: .whitespaces)
        
        if fname?.count == 0{
            CommonFunction.showToastMessage(msg: "Please enter first name.", controller: self)
        }else if lname?.count == 0{
            CommonFunction.showToastMessage(msg: "Please enter last name.", controller: self)
        }else if mobile?.count == 0{
            CommonFunction.showToastMessage(msg: "Please enter mobile number.", controller: self)
        }else if email?.count == 0{
            CommonFunction.showToastMessage(msg: "Please enter email address.", controller: self)
        }else{
            if !CommonFunction.isValidEmail(emailadd: email!){
                CommonFunction.showToastMessage(msg: "Please enter valid email address.", controller: self)
                return
            }
            self.APIAddContacts()
        }
    }
    
    func APIAddContacts(){
        self.view.makeToastActivity(.center)
        //finalcode
        let urlStr = String(format: "%@/SplitPaymentContacts/AddEdit", APIUrl.baseUrl)
        
        var userId = 0
        if UserDefaults.standard.value(forKey: "UserLoginUserId") != nil{
            userId = (UserDefaults.standard.value(forKey: "UserLoginUserId") as! Int)
        }
        
        let param = ["SplitPaymentContactID": self.splitContactId!,
                     "UserID": userId,
                     "FirstName":self.fNameTF.text!,
                     "LastName":self.lNameTF.text!,
                     "Email":self.emailTF.text!,
                     "Phone":self.mobileTF.text!,
                     "IsCharterer": 0,
                     "Billingcompany": "",
                     "Billingaddress1": "",
                     "Billingaddress2": "",
                     "Billingcity": "",
                     "Billingstate": "",
                     "Billingcountry": "",
                     "Billingzip": ""] as! [String:Any]
        
        APISplitContacts.shared.addContact(urlStr: urlStr, param: param) { response in
            self.view.hideToastActivity()
            if response.result != nil{
                
                if response.result == "success"{
                    self.delegate?.didAddedContacts?()
                    self.navigationController?.popViewController(animated: true)
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
}

extension AddMyContactsVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddMyContactsVC : FlagListPopupVCDelegate {
    
    func didSelectedCountry(atIndex: Int, data: CountryData) {
        let imageView = UIImageView()
        let url = String(format: "%@%@",APPUrls.imageBaseUrl,data.flag!)
        imageView.loadImageUsingCache(withUrl:url)
        self.countryCodeButton.setImage(imageView.image, for: .normal)
        print(data.dialCode!)
        self.countryCodeButton.setTitle(data.dialCode!, for: .normal)
    }
}

extension AddMyContactsVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        if textField == self.mobileTF {
//            // Allow only alphanumeric characters
//            let allowedCharacterSet = CharacterSet.decimalDigits
//            let isNumeric = string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
//            
//            // Ensure the replacement string is alphanumeric
//            if !isNumeric {
//                return false
//            }

            // Attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // Add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // Ensure the result is under 16 characters
            return updatedText.count <= 15
        } else {
            return true
        }
    }

}

