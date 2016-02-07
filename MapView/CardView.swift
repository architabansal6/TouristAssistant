//
//  CardView.swift
//  Places
//
//  Created by Swasidhant Chowdhury on 03/02/16.
//  Copyright © 2016 Random. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var state:String!

    @IBOutlet weak var switchAnotherOption: UISwitch!
    @IBOutlet weak var txtFieldCarType: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func donePressed(sender: UIButton) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if self.txtFieldCarType.text != ""{
        userDefaults.setValue(self.txtFieldCarType.text, forKey: "carType")
        }
    }
}
