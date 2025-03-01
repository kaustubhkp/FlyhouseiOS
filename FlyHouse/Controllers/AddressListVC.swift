//
//  AddressListVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

protocol AirportListDelegate {
    func didSelectedAirport(data:AirportData,optionIndex:Int,atIndex:Int)
}

class AddressListVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .AddressList

    var delegate:AirportListDelegate?
    var optionIndex:Int! = 0
    @IBOutlet weak var addressTableView:UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var airPortsArr = [AirportData]()
    var filteredArr = [AirportData]()
    var isSearch:Bool! = false
    var selectAddAtIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setBackButton(viewC: self)
        // Do any additional setup after loading the view.
//        if self.optionIndex == 0{
//            self.setNavigationTitle(title: "From Address")
//        }else{
//            self.setNavigationTitle(title: "To Address")
//        }
        self.setNavigationTitle(title: "Search")
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        let textField = self.searchBar.getTextField()
        let glassIconView = textField?.leftView as? UIImageView
        glassIconView!.tintColor = .black
        searchBar.setTextColor(UIColor.black)
        searchBar.searchTextField.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "City or Airport", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])

        //searchBar.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        addressTableView.delegate = self
        addressTableView.dataSource = self
        addressTableView.register(UINib(nibName: TableCells.AddressListCell, bundle: nil), forCellReuseIdentifier: TableCells.AddressListCell)
        //self.getAirports()
        
        self.searchBar.becomeFirstResponder()
    }
    
    func getSearchAirports(string:String){
        self.view.makeToastActivity(.center)
        
        //finalcode
        let urlStr = String(format: "%@/AirPort/SearchAirports?prefix=%@", APIUrl.baseUrl,string)
        
        let urlEnc = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        APIHome.shared.getAirports(urlStr: urlEnc!) { response in
            self.view.hideToastActivity()
            if response.result?.lowercased() == "success"{
                if response.data != nil{
                    self.airPortsArr = response.data!
                    
                    DispatchQueue.main.async {
                        self.addressTableView.reloadData()
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
            if error.code == -1009{
                            
                CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                            }
            }
        }
    }
    
}

extension AddressListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isSearch == true{
            return self.filteredArr.count
        }else{
            return self.airPortsArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.AddressListCell, for: indexPath) as! AddressListCell
        
        var rowData = self.airPortsArr[indexPath.row]
        if self.isSearch == true{
            rowData = self.filteredArr[indexPath.row]
        }
        cell.configuerAirportsCell(indexPath: indexPath, data: rowData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if self.isSearch == true{
            let rowData = self.filteredArr[indexPath.row]
            self.delegate?.didSelectedAirport(data: rowData,optionIndex: self.optionIndex,atIndex: self.selectAddAtIndex)
        }else{
            let rowData = self.airPortsArr[indexPath.row]
            self.delegate?.didSelectedAirport(data: rowData,optionIndex: self.optionIndex,atIndex: self.selectAddAtIndex)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
}

extension AddressListVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddressListVC : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print(searchText)
        
        /*if searchText != ""{
            self.isSearch = true
            self.filteredArr = self.airPortsArr.filter({ value -> Bool in
                guard let text =  searchBar.text else { return false}
                return value.code!.contains(text) // According to title from JSON
            })
            
        }else{
            self.isSearch = false
            self.filteredArr.removeAll()
        }
         self.addressTableView.reloadData()
         */
        
        if searchText.count >= 2{
            let searchString = searchText.trimmingCharacters(in: .whitespaces)
            self.getSearchAirports(string: searchString)
        }else{
            self.airPortsArr.removeAll()
            self.addressTableView.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if searchBar.text != ""{
            let searchString = searchBar.text!.trimmingCharacters(in: .whitespaces)
            self.getSearchAirports(string: searchString)
        }else{
            self.airPortsArr.removeAll()
            self.addressTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}


extension UISearchBar {
    func getTextField() -> UITextField? {
        return self.value(forKey: "searchField") as? UITextField
    }

    func setTextColor(_ color: UIColor) {
        let textField = getTextField()
        textField?.textColor = color
    }
}
