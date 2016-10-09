//
//  GameViewController.swift
//  Survive
//
//  Created by Vishnu Thiagarajan on 6/2/15.
//  Copyright (c) 2015 Vishnu Thiagarajan. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        guard let
            path = NSBundle.mainBundle().pathForResource(file, ofType: "sks"),
            sceneData = try? NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe) else {
                return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        
        guard let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as? GameScene else {
            return nil
        }
        
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {

    var muzik: Bool = true
    var musicplayer:AVAudioPlayer = AVAudioPlayer()
    var scene: SKScene = SKScene()
    var vcb:Bool = false
    var vc:EndViewController=EndViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       /* if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
       }*/
    }
    
    func setvc(v: EndViewController){
        vc=v
        vcb=true
    }

    deinit {
        debugPrint("Name_of_view_controlled deinitialized. GameScene")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(muzik){
            let skView:SKView = self.view as! SKView
            if(skView.scene == nil){
                
            do {
            let musicurl:NSURL = NSBundle.mainBundle().URLForResource("bgmusic", withExtension: "mp3")!
            try musicplayer = AVAudioPlayer(contentsOfURL: musicurl)
            musicplayer.numberOfLoops = -1
            musicplayer.prepareToPlay()
            musicplayer.play()
            }
            catch {
                print(error)
            }
            

            skView.ignoresSiblingOrder = true
            let scene = GameScene(size: skView.bounds.size, par: self)
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            }
        }
    }
    
   /* override func viewWillLayoutSubviews() {
        if(muzik){
        var musicurl:NSURL = NSBundle.mainBundle().URLForResource("bgmusic", withExtension: "mp3")!
        musicplayer=AVAudioPlayer(contentsOfURL: musicurl, error: nil)
        musicplayer.numberOfLoops = -1
        musicplayer.prepareToPlay()
        musicplayer.play()
        var skView:SKView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        scene = GameScene(size: skView.bounds.size, par: self)
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        }
    }*/
    
    func done(score: Int){
        print(score)
        //viewWillAppear(true)
        let skView:SKView = self.view as! SKView
        skView.presentScene(nil)
        musicplayer.stop()
        muzik = false
        scene.removeFromParent()
        scene = SKScene()
        //var end:EndViewController = EndViewController(scre: score)
        //end.loadView()
        if(vcb){
            vc = self.storyboard!.instantiateViewControllerWithIdentifier("endscreen") as! EndViewController
        }
        self.showViewController(vc as UIViewController, sender: nil)
        vc.setscores(score)
        vc.deleteme(self)
        skView.removeFromSuperview()
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
