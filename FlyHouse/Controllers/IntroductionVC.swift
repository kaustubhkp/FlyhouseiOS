//
//  IntroductionVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit
import AVKit
import AVFoundation

class IntroductionVC: UIViewController,Storyboardable {
    static let storyboardName :StoryBoardName = .Main
    
    @IBOutlet weak var copyrightLabel:UILabel!
    @IBOutlet weak var loginBtn:UIButton!
    @IBOutlet weak var loginEmailBtn:UIButton!
    @IBOutlet weak var registerNewBtn:UIButton!
    @IBOutlet weak var arrowImage:UIImageView!
    @IBOutlet weak var arrowEmailImage:UIImageView!
    
    @IBOutlet var buttonArr:[UIButton]!
    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        // Do any additional setup after loading the view.
        
        
//        let arrowimage = UIImage(named: "right_arrow")?.withRenderingMode(.alwaysTemplate)
//        self.arrowImage.tintColor = UIColor.black
//        self.arrowImage.image = arrowimage
//        self.arrowEmailImage.tintColor = UIColor.black
//        self.arrowEmailImage.image = arrowimage
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeVideoBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupVideoBackground()
        self.setupViewsControl()
        self.APIGetAllUrls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func setupVideoBackground() {
        // Get the path to the .mov file (make sure the file is included in the project)
        if let filePath = Bundle.main.path(forResource: "INTRO_FLYHOUSE", ofType: "mov") {
            let fileURL = URL(fileURLWithPath: filePath)
            
            // Create an AVPlayer with the file URL
            player = AVPlayer(url: fileURL)
            
            // Create an AVPlayerLayer to display the video
            playerLayer = AVPlayerLayer(player: player)
            
            // Create AVPlayerLayer to display the video
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = .resizeAspectFill  // Adjust video fill mode
            self.view.layer.insertSublayer(playerLayer, at: 0)
            
            // Add the player layer to the view's layer
            //self.view.layer.insertSublayer(playerLayer, at: 0)
            // Add observer to loop video when it finishes
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            
            // Play the video
            player.play()
        } else {
            print("Video file not found")
        }
    }
    
    @objc func playerDidFinishPlaying(notification: Notification) {
            // When the video finishes, seek to the beginning and play again
            player.seek(to: CMTime.zero)
            player.play()
    }

    deinit {
            // Remove the observer when the view controller is deallocated
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    func removeVideoBackground() {
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    func setupViewsControl(){
        
        CommonFunction.setRoundedButtons(arrayB: [loginBtn,loginEmailBtn], radius: self.loginBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: blackColorCode)
        
        CommonFunction.setRoundedButtons(arrayB: [loginEmailBtn], radius: self.loginEmailBtn.frame.size.height/2, borderColorCode: whiteColorCode, borderW: 1, bgColor: "", textColor: whiteColorCode)
        
        loginBtn.setTitle("Login with Phone", for: .normal)
        loginEmailBtn.setTitle("Continue", for: .normal)
        registerNewBtn.setTitle("Create account", for: .normal)
        
        //loginBtn.titleLabel?.font = UIFont.BoldWithSize(size: 18)
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [loginBtn], size: 11, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [loginEmailBtn,registerNewBtn], size: 11, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: whiteColorCode))
        
    }
    
    func setSelectedButton(sender:UIButton){
        
        for btn in buttonArr{
            btn.layer.borderColor = UIColor.hexStringToUIColor(hex: whiteColorCode).cgColor
            btn.layer.borderWidth = 0
        }
        sender.layer.borderWidth = 2
    }
    
    func APIGetAllUrls(){
        
        let urlStr = String(format: "%@/UserDevice/GetAllAppUrls", APIUrl.baseUrl)
        
        APILogin.shared.getAppAllUrls(urlStr: urlStr) { response in
            //
            if response.result == "success"{
                if response.data != nil{
                    let resultData = response.data!
                    CommonFunction.setAPIUrlsSettingsAndVersion(data: resultData)
                }
            }
            
        } fail: { error in
            print("Error:\(error.localizedDescription)")
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton){
        
        self.setSelectedButton(sender: sender)
        let loginVC = LoginVC.storyboardViewController()
        loginVC.loginWithPhone = true
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    @IBAction func emailButtonClicked(_ sender: UIButton){
        
        self.setSelectedButton(sender: sender)
        let loginVC = LoginVC.storyboardViewController()
        loginVC.loginWithPhone = false
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    @IBAction func registerNewBtnClicked(_ sender : UIButton){
        let registration = RegisterVC.storyboardViewController()
        self.navigationController?.pushViewController(registration, animated: true)
    }

}
