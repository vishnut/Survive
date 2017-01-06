//
//  GameScene.swift
//  Survive
//
//  Created by Vishnu Thiagarajan on 6/2/15.
//  Copyright (c) 2015 Vishnu Thiagarajan. All rights reserved.
//

import SpriteKit
import AudioToolbox

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var popo:SKSpriteNode = SKSpriteNode(imageNamed: "policecar")
    var bgrd:SKSpriteNode = SKSpriteNode(imageNamed: "ownroad.jpg")
    var lastYieldInterval:TimeInterval = TimeInterval()
    var lastUpdateInterval:TimeInterval = TimeInterval()
    var points:Int = 0
    var stype:Int = 0
    let sname = ["torpedo","torpedopower","torpedo","torpedolined"]
    let carcategory:UInt32 = 0x1 << 1
    let shotcategory:UInt32 = 0x1 << 0
    
    var numCar:Int = 0
    var yield:Double = 1.0
    var levelUp:Int = 4
    var numUp:Int = 1
    var maxtime:Int = 7
    var totCar:Int = 0
    var tentot:Int = 0
    weak var vc: GameViewController? = nil
    var scoreDisplay = SKLabelNode()
    var torpDisplay = SKLabelNode()
    var stop:Bool = false
    var yieldmultiplier = 0.9
    var torpedos = 75

    override func didMove(to view: SKView) {
        /* Setup your scene here */
        /*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)*/
    }
    
    deinit {
        debugPrint("Name_of_view_controlled deinitialized. GameScene")
    }
    
    init(size: CGSize, par: GameViewController) {
        super.init(size: size)
        let torp = UserDefaults.standard.object(forKey: "shots") as! Int?
        if (torp == nil)
        {
            UserDefaults.standard.set(torpedos, forKey: "shots")
        }
        else
        {
            torpedos = torp!
        }
        let st = UserDefaults.standard.object(forKey: "stype") as! Int?
        if (st == nil)
        {
            UserDefaults.standard.set(stype, forKey: "stype")
        }
        else
        {
            stype = st!
        }
        bgrd.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.scaleMode = .aspectFill
        self.vc = par
        popo.position = CGPoint(x: self.frame.size.width/2, y: (popo.size.height)/2+30)
        popo.zPosition = 3
        self.addChild(popo)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        scoreDisplay = SKLabelNode(fontNamed:"Euphemia UCAS Bold")
        scoreDisplay.fontColor = SKColor.orange
        scoreDisplay.text = "0"
        scoreDisplay.fontSize = 85;
        scoreDisplay.position = CGPoint(x:self.frame.width-70, y:20)
        scoreDisplay.zPosition = 4
        torpDisplay = SKLabelNode(fontNamed:"Euphemia UCAS Bold")
        torpDisplay.fontColor = SKColor.gray
        torpDisplay.text = String(torpedos)
        torpDisplay.fontSize = 45;
        torpDisplay.position = CGPoint(x:70, y:20)
        torpDisplay.zPosition = 4
        self.addChild(scoreDisplay)
        self.addChild(torpDisplay)
        bgrd.zPosition = 1
        self.addChild(bgrd)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func addcars(){
        let colors = ["white","blue","gray","yellow","green"]
        let carname = colors[Int(arc4random_uniform(UInt32(colors.count)))]+"car"
        let car:SKSpriteNode = SKSpriteNode(imageNamed: carname)
        car.zPosition = 3
        car.physicsBody = SKPhysicsBody(rectangleOf: car.size)
        car.physicsBody?.isDynamic = true
        car.physicsBody?.categoryBitMask = carcategory
        car.physicsBody?.contactTestBitMask = shotcategory
        car.physicsBody?.collisionBitMask = 0
        
        let minx = car.size.width/2
        let maxx = self.frame.size.width - car.size.width/2
        let range = maxx-minx
        let xposition: CGFloat = (CGFloat)(arc4random()).truncatingRemainder(dividingBy: (CGFloat)(range)) + (CGFloat)(minx)
        
        car.position = CGPoint(x: xposition, y: self.frame.height + 30)
        self.addChild(car)
        
        let mintime = 1
        let randlevel: Int = (Int)(arc4random()) % 50 + (Int)(mintime)
        
        if(randlevel == 42 && maxtime > mintime){
            maxtime -= 1
        }
        
        var duration:Int = 1
        if(maxtime != mintime){
            duration = (Int)(arc4random()) % (Int)(maxtime-mintime) + (Int)(mintime)
        }
        
        var actionarray: [SKAction] = [SKAction]()
        actionarray.append(SKAction.moveTo(y: -car.size.width/2, duration: TimeInterval(duration)))
        actionarray.append(SKAction.run({
            self.removeAllActions()
            self.removeAllChildren()
            self.removeFromParent()
            self.vc?.ending = true
            self.stop = true
            self.vc?.done(self.totCar)
            self.vc = nil
        }))
        actionarray.append(SKAction.removeFromParent())
        if (!self.stop){
            car.run(SKAction.sequence(actionarray))
        }
    }
    
    
    
    func updateWithTimeSinceLastUpdate(_ TimeSinceLastUpdate: CFTimeInterval){
        lastYieldInterval += TimeSinceLastUpdate
        
        if(numCar >= levelUp){
            numCar = 0
            yield *= yieldmultiplier
            levelUp += numUp
            numUp += 1
            if(yieldmultiplier > 0.6){
                yieldmultiplier *= 0.98
            }
        }
        
        
        if(lastYieldInterval>yield && !self.stop){
            lastYieldInterval = 0
            addcars()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.playSoundFileNamed("gunshot.wav", waitForCompletion: false))
        
        let touch:UITouch = touches.first! as UITouch
        let touchLocation: CGPoint = touch.location(in: self)
        
        if(touchLocation.y < 100)
        {
            return
        }
        
        if (torpedos <= 0){
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return
        }
        torpedos -= 1
        torpDisplay.text = String(torpedos)
        
        shoot (time: 0.5, touchLocation: touchLocation)
        if (stype == 1)
        {
            shoot (time: 0.7, touchLocation: touchLocation )
        }
    }
    
    func shoot (time:Double, touchLocation: CGPoint)
    {
        let bullet: SKSpriteNode = SKSpriteNode(imageNamed: sname[stype])
        bullet.zPosition = 2
        bullet.position = (popo.position)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = shotcategory
        bullet.physicsBody?.contactTestBitMask = carcategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection=true
        
        let final = vectorAdd(bullet.position, b: vectorMult(vectorNorm(vectorSub(touchLocation, b: bullet.position)),b: 1000))
        self.addChild(bullet)
        
        var action: [SKAction] = [SKAction]()
        action.append(SKAction.move(to: final, duration: TimeInterval(time)))
        action.append(SKAction.removeFromParent())
        bullet.run(SKAction.sequence(action))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var carbody: SKPhysicsBody
        var bulletbody: SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask){
            carbody = contact.bodyA
            bulletbody = contact.bodyB
        }
        else{
            carbody = contact.bodyB
            bulletbody = contact.bodyA
        }
        
        
        if(carbody.categoryBitMask == carcategory && bulletbody.categoryBitMask == shotcategory && contact.bodyA.node != nil){
            contact.bodyA.node!.removeFromParent()
            numCar += 1
            tentot += levelUp
            let prevtot = totCar
            totCar = tentot/3
            
            if(prevtot < 100 && totCar >= 100){
                scoreDisplay.fontSize = (scoreDisplay.fontSize) - 20
            }
            else if(prevtot < 1000 && totCar >= 1000){
                scoreDisplay.fontSize = (scoreDisplay.fontSize) - 20
            }
            else if(prevtot < 10000 && totCar >= 10000){
                scoreDisplay.fontSize = (scoreDisplay.fontSize) - 20
            }
            
            scoreDisplay.text = String(totCar)
            
            if(contact.bodyB.node != nil)
            {
                contact.bodyB.node!.removeFromParent()
            }
        }
        
       
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        var timeSinceLastUpdate = currentTime - lastUpdateInterval
        lastUpdateInterval = currentTime
        
        if(timeSinceLastUpdate > 1){
            timeSinceLastUpdate = 1/60
            lastUpdateInterval = currentTime
        }
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
    }
    
    
    func vectorAdd(_ a:CGPoint,b:CGPoint) -> CGPoint{
        return CGPoint(x: a.x+b.x, y: a.y+b.y)
    }
    
    func vectorSub(_ a:CGPoint,b:CGPoint) -> CGPoint{
        return CGPoint(x: a.x-b.x, y: a.y-b.y)
    }
    
    func vectorMult(_ a:CGPoint,b:CGFloat) -> CGPoint{
        return CGPoint(x: a.x*b, y: a.y*b)
    }
    
    func vectorNorm(_ a:CGPoint) -> CGPoint{
        return CGPoint(x: a.x/sqrt(a.x*a.x+a.y*a.y), y: a.y/sqrt(a.x*a.x+a.y*a.y))
    }
    
}
