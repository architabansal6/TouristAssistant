//
//  MainViewController.swift
//  DemoSecondScreen
//
//  Created by Tejashree Khedkar on 2/6/16.
//  Copyright © 2016 Tejashree Khedkar. All rights reserved.
//

import UIKit
//import XCPlayground
import AVFoundation

//XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
class MainViewController: UIViewController {
    var webData: NSMutableData!
    var data = NSMutableData()
    var comData :[demoModel!]=[]
    
    @IBOutlet weak var descTextview: UITextView!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var speakButton: UIButton!
    
    var currentDataModel:demoModel!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var rate: Float!
    
    var pitch: Float!
    
    var volume: Float!
    var placeName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the corners of the textview rounded and the buttons look like circles.
        descTextview.layer.cornerRadius = 15.0
        //tvEditor.layer.cornerRadius = 15.0
        pauseButton.layer.cornerRadius = 30.0
        stopButton.layer.cornerRadius = 30.0
        speakButton.layer.cornerRadius = 30.0
        //btnMike.layer.cornerRadius = 30.0
        
        // Set the initial alpha value of the following buttons to zero (make them invisible).
        pauseButton.alpha = 0.0
        stopButton.alpha = 0.0
        
        // Make the progress view invisible and set is initial progress to zero.
        //        pvSpeechProgress.alpha = 0.0
        //        pvSpeechProgress.progress = 0.0
        //
        if !loadSettings() {
            registerDefaultSettings()
        }
        
        //speakDataMsg("Hello, Hoe are you?")
        startConnection()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationItem.title = self.placeName
    }
    
    func loadData(){
        comData[0].placeDesc.placeBasic = "LalBaug Garden"
        comData[0].placeDesc.placeDetail = ""
        //comData[0].images = [UIImage(named: "lalbaug1")!,UIImage(named: "lalbaug2")!,UIImage(named: "lalbaug3")!,UIImage(named: "lalbaug4")!,UIImage(named: "lalbaug5")!,UIImage(named: "lalbaug6")!]
        comData[1].placeDesc.placeBasic = "Cubbon Park"
        comData[1].placeDesc.placeDetail = ""
        //comData[1].images = [UIImage(named: "cubbon1")!,UIImage(named: "cubbon2")!,UIImage(named: "cubbon3")!,UIImage(named: "cubbon4")!,UIImage(named: "cubbon5")!,UIImage(named: "cubbon6")!]
        comData[2].placeDesc.placeBasic = "Wonderla"
        comData[2].placeDesc.placeDetail = "Within an hour of leaving behind the city roads, you are tempted to enter the pit lane at Grips (10:00 – 19:00 hrs/21:00 hrs on weekends), which is an international standard karting and bowling venue. A few miles further is South India’s largest amusement park, Wonderla (11:00 – 18:00 hrs, 19:00 hrs on weekends) with over fifty dry and water rides. This however isn’t a pit stop and deserves a whole day. Next up near Bidadi town, is Innovative Film City, a multiple entertainment destination with Ripley’s museum and Louis Tussaud’s Wax museum to name a few."
        //comData[2].images = [UIImage(named: "wonderla1")!,UIImage(named: "wonderla2")!,UIImage(named: "wonderla3")!,UIImage(named: "wonderla4")!,UIImage(named: "wonderla5")!,UIImage(named: "wonderla6")!]
        
    }
    
    
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings: Dictionary<String, AnyObject> = ["rate": rate, "pitch": pitch, "volume": volume]
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultSpeechSettings)
        //NSUserDefaults.standardUserDefaults().registerDefaults(defaultSpeechSettings)
    }
    
    func loadSettings() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults
        
        if let theRate: Float = userDefaults.valueForKey("rate") as? Float {
            rate = theRate
            pitch = userDefaults.valueForKey("pitch") as! Float
            volume = userDefaults.valueForKey("volume") as! Float
            
            return true
        }
        
        return false
    }
    
    func animateActionButtonAppearance(shouldHideSpeakButton: Bool) {
        var speakButtonAlphaValue: CGFloat = 1.0
        var pauseStopButtonsAlphaValue: CGFloat = 0.0
        
        if shouldHideSpeakButton {
            speakButtonAlphaValue = 0.0
            pauseStopButtonsAlphaValue = 1.0
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.speakButton.alpha = speakButtonAlphaValue
            
            self.pauseButton.alpha = pauseStopButtonsAlphaValue
            
            self.stopButton.alpha = pauseStopButtonsAlphaValue
        })
    }
    
    
    func startConnection(){
        //let urlPath:String = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=de&dt=t&q=hello%20world" //+ encodeURI("hello world")
        let urlPath: String = "https://www.googleapis.com/language/translate/v2?key=AIzaSyC2NA5Fv4rlJCvA15ANG3ysse4Wlt5yy_k&q=hello%20world&source=en&target=de"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    //    func buttonAction(sender: UIButton!){
    //        startConnection()
    //    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        var json: [String: AnyObject]!
        
        // throwing an error on the line below (can't figure out where the error message is)
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
        } catch {
            print(error)
            
            //XCPlaygroundPage.currentPage.finishExecution()
        }
        print(json)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError!)
    {
        print("didFailWithError")
        
        //        if delegate != nil{
        //
        //            delegate!.didReceiveConnetionError()
        //        }
        
        webData = nil
    }
    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!){
        
        webData =   NSMutableData()
    }
    
    //    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
    //
    //        webData!.appendData(data)
    //    }
    
    //    func connectionDidFinishLoading(connection: NSURLConnection!){
    //
    //        doGet(webData)
    //    }
    //
    func doGet(datans:NSData) {
        
        var sourceText =  " good morning. how are you? "
        
        
        var sourceLang = "auto";
        
        var targetLang = "ja";
        //var JSONurl = "https://translate.googleapis.com/translate_a/single?client=gtx&sl="+sourceLang + "&tl=" + targetLang + "&dt=t&q=" + encodeURI(sourceText)
        
        var JSONurl = "https://www.googleapis.com/language/translate/v2?key=AIzaSyCSHmftf7ricOh4jQ17lcYWI-IUmJOWAjg&source=en&target=de&q=Hello%20world"
        
        let url             =   NSURL(string: JSONurl)
        let theRequest      =   NSMutableURLRequest(URL: url!)
        var theConnection   =   NSURLConnection(request: theRequest, delegate: self)
        
        //    var result = JSON.parse(UrlFetchApp.fetch(url).getContentText());
        var json: [String: AnyObject]!
        //let json = NSJSONSerialization.JSONObjectWithData(datans, options: NSJSONReadingOptions.MutableContainers,error: &error) as NSDictionary!
        do {
            json = try NSJSONSerialization.JSONObjectWithData(datans, options: NSJSONReadingOptions()) as? [String: AnyObject]
        } catch {
            print(error)
            
            //XCPlaygroundPage.currentPage.finishExecution()
        }
        print(json)
        
    }
    
    func encodeURI(sourceText:String){
        //        var originalString = "test/test=42"
        var customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        var escapedString = sourceText.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        print("escapedString: \(escapedString)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 5    }
    //
    func speakDataMsg(messageSpeak:String){
        
        if !speechSynthesizer.speaking {
            let textParagraphs = messageSpeak.componentsSeparatedByString("\n")
            
            for pieceOfText in textParagraphs {
                let speechUtterance = AVSpeechUtterance(string: pieceOfText)
                speechUtterance.rate = rate
                speechUtterance.pitchMultiplier = pitch
                speechUtterance.volume = volume
                speechUtterance.postUtteranceDelay = 0.005
                
                speechSynthesizer.speakUtterance(speechUtterance)
            }
        }
        else{
            speechSynthesizer.continueSpeaking()
        }
        
        
    }
    @IBAction func stopButtonPressed(sender: AnyObject) {
        
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        animateActionButtonAppearance(false)
        
    }
    
    @IBAction func pauseButtonPressed(sender: AnyObject) {
        speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
        animateActionButtonAppearance(false)
    }
    
    @IBAction func spaekButtonPressed(sender: AnyObject) {
        if !speechSynthesizer.speaking {
            let textParagraphs = descTextview.text.componentsSeparatedByString("\n")
            
            for pieceOfText in textParagraphs {
                let speechUtterance = AVSpeechUtterance(string: pieceOfText)
                speechUtterance.rate = rate
                speechUtterance.pitchMultiplier = pitch
                speechUtterance.volume = volume
                speechUtterance.postUtteranceDelay = 0.005
                
                speechSynthesizer.speakUtterance(speechUtterance)
            }
        }
        else{
            speechSynthesizer.continueSpeaking()
        }
        
        animateActionButtonAppearance(true)
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
