//
//  SideViewController.swift
//  Slidebar
//
//  Created by Archita Bansal on 30/11/15.
//  Copyright © 2015 Archita Bansal. All rights reserved.
//

import UIKit

protocol SideBarDelegate{
    
    func sidebarDidSelectRow(sendingString:String)
    
}

class SideViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var sidebarTableview: UITableView!
    var tableData = Array<String>()
    var delegate : SideBarDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarTableview.backgroundColor = UIColor.clearColor()
        self.tableData = ["Food","Temple","ATM","Tourist Spots","Gas Stations"]
        self.sidebarTableview.separatorStyle = UITableViewCellSeparatorStyle.None
        self.sidebarTableview.dataSource = self
        self.sidebarTableview.delegate = self
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.text = tableData[indexPath.row]
        
        let selectedView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        selectedView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sendingString = (tableView.cellForRowAtIndexPath(indexPath)!).textLabel?.text
        
        self.delegate?.sidebarDidSelectRow(sendingString!)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
