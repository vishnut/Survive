//
//  EndViewController.swift
//  Survive
//
//  Created by Vishnu Thiagarajan on 6/11/15.
//  Copyright (c) 2015 Vishnu Thiagarajan. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var highscorelabel: UILabel!
    @IBOutlet weak var highscorevalue: UILabel!
    @IBOutlet weak var coingain: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storage: UserDefaults = UserDefaults.standard
        var scr:Int=storage.object(forKey: "currscore") as! Int
        var high:Int?=storage.object(forKey: "highscore") as? Int
        
        if(high == nil || scr > high!)
        {
            high = scr
            highscorelabel.text = "High Score!!!"
            storage.set(scr, forKey: "highscore")
        }
        print(scr)
        score.text = String(scr)
        var coins = pow(Double(scr), 0.6)
        if(scr>300){
            coins += pow(Double(scr), 1.3) / 300
        }

        var current:Double? = storage.object(forKey: "coins") as? Double
        if(current == nil){
            current = 0
        }
        storage.set(coins + current!, forKey: "coins")
        coingain.text = "+  " + String(Int(coins))
        if(scr > 100)
        {
            score.font = score.font.withSize(score.font.pointSize - 30)
        }
        if(scr > 1000)
        {
            score.font = score.font.withSize(score.font.pointSize - 30)
        }
        scr = high!
        highscorevalue.text = "High Score " + String(scr)
        print("LOADED " + String(scr))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
