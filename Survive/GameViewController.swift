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
/*
extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        guard let
            path = Bundle.main.path(forResource: file, ofType: "sks"),
            let sceneData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        
        guard let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? GameScene else {
            return nil
        }
        
        archiver.finishDecoding()
        return scene
    }
}
*/
class GameViewController: UIViewController {

    var muzik: Bool = true
    weak var musicplayer:AVAudioPlayer? = AVAudioPlayer()
    var count = 0
    var ending:Bool = false
    var zombieAtlas = SKTextureAtlas()
    var zombieImages = [SKTexture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(muzik && !self.ending){
            let skView:SKView = self.view as! SKView
            if(skView.scene == nil){
            
            do {
            let musicurl:URL = Bundle.main.url(forResource: "bgmusic", withExtension: "mp3")!
            try musicplayer = AVAudioPlayer(contentsOf: musicurl)
            musicplayer?.numberOfLoops = -1
            musicplayer?.prepareToPlay()
            musicplayer?.play()
            }
            catch {
                print(error)
            }
            
            skView.ignoresSiblingOrder = true
            let scene = GameScene(size: skView.bounds.size, par: self)
            scene.vc = self
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            }
        }
    }
    
    func done(_ score: Int){
        count += 1
        print(score)
        if(count < 2){
        musicplayer?.stop()
        muzik = false
        let skView:SKView = self.view as! SKView
        skView.scene?.removeFromParent()
        let storage: UserDefaults = UserDefaults.standard
        storage.set(score, forKey: "currscore")
        //self.dismiss(animated: false, completion: nil)
        if let endViewController = self.storyboard?.instantiateViewController(withIdentifier: "endscreen") as? EndViewController {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController?.dismiss(animated: false, completion: {
                appDelegate.window?.rootViewController!.present(endViewController, animated: true, completion: nil)
            })
                //self.present(endViewController, animated: true, completion: nil)
            }
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
