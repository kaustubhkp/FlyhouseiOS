//
//  CurrentRequestVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class CurrentRequestVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .CurrentRequest

    var titleStr:String! = ""
    @IBOutlet weak var currReqTableView:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setNavigationTitle(title: titleStr)
        currReqTableView.delegate = self
        currReqTableView.dataSource = self
        //currReqTableView.register(UINib(nibName: TableCells.HeaderImageCell, bundle: nil), forCellReuseIdentifier: TableCells.HeaderImageCell)
        currReqTableView.register(UINib(nibName: TableCells.ContactsHeaderCell, bundle: nil), forCellReuseIdentifier: TableCells.ContactsHeaderCell)
        
        currReqTableView.register(UINib(nibName: TableCells.CreateNewViewTblCell, bundle: nil), forCellReuseIdentifier: TableCells.CreateNewViewTblCell)
        // Do any additional setup after loading the view.
    
        currReqTableView.reloadData()
        
    }
    
    @objc func createNew(_ sender:UIButton){
        APP_DELEGATE.setHomeToRootViewController()
    }
    
}

extension CurrentRequestVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.CreateNewViewTblCell, for: indexPath) as! CreateNewViewTblCell
            
        cell.createNewBtn.addTarget(self, action: #selector(createNew), for: .touchUpInside)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
