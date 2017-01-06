//
//  WSViewController.swift
//  Survive
//
//  Created by Vishnu Thiagarajan on 1/4/17.
//  Copyright © 2017 Vishnu Thiagarajan. All rights reserved.
//

import UIKit
import AudioToolbox

class WSViewController: UIViewController {

    @IBOutlet weak var num75: UIButton!
    @IBOutlet weak var num150: UIButton!
    @IBOutlet weak var num250: UIButton!
    @IBOutlet weak var num500: UIButton!
    @IBOutlet weak var num1000: UIButton!
    @IBOutlet weak var num10000: UIButton!
    @IBOutlet weak var numultimate: UIButton!
    @IBOutlet weak var coinlabel: UILabel!
    @IBOutlet weak var bigred: UIButton!
    @IBOutlet weak var baseshot: UIButton!
    @IBOutlet weak var ultrashot: UIButton!
    @IBOutlet weak var tripleshot: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storage: UserDefaults = UserDefaults.standard
        var nc = storage.object(forKey: "coins") as? Double
        if(nc==nil){
            nc = 0
            storage.set(nc, forKey: "coins")
        }
        coinlabel.text = String(Int(nc!))
        var nbit:Int? = storage.object(forKey: "numbitmap") as? Int
        if(nbit==nil)
        {
            nbit = 0b0000001
            storage.set(nbit, forKey: "numbitmap")
        }
        var tbit:Int? = storage.object(forKey: "typebitmap") as? Int
        if(tbit==nil)
        {
            tbit = 0b0001
            storage.set(tbit, forKey: "typebitmap")
        }
        for i in 0...6 {
            setButtonImageIfBitmap(nbitmap: nbit!,button: buttonFromNum(num: i),index: i)
        }
        for i in 0...3 {
            setButtonImageIfBitmap(nbitmap: tbit!,button: buttonFromType(num: i),index: i)
        }

        // Do any additional setup after loading the view.
    }
    
    func setButtonImageIfBitmap (nbitmap: Int, button: UIButton, index: Int) {
        if(nbitmap & (1 << index) != 0){
            button.setImage(UIImage(named: "selectedbox"), for: UIControlState.normal)
        }
    }
    
    func buttonFromType (num: Int) -> UIButton
    {
        switch(num){
        case 0:
            return baseshot
        case 1:
            return bigred
        case 2:
            return tripleshot
        case 3:
            return ultrashot
        default:
            return baseshot
        }
    }
    
    func buttonFromNum (num: Int) -> UIButton
    {
        switch(num){
        case 1:
            return num150
        case 2:
            return num250
        case 3:
            return num500
        case 4:
            return num1000
        case 5:
            return num10000
        case 6:
            return numultimate
        default:
            return num75
        }
    }
    
    @IBAction func numtapped(_ sender: UIButton) {
        print(sender.currentTitle!)
        let numarray = [75,150,250,500,1000,10000,0]
        let cost = [0.0,100,500,1000,3000,10000,50000]
        let str = sender.currentTitle!
        let index = Int(sender.currentTitle!.substring(from: str.index(str.startIndex, offsetBy: 1)))
        let storage: UserDefaults = UserDefaults.standard
        var nc:Double? = storage.object(forKey: "coins") as? Double
        var nbit:Int? = storage.object(forKey: "numbitmap") as? Int
        if(nc == nil)
        {
            nc = 0
            storage.set(nc, forKey: "coins")
        }
        if(nbit==nil)
        {
            nbit = 0b0000001
            storage.set(nbit, forKey: "numbitmap")
        }
        print(nbit!)
        print(1 << index!)
        if(nbit! & (1 << index!) != 0)
        {
            storage.set(numarray[index!], forKey: "shots")
        }
        else if(nc! > cost[index!])
        {
            nc! -= cost[index!]
            storage.set(nc, forKey: "coins")
            nbit = nbit! | (1 << index!)
            storage.set(nbit, forKey: "numbitmap")
            coinlabel.text = String(Int(nc!))
            storage.set(numarray[index!], forKey: "shots")
            buttonFromNum(num: index!).setImage(UIImage(named: "selectedbox"), for: UIControlState.normal)
        }
        else
        {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }
    
    @IBAction func typetapped(_ sender: UIButton) {
        print(sender.currentTitle!)
        let cost = [0.0,500,2500,10000]
        let str = sender.currentTitle!
        let index = Int(sender.currentTitle!.substring(from: str.index(str.startIndex, offsetBy: 1)))
        let storage: UserDefaults = UserDefaults.standard
        var nc:Double? = storage.object(forKey: "coins") as? Double
        if(nc == nil)
        {
            nc = 0
            storage.set(nc, forKey: "coins")
        }
        var tbit:Int? = storage.object(forKey: "typebitmap") as? Int
        if(tbit==nil)
        {
            tbit = 0b0001
            storage.set(tbit, forKey: "typebitmap")
        }
        print(tbit!)
        print(1 << index!)
        if(tbit! & (1 << index!) != 0)
        {
            storage.set(index!, forKey: "stype")
        }
        else if(nc! > cost[index!])
        {
            nc! -= cost[index!]
            storage.set(nc, forKey: "coins")
            tbit = tbit! | (1 << index!)
            storage.set(tbit, forKey: "typebitmap")
            coinlabel.text = String(Int(nc!))
            storage.set(index!, forKey: "stype")
            buttonFromType(num: index!).setImage(UIImage(named: "selectedbox"), for: UIControlState.normal)
        }
        else
        {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
