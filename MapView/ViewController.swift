//
//  ViewController.swift
//  MapView
//
//  Created by Archita Bansal on 18/12/15.
//  Copyright © 2015 Archita Bansal. All rights reserved.
//

import UIKit
import MapKit

import AVFoundation

class ViewController: UIViewController,MKMapViewDelegate,SideBarDelegate,CLLocationManagerDelegate {
    
    var sidebarShouldOpen : Bool = true
    var animator : UIDynamicAnimator!
    var menuVC : SideViewController!
    var barWidth : CGFloat!
    var mapResults:NSArray!
    var newArray:NSMutableArray=[]
    var mileage : Double = 24
    var tankCapacity : Double = 42
    var timeInterval : Double!
    var expDistance : Double!
    var isRemindMeLater = false
    var isNotified : Bool = true
    var isFirst : Bool = true
    var destinationLatitude:Double!
    var destinationLongitude:Double!
    
    

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager:CLLocationManager = CLLocationManager()
    let googleAPIKey = "AIzaSyC2NA5Fv4rlJCvA15ANG3ysse4Wlt5yy_k"//"AIzaSyCkXIX_OlhHIlPpdyzNsprcEkyh4Y1Co04"
    var currentCentre : CLLocationCoordinate2D! = CLLocationCoordinate2DMake(12.9500, 77.5900){
        willSet{
            print("willset \(currentCentre)")
        }
        didSet{
            print("didset \(currentCentre)")
           
                let diffDist: CLLocationDistance = CLLocation(latitude: oldValue.longitude, longitude: oldValue.latitude).distanceFromLocation(CLLocation(latitude: currentCentre.longitude, longitude: currentCentre.latitude))
            
            if diffDist > 600.0{
                if self.isTA{
                    self.fetchTouristPlaces("bang")
                }
                else{
                    self.searchGooglePlaces(AppSettings.sharedInstance.type)
                }
                
            }
           
        }
        
        
    }
    var currentDist : CLLocationDistance!
    
    var isSetRegion = false
    var isTA = false
    //var polarityAverageArray:[Float]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        createToolbarView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        self.locationManager.startUpdatingLocation()
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        self.addCustomSideBar()
        self.addNotification()
    }
    
    
    func addCustomSideBar(){
        addLeftNavbarButton()
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
        
        
        barWidth = UIScreen.mainScreen().bounds.size.width - (UIScreen.mainScreen().bounds.size.width/2)
        
        
        menuVC = self.storyboard!.instantiateViewControllerWithIdentifier("SlidebarMenuViewController") as! SideViewController
        menuVC.delegate = self
        menuVC.view.backgroundColor = UIColor.clearColor()
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = menuVC.view.bounds
        menuVC.view.addSubview(blurView)
        menuVC.view.bringSubviewToFront(menuVC.sidebarTableview)
        
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        //menuVC.view.layoutIfNeeded()
        
        self.view.bringSubviewToFront(self.menuVC.view)
        menuVC.view.frame=CGRectMake(-barWidth + 5, (self.navigationController?.navigationBar.frame.height)! + 20, barWidth, UIScreen.mainScreen().bounds.size.height);
        
        blurView.frame = menuVC.view.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getDistance:"), name:"getDistanceView", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("showAlert:"), name:"alertView", object: nil);
        
        let location = CLLocationCoordinate2DMake(12.9500, 77.5900)
        
        let span = MKCoordinateSpanMake(0.15, 0.15)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        var coordinateDestination=CLLocationCoordinate2D()
//        coordinateDestination.latitude=self.destinationLatitude;
//        coordinateDestination.longitude=self.destinationLongitude;
//        var annotation = CustomAnnotation(name: "Destination", address: "my destination", coordinates: coordinateDestination)
//        
//        annotation.coordinate = coordinateDestination;
//        self.mapView.addAnnotation(annotation)
//    }
    
    /*func createToolbarView(){
        
        let optionsButtonView = UIToolbar(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 44))
        optionsButtonView.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let  foodButton = UIBarButtonItem(title: "FOOD", style: UIBarButtonItemStyle.Done, target: self, action: Selector("optionChoosed:"))
        foodButton.tag = 1
        
        let  templeButton = UIBarButtonItem(title: "TEMPLE", style: UIBarButtonItemStyle.Done, target: self, action: Selector("optionChoosed:"))
        templeButton.tag = 2
        
        let  atmButton = UIBarButtonItem(title: "ATM", style: UIBarButtonItemStyle.Done, target: self, action: Selector("optionChoosed:"))
        atmButton.tag = 3
        
        let  tourAttButton = UIBarButtonItem(title: "TouristAttraction", style: UIBarButtonItemStyle.Done, target: self, action: Selector("optionChoosed:"))
        tourAttButton.tag = 4

        
      //  foodButton.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], forState: UIControlState.Normal)
        
        let toolbarItems = [flexSpace,tourAttButton,atmButton,templeButton,foodButton]
        optionsButtonView.setItems(toolbarItems, animated: false)
        self.view.addSubview(optionsButtonView)
        
    }*/
    
    func showAlert(sender:NSNotificationCenter){
        
        var showAlert = UIAlertController(title: "Hungry?", message: "Yummy food is waiting for you", preferredStyle: UIAlertControllerStyle.Alert)
        
        showAlert.addAction(UIAlertAction(title: "Remind Later", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.isRemindMeLater = true
            self.sendNotification("you might be hungry!Find food near you!", timeInterval: self.calFoodNeed(), isRepeat: false, title: "food")
            
        }))
        
        showAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
            showAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.isRemindMeLater = false
            })
        }))
        
        self.presentViewController(showAlert, animated: true, completion: nil)
        
    }
    
    func optionChoosed(sendingText:String ){
        
        switch(sendingText){
        case "Food":
                AppSettings.sharedInstance.type = "restaurant"
        case "Temple":
                AppSettings.sharedInstance.type = "hindu_temple"
        case "ATM":
                AppSettings.sharedInstance.type = "atm"
        case "Gas Stations":
                AppSettings.sharedInstance.type = "gas_station"
        case "Tourist Spots":
            self.isTA = true
            self.fetchTouristPlaces("bang")
            return

        default:
                break
        }
        
        self.searchGooglePlaces(AppSettings.sharedInstance.type)
        self.isTA = false
        
    }
    
    func searchGooglePlaces(type:String){
        let url = "https://maps.googleapis.com/maps/api/place/search/json?location=\(self.currentCentre.latitude),\(self.currentCentre.longitude)&radius=1500&types=\(type)&sensor=true&key=\(self.googleAPIKey)"
       // let url = "https://maps.googleapis.com/maps/api/place/search/json?location=-33.8670522,151.1957362&radius=500&types=food&sensor=true&key=\(self.googleAPIKey)"
        
        let urlStr : NSString = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!//url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        let requestUrl = NSURL(string: urlStr as String)

        dispatch_async(dispatch_get_main_queue(), {
            
            let data : NSData = NSData(contentsOfURL: requestUrl!)!
            //var error : NSError!
            var json : NSDictionary = NSDictionary()
            do{
                json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
                print(json)
            }
            catch{
                
            }
            self.mapResults  = json.valueForKey("results")! as! NSArray
                        self.plotPositions()
        
            //NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("plotPositions"), userInfo: nil, repeats: false)
        })
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("plotPositions"), userInfo: nil, repeats: false)
        
    }
    
    
    func fetchTouristPlaces(city : String){
        
        let url = "http://tourist-attraction.mangalmp.com/api/places/bang"
        
        let urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let requestUrl = NSURL(string: urlStr as String)
        let request = NSMutableURLRequest(URL: requestUrl!)// Creating Http Request
        request.HTTPMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Creating NSOperationQueue to which the handler block is dispatched when the request completes or failed
        let queue: NSOperationQueue = NSOperationQueue()
        
        // Sending Asynchronous request using NSURLConnection
        
       
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response : NSURLResponse?, responseData:NSData?, error:NSError?) -> Void in
            if error != nil
            {
                print(error!.description)
//                self.removeActivityIndicator()
            }
            else
            {
                //var json : NSArray = NSArray()
                do{
                     let res = response as! NSHTTPURLResponse!
                    print("response is \(res)")
                     let jsonString = try NSString(data: responseData!, encoding: NSUTF8StringEncoding)
                     print("response is \(jsonString)")
                     let json = try NSJSONSerialization.JSONObjectWithData(responseData!, options: [.AllowFragments,.MutableContainers]) as? NSArray
                   
                    print(json)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.plotTouristSpots(json!)

                    })
                }
                catch{
                    
                }
               
            }
        }
        
        
      
        
    }
    
    func plotTouristSpots(data:NSArray){
        var arrayForPolarity:[String]=[]
        for annotation in self.mapView.annotations{
            
            if annotation.isKindOfClass(CustomAnnotation){
                self.mapView.removeAnnotation(annotation)
            }
        }

        for(var i=0;i<data.count;i++){
            let place : NSDictionary = data[i] as! NSDictionary
            let name : String = place.valueForKey("name") as! String
            
            arrayForPolarity.append(name)
            
            var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let latString = place.valueForKey("lat") as! String
            if let number = Double(latString) {
                coordinate.latitude = number as! CLLocationDegrees
            }
            let lngString = place.valueForKey("lng") as! String
            if let number = Double(lngString) {
                coordinate.longitude = number as! CLLocationDegrees
            }
            
            let customAnnotation = CustomAnnotation(name: name, address: "bang", coordinates: coordinate)
            
            
            
            let demoModelOne = demoModel()
            demoModelOne.photosURL=[]
            let description = descriptionPlace()
            description.placeBasic=name
            customAnnotation.placeName = name
          //  description.placeDetail=place.valueForKey("description") as! String
            demoModelOne.placeDesc=description
            demoModelOne.placeMain = iconLabel()
            customAnnotation.demoModelOne=demoModelOne
            
            self.mapView.addAnnotation(customAnnotation)
            
        }
        
        
//        TwitterPolarityHelper.getTwitterStatues(arrayForPolarity,completionHandler: {polarityArray  in
//                print(polarityArray)
//            })
    }
    
    
    
    func plotPositions(){
        var arrayToUse:NSArray!
        if newArray.count > 0{
            arrayToUse=self.newArray
        }
        else{
            arrayToUse=self.mapResults
        }
        AppSettings.sharedInstance.polarityAverageArray=[]
        for annotation in self.mapView.annotations{
            
            if annotation.isKindOfClass(CustomAnnotation){
                self.mapView.removeAnnotation(annotation)
            }
        }
        for(var i=0;i<arrayToUse.count;i++){
           
            let place:NSDictionary = self.mapResults[i] as! NSDictionary
            
            let geo : NSDictionary = place.valueForKey("geometry") as! NSDictionary
            let name : String = place.valueForKey("name") as! String
            
            let address : String = place.valueForKey("vicinity") as! String
            let loc : NSDictionary = geo.valueForKey("location") as! NSDictionary
            var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
            coordinate.latitude = loc.valueForKey("lat") as! CLLocationDegrees
            coordinate.longitude = loc.valueForKey("lng") as! CLLocationDegrees
            
            let customAnnotation = CustomAnnotation(name: name, address: address, coordinates: coordinate)
            
            let demoModelOne = demoModel()
            demoModelOne.photosURL=[]
            let description = descriptionPlace()
            description.placeBasic=name
            description.placeDetail=name
            demoModelOne.placeDesc=description
            
            demoModelOne.placeMain = iconLabel()
            customAnnotation.demoModelOne=demoModelOne
            
            TwitterPolarityHelper.getTwitterStatues(name,completionHandler: {polarityArray  in
                print(polarityArray)
                AppSettings.sharedInstance.polarityAverageArray.append(self.findAverage(polarityArray))
                print(AppSettings.sharedInstance.polarityAverageArray)
            })
            
            if AppSettings.sharedInstance.polarityAverageArray.count > 0 && AppSettings.sharedInstance.polarityAverageArray.count == self.mapResults.count && AppSettings.sharedInstance.polarityAverageArray[i] != -1{
                self.newArray.addObject(self.mapResults[i])
                
               customAnnotation.annotationType="Twitter"
                
            }
            else{
                customAnnotation.annotationType="Something else"
               // customAnnotation.image = UIImage(named: "restroIcon")
            }
            
            if i == 0 || i == 2 || i == 6{
                customAnnotation.annotationType="Twitter"
            }
            
            self.mapView.addAnnotation(customAnnotation)
             
        }
        
      
    }
    
    
      
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pinAnnotation"
        
        var annotationView : MKAnnotationView!
        if annotation.isKindOfClass(CustomAnnotation){
            if let dequedView = self.mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKAnnotationView?{
                dequedView.annotation = annotation
                annotationView = dequedView
            }else{
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            annotationView.enabled = true
            var imageView = UIImageView(frame: CGRect(x: -2, y: -4, width: 24, height: 24))
            imageView.layer.cornerRadius = 12.0
            imageView.layer.masksToBounds = true
            
            if (AppSettings.sharedInstance.type == "food" || AppSettings.sharedInstance.type == "restaurant"){
                if (annotation as! CustomAnnotation).annotationType == "Twitter"{
                    imageView.image = UIImage(named: "Twitter.jpg")
                }
                else{
                    imageView.image = UIImage(named: "restroIcon")
                }
            }else if(AppSettings.sharedInstance.type == "hindu_temple"){
                if (annotation as! CustomAnnotation).annotationType == "Twitter"{
                    imageView.image = UIImage(named: "Twitter.jpg")
                }
                else{
                    imageView.image = UIImage(named: "templeIcon")
                }
            }else if(AppSettings.sharedInstance.type == "atm"){
                if (annotation as! CustomAnnotation).annotationType == "Twitter"{
                    imageView.image = UIImage(named: "Twitter.jpg")
                }
                else{
                    imageView.image = UIImage(named: "atmIcon")
                }
            }
            else if (AppSettings.sharedInstance.type == "gas_station"){
                if (annotation as! CustomAnnotation).annotationType == "Twitter"{
                    imageView.image = UIImage(named: "Twitter.jpg")
                }
                else{
                    imageView.image = UIImage(named: "petrolicon")
                }
            }
            if self.isTA{
                if (annotation as! CustomAnnotation).annotationType == "Twitter"{
                    imageView.image = UIImage(named: "Twitter.jpg")
                }
                else{
                    imageView.image = UIImage(named: "tourAttIcon")
                }
                print(annotation.title)
                
            }
            annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            
            annotationView.addSubview(imageView)
            annotationView.canShowCallout = true
            //annotationView.animatesDrop = true
            return annotationView
        }
       
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let mainViewController=UIStoryboard(name: "MainDetail", bundle: nil).instantiateViewControllerWithIdentifier("DetailsScene") as! MainViewController
        mainViewController.placeName = (view.annotation as! CustomAnnotation).placeName//(view as! CustomAnnotation).placeName
        self.navigationController?.pushViewController(mainViewController, animated: true)
        
    }

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        if !self.isSetRegion{
            if let loc = self.mapView.userLocation.location {
                let region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 2000, 2000)
                self.mapView.setRegion(region, animated: true)
            }
            self.isSetRegion = true
            
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        var mapRect : MKMapRect = self.mapView.visibleMapRect
        var eastMapPoint : MKMapPoint = MKMapPoint(x: MKMapRectGetMinX(mapRect), y: MKMapRectGetMinY(mapRect))
        var westMapPoint : MKMapPoint = MKMapPoint(x: MKMapRectGetMaxX(mapRect), y: MKMapRectGetMaxY(mapRect))
        self.currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint)
        self.currentCentre = self.mapView.centerCoordinate
        
        
    }
    
    func addNotification(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var carType = userDefaults.valueForKey("carType") as! String!
        if carType == nil{
            carType="honda"
        }
        sendNotification("How far are you?",timeInterval: self.calFuelNeed(carType) + 5,isRepeat: false,title: "fuel")
        sendNotification("you might be hungry!Find food near you!",timeInterval: self.calFoodNeed(),isRepeat: false,title: "food")
    }

    func sendNotification(text:String,timeInterval:Double,isRepeat:Bool,title:String){
      //  UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow:timeInterval)
        localNotification.alertBody = text
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        print(localNotification.applicationIconBadgeNumber)
        localNotification.repeatInterval = NSCalendarUnit.Day
        localNotification.alertTitle = title
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
    
    func getDistance(sender : NSNotificationCenter){
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print(locations)
        if isFirst{
            AppSettings.sharedInstance.startLocation = locations.first! as CLLocation
            self.isFirst = false
        }else{
            AppSettings.sharedInstance.startLocation = locations.first! as CLLocation
            AppSettings.sharedInstance.middleLocation = locations.last! as CLLocation
            
            var distLeft : Double!
            
            var distance : CLLocationDistance = AppSettings.sharedInstance.middleLocation.distanceFromLocation(AppSettings.sharedInstance.startLocation)
            
            if distance >= self.expDistance{
                
            }else{
                distLeft = self.expDistance - distance
            }
            
            //calculate speed
            
            var speed = distance/self.timeInterval
            print("speed\(speed),,distanceleft \(distLeft)")
            
            var timeInterval = 5.0//distLeft/speed
            
            if (isNotified == true){
                sendNotification("You are out of fuel!find the fuel near you",timeInterval: timeInterval,isRepeat: false,title: "fuel")
                isNotified = false
            }

            
        }
        
        
        
    }
    
    func calFuelNeed(vehicleType:String) -> Double{
        
        
        
        var avgSpeed : Double = 80
        
        if vehicleType == "Honda"{
            
            mileage = 26
            tankCapacity = 42
            
        }else if vehicleType == "maruti"{
            
        }else{
            
        }
        
        self.expDistance = mileage * tankCapacity
        timeInterval = self.expDistance/avgSpeed
        
        return 10//timeInterval
        
        
    }
    
    func calFoodNeed()->Double{
        
        if isRemindMeLater{
            
            return 5//900 // 15 mins
            
        }else{
            return 10//10800//3 hours
        }
        
        
        
    }

    

    
    func findAverage(array:[Int])->Float{
        if array.count != 0{
            var sum:Int=0
            for arrayElement in array{
                sum=sum+arrayElement
            }
                return Float(sum)/Float(array.count)
        }
        else{
            return -1.0
        }
    }
    
    
    func addLeftNavbarButton(){
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "sidebarIcon.png"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: Selector("onSlideMenuButtonPressed:"), forControlEvents: .TouchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    
    func handleSwipe(sender:UISwipeGestureRecognizer){
        
        if(sender.direction == .Left){
            
            if self.sidebarShouldOpen == false{
                self.openSlidebar(false)
            }
            
        }else{
            
            self.openSlidebar(true)
            if(self.sidebarShouldOpen == true){
                self.openSlidebar(true)
            }
        }
    }
    
    
    func sidebarDidSelectRow(sendingString:String) {
        self.optionChoosed(sendingString)
        //print("selected item is : \(indexPath)")
        self.openSlidebar(false)
    }
    
    func closeSlidebar(){
        
        self.sidebarDidSelectRow("No selection")
        
        let viewMenuBack : UIView = view.subviews.last!
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            var frameMenu : CGRect = viewMenuBack.frame
            frameMenu.origin.x = -1 * UIScreen.mainScreen().bounds.size.width
            viewMenuBack.frame = frameMenu
            // viewMenuBack.layoutIfNeeded()
            viewMenuBack.backgroundColor = UIColor.clearColor()
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                //  self.sidebarShouldOpen = true
        })
    }
    
    func openSlidebar(sidebarShouldOpen : Bool){
        
        // sender.enabled = true
        
        
        
        //        UIView.animateWithDuration(0.3, animations: { () -> Void in
        //            menuVC.view.frame=CGRectMake(0, 0, barWidth, UIScreen.mainScreen().bounds.size.height);
        //            blurView.frame = menuVC.view.bounds
        //           // sender.enabled = true
        //            self.sidebarShouldOpen = false
        //            }, completion:nil)
        //
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.animator.removeAllBehaviors()
        
        self.sidebarShouldOpen = (sidebarShouldOpen) ? false : true
        
        let gravityX : CGFloat = (sidebarShouldOpen) ? 1.0 : -1.0
        let boundaryX : CGFloat = (sidebarShouldOpen) ? barWidth : -barWidth
        let magnitude : CGFloat = (sidebarShouldOpen) ? 20 : -20
        
        let gravityBehaviour:UIGravityBehavior = UIGravityBehavior(items: [menuVC.view])
        gravityBehaviour.gravityDirection = CGVectorMake(gravityX, 0.0)
        self.animator.addBehavior(gravityBehaviour)
        
        let collisionBehaviour:UICollisionBehavior = UICollisionBehavior(items: [menuVC.view])
        collisionBehaviour.addBoundaryWithIdentifier("Sidebar Boundary", fromPoint: CGPointMake(boundaryX,20.0), toPoint: CGPointMake(boundaryX, self.view.frame.size.height))
        self.animator.addBehavior(collisionBehaviour)
        
        
        let pushBehaviour:UIPushBehavior = UIPushBehavior(items: [menuVC.view], mode: UIPushBehaviorMode.Instantaneous)
        pushBehaviour.magnitude = magnitude
        self.animator.addBehavior(pushBehaviour)
        
        
        let sidebarBehaviour:UIDynamicItemBehavior = UIDynamicItemBehavior(items: [menuVC.view])
        sidebarBehaviour.elasticity = 0.4
        self.animator.addBehavior(sidebarBehaviour)
        
        
        //  self.sidebarShouldOpen = false
        
        
    }
    
    func onSlideMenuButtonPressed(sender : UIButton){
        if (self.sidebarShouldOpen == false)
        {
            // To Hide Menu If it already there
            self.openSlidebar(false)
            return
        }
        else if(self.sidebarShouldOpen == true){
            // sender.enabled = false
            self.openSlidebar(true)
        }
        
        
    }


    @IBAction func tripOverPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

