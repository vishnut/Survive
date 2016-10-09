//
//  GameScene.swift
//  Survive
//
//  Created by Vishnu Thiagarajan on 6/2/15.
//  Copyright (c) 2015 Vishnu Thiagarajan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var popo:SKSpriteNode = SKSpriteNode()
    var bgrd:SKSpriteNode = SKSpriteNode()
    var lastYieldInterval:NSTimeInterval = NSTimeInterval()
    var lastUpdateInterval:NSTimeInterval = NSTimeInterval()
    var points:Int = 0
    
    let carcategory:UInt32 = 0x1 << 1
    let shotcategory:UInt32 = 0x1 << 0
    
    var numCar:Int = 0
    var yield:Double = 1.0
    var levelUp:Int = 4
    var numUp:Int = 1
    var maxtime:Int = 7
    var totCar:Int = 0
    var tentot:Int = 0
    var vc: GameViewController = GameViewController()
    var scoreDisplay = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
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
//        self.backgroundColor = SKColor.whiteColor()
        bgrd = SKSpriteNode(imageNamed: "road.jpg")
        vc = par
        bgrd.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        //self.addChild(bgrd)
        popo = SKSpriteNode(imageNamed: "policecar")
        popo.position = CGPointMake(self.frame.size.width/2, popo.size.height/2+30)
        self.addChild(popo)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        scoreDisplay = SKLabelNode(fontNamed:"EuphemiaUCASBold")
        scoreDisplay.fontColor = SKColor.orangeColor()
        scoreDisplay.text = "0"
        scoreDisplay.fontSize = 85;
        scoreDisplay.position = CGPoint(x:self.frame.width-50, y:20)
        self.addChild(scoreDisplay)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func addcars(){
        let car:SKSpriteNode = SKSpriteNode(imageNamed: "oncomingcar")
        car.physicsBody = SKPhysicsBody(rectangleOfSize: car.size)
        car.physicsBody?.dynamic = true
        car.physicsBody?.categoryBitMask = carcategory
        car.physicsBody?.contactTestBitMask = shotcategory
        car.physicsBody?.collisionBitMask = 0
        
        let minx = car.size.width/2
        let maxx = self.frame.size.width - car.size.width/2
        let range = maxx-minx
        let xposition: CGFloat = (CGFloat)(arc4random()) % (CGFloat)(range) + (CGFloat)(minx)
        
        car.position = CGPointMake(xposition, self.frame.height + 30)
        self.addChild(car)
        
        let mintime = 1
        let randlevel: Int = (Int)(arc4random()) % 50 + (Int)(mintime)
        
        if(randlevel == 42 && maxtime > mintime){
            maxtime--
        }
        
        var duration:Int = 1
        if(maxtime != mintime){
            duration = (Int)(arc4random()) % (Int)(maxtime-mintime) + (Int)(mintime)
        }
        
        var actionarray: [SKAction] = [SKAction]()
        actionarray.append(SKAction.moveToY(-car.size.width/2, duration: NSTimeInterval(duration)))
        actionarray.append(SKAction.runBlock({
            self.vc.done(self.totCar)
            self.removeAllActions()
            self.removeAllChildren()
            self.removeFromParent()
            self.view?.presentScene(nil)

        }))
        actionarray.append(SKAction.removeFromParent())
        
        car.runAction(SKAction.sequence(actionarray))
        
    }
    
    
    
    func updateWithTimeSinceLastUpdate(TimeSinceLastUpdate: CFTimeInterval){
        lastYieldInterval += TimeSinceLastUpdate
        
        if(numCar >= levelUp){
            numCar = 0
            yield *= 0.9
            levelUp += numUp
            numUp++
        }
        
        
        
        if(lastYieldInterval>yield){
            lastYieldInterval = 0
            addcars()
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }*/
        
        self.runAction(SKAction.playSoundFileNamed("gunshot.wav", waitForCompletion: false))
        
        let touch:UITouch = touches.first! as UITouch
        let touchLocation: CGPoint = touch.locationInNode(self)
        
        let bullet: SKSpriteNode = SKSpriteNode(imageNamed: "torpedo")
        bullet.position = popo.position
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.categoryBitMask = shotcategory
        bullet.physicsBody?.contactTestBitMask = carcategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection=true
        
        if(touchLocation.y < 100)
        {
            return
        }
        
        let final = vectorAdd(bullet.position, b: vectorMult(vectorNorm(vectorSub(touchLocation, b: bullet.position)),b: 1000))
        self.addChild(bullet)
        
        var action: [SKAction] = [SKAction]()
        action.append(SKAction.moveTo(final, duration: NSTimeInterval(0.5)))
        action.append(SKAction.removeFromParent())
        bullet.runAction(SKAction.sequence(action))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
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
        
        
        if(carbody.categoryBitMask == carcategory && bulletbody.categoryBitMask == shotcategory){
            contact.bodyA.node!.removeFromParent()
            numCar++
            tentot += levelUp
            totCar = tentot/3
            
            if(totCar == 100){
                scoreDisplay.fontSize = scoreDisplay.fontSize - 20
            }
            else if(totCar == 1000){
                scoreDisplay.fontSize = scoreDisplay.fontSize - 20
            }
            else if(totCar == 10000){
                scoreDisplay.fontSize = scoreDisplay.fontSize - 20
            }
            
            scoreDisplay.text = String(totCar)
            
            if(contact.bodyB.node != nil)
            {
                contact.bodyB.node!.removeFromParent()
            }
        }
        
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var timeSinceLastUpdate = currentTime - lastUpdateInterval
        lastUpdateInterval = currentTime
        
        if(timeSinceLastUpdate > 1){
            timeSinceLastUpdate = 1/60
            lastUpdateInterval = currentTime
        }
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
    }
    
    
    func vectorAdd(a:CGPoint,b:CGPoint) -> CGPoint{
        return CGPointMake(a.x+b.x, a.y+b.y)
    }
    
    func vectorSub(a:CGPoint,b:CGPoint) -> CGPoint{
        return CGPointMake(a.x-b.x, a.y-b.y)
    }
    
    func vectorMult(a:CGPoint,b:CGFloat) -> CGPoint{
        return CGPointMake(a.x*b, a.y*b)
    }
    
    func vectorNorm(a:CGPoint) -> CGPoint{
        return CGPointMake(a.x/sqrt(a.x*a.x+a.y*a.y), a.y/sqrt(a.x*a.x+a.y*a.y))
    }
    
}
