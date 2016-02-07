//
//  InitialViewController.swift
//  MapView
//
//  Created by Swasidhant Chowdhury on 07/02/16.
//  Copyright © 2016 Archita Bansal. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var cardViews:[CardView]=[]
    var cardViewSmallFrames:[CGRect]=[]
    var cardViewLargeFrames:[CGRect]=[]
    
    var overlayView:OverlayView!
    
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var imgViewMessage: UIImageView!
    
    @IBOutlet weak var txtFieldDestination: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnGo.layer.cornerRadius = 25
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: Selector("viewTapped:"))
        self.view.gestureRecognizers=[gestureRecogniser]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        showLowerCards()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewTapped(gesture:UIGestureRecognizer){
        self.txtFieldDestination.resignFirstResponder()
    }
    
    //MARK:-cardView code 
    
    func showLowerCards(){
        self.removeOverlay()
        let totalHeight = self.view.frame.height-(self.imgViewMessage.frame.height + self.imgViewMessage.frame.origin.y) - 20
        let heightOfEachCard = totalHeight/2
        
        for index in 0..<1{
            let cardView = NSBundle.mainBundle().loadNibNamed("CardView", owner: self, options: nil)[0] as! CardView
            
            cardView.lblTitle.text = "Preferences"
            
            let gestureRecogniser = UITapGestureRecognizer(target: self, action: Selector("showCard:"))
            cardView.gestureRecognizers=[gestureRecogniser]
            cardView.state = "small"
            self.cardViews.append(cardView)
            //assign colors
            //if index==0{
                cardView.backgroundColor = UIColor.orangeColor()
//            }
//            else{
//                cardView.backgroundColor = UIColor.lightGrayColor()
//            }
            
            cardView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: heightOfEachCard)
            cardView.layer.cornerRadius = 10.0
            self.view.addSubview(cardView)
            UIView.beginAnimations("CardViewComingUp", context: nil)
            UIView.setAnimationDuration(0.3 * Double(index+1))
            
            let cardViewYPosition = self.view.frame.height-(CGFloat(index+1)*heightOfEachCard)+CGFloat(index*20) + 10
            cardView.frame = CGRect(x: 0, y:cardViewYPosition , width: self.view.frame.width, height: totalHeight)
            self.cardViewSmallFrames.append(cardView.frame)
            
            UIView.commitAnimations()
        }
        //self.view.bringSubviewToFront(self.frontCardView)
    }
    
    
    func showCard(gesture:UIGestureRecognizer){
        
        let sendingView = gesture.view
        let sendingCardView = sendingView as! CardView
        if sendingCardView.state == "small"{
            self.addOverlay()
            
            let sendingViewWidth = self.view.frame.width * 0.8
            let sendingViewHeight = self.view.frame.height * 0.8
            let properIndexOfsendingView = self.findProperIndexOfView(sendingCardView)
            UIView.beginAnimations("cardViewFullSize", context: nil)
            UIView.setAnimationDuration(0.3)
            
//            if properIndexOfsendingView == 1{
//                sendingCardView.frame = CGRect(x: self.view.frame.width/2-sendingViewWidth/2, y: self.view.frame.height/2 - sendingViewHeight/2, width: sendingViewWidth, height: sendingViewWidth)
//                sendingCardView.state = "large"
//                
//                sendingCardView.layer.cornerRadius = sendingCardView.frame.width/2
//            }
//            else{
                sendingCardView.frame = CGRect(x: self.view.frame.width/2-sendingViewWidth/2 + 10, y: self.view.frame.height/2 - sendingViewHeight/2, width: sendingViewWidth, height: sendingViewHeight-10)
                sendingCardView.state = "large"
           // }
            
            UIView.commitAnimations()
        }
        else{
            //self.overlayView.backgroundColor = UIColor.clearColor()
            self.removeOverlay()
            let properIndexOfsendingView = self.findProperIndexOfView(sendingCardView)
            let smallFrame = self.cardViewSmallFrames[properIndexOfsendingView!]
            
            UIView.animateWithDuration(0.3, animations: {
                sendingCardView.state = "small"
                sendingCardView.frame = CGRect(x: sendingCardView.frame.origin.x, y: smallFrame.origin.y, width: sendingCardView.frame.width, height: smallFrame.height)
                sendingCardView.layer.cornerRadius = 10.0
                
                }, completion: {(finished:Bool) in
                    UIView.animateWithDuration(0.3, animations: {
                        sendingCardView.frame = smallFrame
                    })
            })
        }
    }
    
    func addOverlay(){
        self.overlayView = OverlayView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height))
        self.overlayView.backgroundColor=UIColor.clearColor()
        self.view.bringSubviewToFront(self.btnGo)
        self.view.addSubview(self.overlayView)
        //self.view.bringSubviewToFront(cardViews[1])
        self.view.bringSubviewToFront(cardViews[0])
        self.overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    }
    
    func removeOverlay(){
        if self.overlayView != nil{
            self.overlayView.removeFromSuperview()
            self.overlayView=nil
        }
    }
    
    func findProperIndexOfView(cardView:CardView)->Int?{
        for index in 0...self.cardViews.count-1{
            if self.cardViews[index] == cardView{
                return index
            }
        }
        return nil
    }


    @IBAction func goButtonPressed(sender: UIButton) {
        var latitude:Double!
        var longitude:Double!
         let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapScene") as! ViewController
        self.navigationController?.pushViewController(mapViewController, animated: true)
//        if self.txtFieldDestination.text != ""{
//            MapService.geocodeAddress(self.txtFieldDestination.text){latLong in
//                latitude=latLong.0
//                longitude=latLong.1
//                dispatch_async(dispatch_get_main_queue(), {
//                    let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapScene") as! ViewController
//                    
//                    mapViewController.destinationLatitude=latitude
//                    mapViewController.destinationLongitude=longitude
//                    self.navigationController?.pushViewController(mapViewController, animated: true)
//                })
//                
//            }
//        }
        
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as! SettingsTableViewCell
        return cell
    }
}
