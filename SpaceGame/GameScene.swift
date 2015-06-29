//
//  GameScene.swift
//  SpaceGame
//
//  Created by Reed Carson on 6/26/15.
//  Copyright (c) 2015 Reed Carson. All rights reserved.
//

import SpriteKit
import AVFoundation


var missileTimer: NSTimer!
var chaingunTimer: NSTimer!

var chainReloaded: Bool = true

var missileReloaded: Bool = true
var missileIndicator: SKSpriteNode!



var ammoCount: Int!
var ammoCounter: SKLabelNode!
var missileCount: Int!
var missileCounter: SKLabelNode!

let playerShip = SKSpriteNode(imageNamed: "ship1")

var touchHoldLeft: Bool = false
var touchHoldRight: Bool = false
var gunBool: Bool = false

//
let secondsM = 0.2
let delayM = secondsM * Double(NSEC_PER_SEC)  // nanoseconds per seconds
var dispatchTimeM = dispatch_time(DISPATCH_TIME_NOW, Int64(delayM))
//

class GameScene: SKScene {
    
    
    
    override func didMoveToView(view: SKView) {
       
        missileIndicator = childNodeWithName("missileIndicator") as? SKSpriteNode

        initialGameState()
        
        missileCounter = childNodeWithName("missileCounter") as? SKLabelNode
        missileCounter.text = "\(missileCount)"
        
        ammoCounter = childNodeWithName("ammoCounter") as? SKLabelNode
        ammoCounter.text = "\(ammoCount)"
        
        fireMissile = childNodeWithName("fireTwo") as? SKSpriteNode
        fireChaingun = childNodeWithName("fireOne") as? SKSpriteNode
        
        moveRight = childNodeWithName("moveRight") as? SKSpriteNode
        moveLeft = childNodeWithName("moveLeft") as? SKSpriteNode
        
        backgroundColor = UIColor.blackColor()
        
        
    
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            if moveRight .containsPoint(location) {
                
                touchHoldRight = true
                
            }
            
            if moveLeft .containsPoint(location) {
                
                touchHoldLeft = true
                
            }
            
            
            if fireChaingun .containsPoint(location) {
                
                gunBool = true
                
            }
            
            if fireMissile .containsPoint(location) {
                
                if (missileCount > 0) && (missileReloaded == true) {

                    launchMissle()
                    
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        touchHoldRight = false
        gunBool = false
        touchHoldLeft = false
        
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        
        if (gunBool == true) && (ammoCount > 0) && (chainReloaded == true){
            
            fireChaingunRepeat()
            updateAmmoCount()
            
        }
        
        if touchHoldRight == true {
            
            moveShipRight()
        }
        
        if touchHoldLeft == true {
            
            moveShipLeft()
        }
    }
    
    func chainDelay() {
        
        chainReloaded = true
        
    }
    
    
    
    func fireChaingunRepeat() {
        
        
         chaingunTimer = NSTimer.scheduledTimerWithTimeInterval(0.20, target:self, selector: Selector("chainDelay"), userInfo: nil, repeats: false)
        
        chainReloaded = false
        
        /// shells
        let shells = SKShapeNode(rectOfSize: CGSize(width: 8, height: 20))
        shells.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(8, 20))
        shells.physicsBody?.allowsRotation = true
        shells.fillColor = UIColor.yellowColor()
        shells.position = playerShip.position
        shells.position = CGPoint(x: playerShip.position.x, y: playerShip.position.y + 25)
        addChild(shells)
        shells.physicsBody?.applyImpulse(CGVectorMake(3, 2))
        shells.physicsBody?.applyAngularImpulse(1)
        shells.physicsBody?.collisionBitMask = 0 // change later
        ///shells
        
        /// chain gun
        let chainGun = SKShapeNode(rectOfSize: CGSize(width: 8, height: 20))
        chainGun.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(8, 20))
        chainGun.fillColor = UIColor(red:0.88, green:0.41, blue:0.06, alpha:1)
        chainGun.position = playerShip.position
        addChild(chainGun)
        chainGun.physicsBody?.applyImpulse(CGVectorMake(0, 12))
        chainGun.physicsBody?.affectedByGravity = false
        chainGun.physicsBody?.collisionBitMask = 0  //change later
        //// chain gun
        
    }
    func moveShipRight() {
        
        if playerShip.position.x < 675 {
            
            playerShip.position.x = playerShip.position.x + 7
            
        }
    }
    
    func moveShipLeft() {
        
        if playerShip.position.x > 75 {
            
            playerShip.position.x = playerShip.position.x - 7
            
        }
    }
    ////// ~~~~~~~~
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    //////~~~~~~~ credit matt (only 2 t's) on SO
    
    
    func missileTime() {
        
        missileReloaded = true
        
        if missileCount > 0 {
        
        missileIndicator.hidden = false
            
        }
        
//        println(missileReloaded.boolValue)

    }

    func launchMissle() {
        
     
        
        
        missileTimer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("missileTime"), userInfo: nil, repeats: false)
       
        missileReloaded = false
        missileIndicator.hidden = true
  
        //
//        println(missileReloaded.boolValue)
        //
        
        let missile1 = SKSpriteNode(imageNamed: "missile1")
        missile1.position = CGPoint(x: playerShip.position.x + 35, y: playerShip.position.y - 30)
        missile1.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(20, 50))
        missile1.zPosition = 25
        
        missile1.size = CGSizeMake(15, 55)
        addChild(missile1)
        missile1.physicsBody?.affectedByGravity = false
        missile1.physicsBody?.applyImpulse(CGVectorMake(3, -3))
        
        delay(0.25, closure: { () -> () in
            
            missile1.physicsBody?.applyImpulse(CGVectorMake(-3, 25))
            
        })
        
     updateMissileCount()
        
        
        
    }
    
    func initialGameState() {
        
        
        ammoCount = 250
        missileCount = 10
        missileReloaded = true
//        missileIndicator.hidden = false
        
        playerShip.position = CGPoint(x: frame.width / 2, y: frame.height / 4)
        playerShip.size = CGSize(width: 125, height: 150)
        playerShip.zPosition = 50
        addChild(playerShip)
        
        
    }
    func updateAmmoCount() {
        
        ammoCount = ammoCount - 1
        ammoCounter.text = "\(ammoCount)"
      
        
    }
    func updateMissileCount() {
       
        
        missileCount = missileCount - 1
        missileCounter.text = "\(missileCount)"
      
        if missileCount == 0 {
            
            missileIndicator.hidden = true
        }
       
        
    }
    
}
