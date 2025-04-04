//
//  LeftMenuViewController.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class LeftMenuViewController: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Main
    
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var title1:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var appVersionString:UILabel!
    var menuSelectedVC:UIViewController!
    @IBOutlet weak var menuTable:UITableView!
    var menuOption = ["Past Requests",
                      "My Trips",
                      "Contact Us",
                      "House Hours",
                      "Logout"]

    var mainViewController: UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.showNavLogoImage()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.backgroundColor = UIColor.lightText
        
        self.title1.text = CommonFunction.getTitles()
        menuTable.delegate = self
        menuTable.dataSource = self
        menuTable.backgroundColor = UIColor.clear
        menuTable.register(UINib(nibName: TableCells.SingleStringCell, bundle: nil), forCellReuseIdentifier: TableCells.SingleStringCell)
        self.appVersionString.text = String(format: "Version: %@(%@)", UIApplication.getVersion,UIApplication.getBuildVersion)
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (UserDefaults.standard.value(forKey: "UserLoginDisplayName") != nil) {
            self.nameLabel.text = (UserDefaults.standard.value(forKey: "UserLoginDisplayName") as! String)
        }
        
    }

    @IBAction func profileBtnClicked(_ sender: UIButton){
        
        //slideMenuController()?.closeLeft()
        //self.menuSelectedVC = ProfileVC.storyboardViewController()
        //self.menuSelectedVC = UINavigationController(rootViewController: self.menuSelectedVC)
        //self.slideMenuController()?.changeMainViewController(self.menuSelectedVC, close: true)
    }
}

extension LeftMenuViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.SingleStringCell, for: indexPath) as! SingleStringCell
        
        cell.hideImage()
        cell.titleLabel.text = menuOption[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //slideMenuController()?.closeLeft()
        if indexPath.row == 0{
            APP_DELEGATE.setMyTripTabWithIndex(atIndex: 1,optionIndex: 1)
        }
        else if indexPath.row == 1{
            APP_DELEGATE.setMyTripTabWithIndex(atIndex: 1,optionIndex: 0)
        }else if indexPath.row == 2{
            CommonFunction.showAlertMessage(aStrTitle: "Contact Us", aStrMessage: "Hello! If you need help or can't find something, please email us at booking@goflyhouse.com or call 888-413-8480", aViewController: self) { OkAction in
            
            }
        }else if indexPath.row == 3{
            let houseHoursVC = HouseHours.storyboardViewController()
            self.navigationController?.pushViewController(houseHoursVC, animated: true)
            
        }else if indexPath.row == 4{
            CommonFunction.showAlertMessageWithTitle(aStrTitle: "Logout", aStrMessage: "Are you sure you want to logout?", Oktitle: "Yes", CancelTitle: "No", aViewController: self, CancelActionTap: { (cancelAct) in
                //
            }) { (okAct) in
                
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                APP_DELEGATE.setMainController()
                
                //let mainVC = IntroductionVC.storyboardViewController()
                //let menuSelectedVC = UINavigationController(rootViewController: mainVC)
                //self.slideMenuController()?.changeMainViewController(menuSelectedVC, close: true)
                
            }
        }
        
//        if indexPath.row != 6 && indexPath.row != 7{//7
//            menuSelectedVC = UINavigationController(rootViewController: menuSelectedVC)
//            self.slideMenuController()?.changeMainViewController(menuSelectedVC, close: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
}
