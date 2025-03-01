//
//  NavigationBarView.swift
//
//  Created on 11/08/21.

import UIKit


@objc protocol NavigationBarViewDelegate{
    @objc optional
    func onBackButtonClick(sender: NavigationBarView)
    
    @objc optional
    func onRightButtonClick(sender: NavigationBarView,button:UIButton)
    
    @objc optional func changeViewController(sender:NavigationBarView,controller:UIViewController)
    
}

class NavigationBarView: UIViewController {

    @IBOutlet var navBarView: NavigationView!
    @IBOutlet weak var titleNav:UILabel!
    @IBOutlet weak var navLogoImageView:UIImageView!
    @IBOutlet weak var menuButton:UIButton!
    @IBOutlet weak var backButton:UIButton!
    @IBOutlet weak var rightButton:UIButton!
    
    @IBOutlet var arrayLeftButtons:[UIButton]!
    @IBOutlet var arrayRightButtons:[UIButton]!
    @IBOutlet var navTitleLeadingConst:NSLayoutConstraint!
    @IBOutlet var navTitleTrailingConst:NSLayoutConstraint!
    
    
    var delegateNav:NavigationBarViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.navBarView == nil
        {
            let nibView = Bundle.main.loadNibNamed("NavigationBarView", owner: self, options: nil)! as [Any]
            let height = self.navigationController?.navigationBar.frame.size.height
            let width = UIScreen.main.bounds.size.width
            self.navBarView = nibView[0] as? NavigationView
            self.navBarView.frame =  CGRect(x: 0, y: 0, width:width , height: height!)
            self.navBarView.backgroundColor = UIColor.hexStringToUIColor(hex: navigationBarColor)
            self.navigationItem.setHidesBackButton(true, animated:true);
            self.navigationItem.titleView = self.navBarView
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: navigationBarColor)
            let image = UIImage(named: "menuIcon")?.withRenderingMode(.alwaysTemplate)
            self.menuButton.setImage(image, for: .normal)
            self.menuButton.tintColor = UIColor.hexStringToUIColor(hex: whiteColorCode)
            self.setNavigationTitleAlignment(align: "center")
            self.setNavigationTitle(title: "")
           // self.navigationSetting(UIColor.hexStringToUIColor(hex: navigationBarColor))
            self.menuButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func showNavLogoImage(){
        self.navLogoImageView.isHidden = false
    }
    
    func hideNavLogoImage(){
        self.navLogoImageView.isHidden = true
    }
    
    func navigationSetting(_ bgcolor:UIColor){
        
        // Make the navigation bar's title with red text.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bgcolor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // With a red background, make the title more readable.
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.compactAppearance = appearance // For iPhone small navigation bar in landscape.
    }
    
    @IBAction func menuRightButtonClick(){
        slideMenuController()?.openLeft()
    }
    
    func setBackButton(viewC:UIViewController){
        
        self.menuButton.isHidden = true
        self.delegateNav = (viewC as! any NavigationBarViewDelegate)
        let backImage = UIImage(named: "backIcon")?.withRenderingMode(.alwaysTemplate)
        backButton.tintColor = UIColor.black
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        backButton.isUserInteractionEnabled = true
        backButton.isHidden = false
    }
    
    @objc func backButtonClicked(){
        self.delegateNav?.onBackButtonClick!(sender: self)
    }
    
    func setRightButton(viewC:UIViewController,imageName:String,title:String){
        
        let backImage = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        rightButton.tintColor = UIColor.black
        rightButton.setTitle(title, for: .normal)
        rightButton.titleLabel?.font = UIFont.RegularWithSize(size: 10)
        rightButton.setImage(backImage, for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonClicked(sender:)), for: .touchUpInside)
        rightButton.isUserInteractionEnabled = true
        rightButton.isHidden = false
        
    }
    
    @objc func rightButtonClicked(sender:UIButton){
        self.delegateNav?.onRightButtonClick!(sender: self,button:sender)
    }

    
    func setNavigationBarColor(color:UIColor){
        self.navBarView.backgroundColor = color
        
    }
    
    func setNavigationTitleAlignment(align:String){
        self.titleNav.textColor = UIColor.black
        if(align == "left"){
            self.titleNav.textAlignment = NSTextAlignment.left
        }else{
            self.titleNav.textAlignment = NSTextAlignment.center
        }
    }
    
    func setNavigationTitle(title:String){
        self.hideNavLogoImage()
        self.titleNav.text = title
        //self.titleNav.backgroundColor = UIColor.red
        self.titleNav.font = UIFont.RegularWithSize(size: 11)
        self.titleNav.textColor = UIColor.hexStringToUIColor(hex: blackColorCode)
        self.titleNav.isHidden = false
    }
}
