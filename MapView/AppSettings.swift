//
//  AppSettings.swift
//  MapView
//
//  Created by Swasidhant Chowdhury on 07/02/16.
//  Copyright © 2016 Archita Bansal. All rights reserved.
//

import Foundation
import MapKit
import AVFoundation

class AppSettings{
    static var sharedInstance = AppSettings()
    var speechSynthesizer = AVSpeechSynthesizer()
    
    var type = "food"
    var polarityAverageArray:[Float]=[]
    var startLocation : CLLocation!
    var middleLocation : CLLocation!
    
    func speakDataMsg(messageSpeak:String){
        var rate = AVSpeechUtteranceDefaultSpeechRate
        var pitch : Float = 1.0
        var volume : Float = 1.0
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
    
    

    
}
