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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOADED")
        // Do any additional setup after loading the view.
    }
    
    func setscores(scre:Int){
   //     print(scre)
        //    if(scre != nil){
        score.text = String(scre)
      //  }
        if(scre>100){
            highscorelabel.text = "High Score!!!"
        }
    }
    
    func deleteme(me: UIViewController){
        self.showViewController(me, sender: me)
    }
    
  //  deinit {
    //    debugPrint("Name_of_view_controlled deinitialized. EndScene")
   // }

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
