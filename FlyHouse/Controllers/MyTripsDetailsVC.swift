//
//  MyTripsDetailsVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 05/05/24.
//

import UIKit

class MyTripsDetailsVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .MyTrips

    @IBOutlet weak var myTripDetailsTableView:UITableView!
    var myTripData:MyTripData!
    var paymentDetail:PaymentData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setNavigationTitle(title: "Trip Details")
        super.setBackButton(viewC: self)
        super.delegateNav = self
        // Do any additional setup after loading the view
        
        myTripDetailsTableView.register(UINib(nibName: TableCells.HeaderImageCell, bundle: nil), forCellReuseIdentifier: TableCells.HeaderImageCell)
        
        myTripDetailsTableView.register(UINib(nibName: TableCells.MyTripDetailCell, bundle: nil), forCellReuseIdentifier: TableCells.MyTripDetailCell)
       
        myTripDetailsTableView.delegate = self
        myTripDetailsTableView.dataSource = self
        myTripDetailsTableView.reloadData()
    }
    
}

extension MyTripsDetailsVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyTripsDetailsVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // detail
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.MyTripDetailCell, for: indexPath) as! MyTripDetailCell
            
        cell.confugurationPaymentDetailCell(indexPath: indexPath, data: self.paymentDetail,tripData: self.myTripData)
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

