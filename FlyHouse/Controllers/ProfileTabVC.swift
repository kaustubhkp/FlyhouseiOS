//
//  ProfileTabVC.swift
//  FlyHouse
//
//  Created by Atul on 21/01/25.
//

import UIKit
import Foundation

class ProfileTabVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Home
    
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var title1:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var appVersionString:UILabel!
    @IBOutlet weak var profileListTable:UITableView!
    var profileList = ["Personal Information",
                      "Privacy Center"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.setNavigationTitle(title: "Profile")
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.backgroundColor = UIColor.lightText
        
        self.title1.text = CommonFunction.getTitles()
        profileListTable.delegate = self
        profileListTable.dataSource = self
        profileListTable.backgroundColor = UIColor.clear
        profileListTable.register(UINib(nibName: TableCells.SingleStringCell, bundle: nil), forCellReuseIdentifier: TableCells.SingleStringCell)
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (UserDefaults.standard.value(forKey: "UserLoginDisplayName") != nil) {
            self.nameLabel.text = (UserDefaults.standard.value(forKey: "UserLoginDisplayName") as! String)
        }
        
    }
    
    
}

extension ProfileTabVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.SingleStringCell, for: indexPath) as! SingleStringCell
        
        cell.hideImage()
        cell.accessoryType = .disclosureIndicator
        cell.titleLabel.text = profileList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0{
            let profileVC = ProfileVC.storyboardViewController()
            profileVC.titleStr = self.profileList[indexPath.row]
            self.navigationController?.pushViewController(profileVC, animated: true)
        }else{
            let pVC = PrivacyVC.storyboardViewController()
            pVC.titleStr = self.profileList[indexPath.row]
            self.navigationController?.pushViewController(pVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
}
