//
//  GameScene.swift
//  SpaceGame
//
//  Created by Reed Carson on 6/26/15.
//  Copyright (c) 2015 Reed Carson. All rights reserved.
//

import SpriteKit
import AVFoundation


var alienOneHealth: Int = 100

var chainDamage: Int!
var missileDamage: Int!



let enemyCategory: UInt32 = 1
let playerWeaponCategory: UInt32 = 2
let missileCatgeory: UInt32 = 3
let chaingunWeaponCategory: UInt32 = 4
let beamVortexCategory: UInt32 = 5


//let thrust = SKSpriteNode(imageNamed: "thrust1")
var globalThrust: SKSpriteNode!



var beamSweep = SKAction.rotateToAngle(360, duration: 10)
let infiteSweep = SKAction.repeatActionForever(beamSweep)

var alienOneTexture: SKTexture!



let energyBeam1 = SKSpriteNode(imageNamed: "ebeam1")
let energyBeam2 = SKSpriteNode(imageNamed: "ebeam1")

var spawnAlien: SKSpriteNode!


var eBeamTexture: SKTexture!
var fireEnergyBeam: SKSpriteNode!
var fireChaingun: SKSpriteNode!
var fireMissile: SKSpriteNode!

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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMoveToView(view: SKView) {
        
        missileIndicator = childNodeWithName("missileIndicator") as? SKSpriteNode
        
        initialGameState()
        
        
        
        alienOneTexture = SKTexture(imageNamed: "alien1")
        eBeamTexture = SKTexture(imageNamed: "ebeam1")
        
        spawnAlien = childNodeWithName("spawnAlien") as? SKSpriteNode
        
        missileCounter = childNodeWithName("missileCounter") as? SKLabelNode
        missileCounter.text = "\(missileCount)"
        
        ammoCounter = childNodeWithName("ammoCounter") as? SKLabelNode
        ammoCounter.text = "\(ammoCount)"
        
        
        fireEnergyBeam = childNodeWithName("buttonThree") as? SKSpriteNode
        fireMissile = childNodeWithName("fireTwo") as? SKSpriteNode
        fireChaingun = childNodeWithName("fireOne") as? SKSpriteNode
        
        moveRight = childNodeWithName("moveRight") as? SKSpriteNode
        moveLeft = childNodeWithName("moveLeft") as? SKSpriteNode
        
        backgroundColor = UIColor.blackColor()
        
        physicsWorld.contactDelegate = self
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            if spawnAlien .containsPoint(location) {
                
                spawnAlienOne()
                //                println("alienspawned")
                
            }
            
            
            
            if moveRight .containsPoint(location) {
                
                touchHoldRight = true
                
            }
            
            if moveLeft .containsPoint(location) {
                
                touchHoldLeft = true
                
            }
            
            
            if fireChaingun .containsPoint(location) {
                
                gunBool = true
                println("gun button pressed")
                
            }
            
            if fireMissile .containsPoint(location) {
                
                if (missileCount > 0) && (missileReloaded == true) {
                    
                    launchMissle()
                    
                }
            }
            
            if fireEnergyBeam .containsPoint(location) {
                
                fireEBeam()
                //                println("beam button pressed")
                
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
    
    func removeEBeam() {
        
        energyBeam2.removeFromParent()
        energyBeam1.removeFromParent()
        
    }
    
    
    
    
    ///// DESTROY CODE ~~~~~~~~~~~~~~~~
    
    
    
    //    func enemyDestroyed() {
    //
    //        var explosion = SKSpriteNode(imageNamed: "explosion")
    //
    //
    //    }
    
    
    ///// ENEMY ALIEN CODE !!~~~~~~~~~~~~~~~~~~
    
    
    
    
    func spawnAlienOne() {
        
        let alienOne = SKSpriteNode(texture: alienOneTexture, size: CGSizeMake(200, 200))
        alienOne.position = CGPoint(x: frame.width / 2, y: frame.height * 0.75)
        alienOne.physicsBody = SKPhysicsBody(texture: alienOneTexture, size: CGSizeMake(200, 200))
        alienOne.physicsBody?.categoryBitMask = enemyCategory
        alienOne.physicsBody?.contactTestBitMask = playerWeaponCategory
        alienOne.physicsBody?.collisionBitMask = 0
        alienOne.physicsBody?.affectedByGravity = false
        alienOne.zPosition = 10
        alienOneHealth = 100
        
        addChild(alienOne)
        
        
    }
    
    
    
    /////// BEAM CODE !@~~~~~~~~~~~~~~~~~~~~~!!!!
    
    
    
    
    func fireEBeam() {
        
        //         missileTimer = NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: Selector("removeEBeam"), userInfo: nil, repeats: false)
        
        removeEBeam()
        
        energyBeam1.physicsBody = SKPhysicsBody(texture: eBeamTexture, size: CGSizeMake(400, 400)  )
        energyBeam1.position = playerShip.position
        energyBeam1.physicsBody?.allowsRotation = true
        energyBeam1.zPosition = 10
        energyBeam1.size = CGSizeMake(100, 400)
        energyBeam1.physicsBody?.collisionBitMask = 0
        energyBeam1.physicsBody?.contactTestBitMask = enemyCategory
        energyBeam1.physicsBody?.categoryBitMask = beamVortexCategory
        
        
        energyBeam2.physicsBody = SKPhysicsBody(texture: eBeamTexture, size: CGSizeMake(400, 400)  )
        energyBeam2.position = playerShip.position
        energyBeam2.physicsBody?.allowsRotation = true
        energyBeam2.zPosition = 10
        energyBeam2.size = CGSizeMake(100, 400)
        energyBeam2.physicsBody?.collisionBitMask = 0
        energyBeam2.physicsBody?.contactTestBitMask = enemyCategory
        energyBeam2.physicsBody?.categoryBitMask = beamVortexCategory
        
        energyBeam2.xScale = energyBeam2.xScale * -1
        energyBeam2.yScale = energyBeam2.yScale * -1
        energyBeam2
        
        addChild(energyBeam1)
        addChild(energyBeam2)
        
        energyBeam1.physicsBody?.affectedByGravity = false
        energyBeam2.physicsBody?.affectedByGravity = false
        
        
        energyBeam1.runAction(infiteSweep)
        energyBeam2.runAction(infiteSweep)
        
        energyBeam2.physicsBody?.applyImpulse(CGVectorMake(0, 300))
        energyBeam1.physicsBody?.applyImpulse(CGVectorMake(0, 300))
        
        //        delay(4, closure: { () -> () in
        //
        //            self.removeEBeam()
        //        })
        
        
        //        println("fireEBEEEEEEM")
        
    }
    
    
    
    //// -------> COLLISION SHIT ~~~~~~~~~~~~~
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody = contact.bodyA.node
        var secondBody = contact.bodyB.node
        
        var firstNode = contact.bodyA.categoryBitMask
        var secondNode = contact.bodyB.categoryBitMask
        
        
        if (firstNode == enemyCategory) && (secondNode == beamVortexCategory) {
            alienOneHealth = alienOneHealth - 1
            
           
            
            println(alienOneHealth)
            
            if alienOneHealth <= 0 {
                
                firstBody?.removeFromParent()
                secondBody?.removeFromParent()
                
            }
            
        }
        
        
        
        
        if (firstNode == enemyCategory) && (secondNode == chaingunWeaponCategory){
            
            alienOneHealth = alienOneHealth - chainDamage
            
            println(alienOneHealth)
            
            secondBody?.removeFromParent()
            
            if alienOneHealth <= 0 {
                
                let explosion = SKSpriteNode(imageNamed: "explosion2")
                explosion.position = firstBody!.position
                explosion.zPosition = 1
                
                secondBody?.removeFromParent()
                addChild(explosion)
                
                firstBody?.removeFromParent()
                
                delay(0.3, closure: { () -> () in
                    
                    explosion.removeFromParent()
                    
                })
            }
        }
        
        if (firstNode == enemyCategory) && (secondNode == missileCatgeory) {
            
            alienOneHealth = alienOneHealth - missileDamage
            
            secondBody?.removeFromParent()
            
            if alienOneHealth <= 0 {
                
                let explosion2 = SKSpriteNode(imageNamed: "explosion1")
                explosion2.position = firstBody!.position
                explosion2.zPosition = 1
                
                let explosion = SKSpriteNode(imageNamed: "explosion2")
                explosion.position = firstBody!.position
                explosion.zPosition = 1
                
                
                addChild(explosion)
                
                firstBody?.removeFromParent()
                secondBody?.removeFromParent()
                
                
                
                globalThrust.removeFromParent()
                
                delay(0.1, closure: { () -> () in
                    
                    self.addChild(explosion2)
                    
                })
                
                delay(0.45, closure: { () -> () in
                    
                    explosion2.removeFromParent()
                    
                })
                
                delay(0.3, closure: { () -> () in
                    
                    explosion.removeFromParent()
                    
                })
                
            }
        }
        
    }
    
    
    ///// ~~~~~~~~~~~~~~~~~~~~~~~~ collision shit ^^^
    
    
    
    
    
    ///// GUN CODE!!!!!!!!!!!!!!!!!!!!!!
    
    
    
    func fireChaingunRepeat() {
        
        chainDamage = 10
        
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
        chainGun.physicsBody?.categoryBitMask = chaingunWeaponCategory
        chainGun.physicsBody?.contactTestBitMask = enemyCategory
        //        chainGun.physicsBody?.collisionBitMask = 0
        
        addChild(chainGun)
        chainGun.physicsBody?.applyImpulse(CGVectorMake(0, 12))
        chainGun.physicsBody?.affectedByGravity = false
        chainGun.physicsBody?.collisionBitMask = 0  //change later
        //// chain gun
        
    }
    
    
    
    ///// MISSILE CODE ----!!!!!!!!!!!!!!!!!!!!!!
    
    
    
    func launchMissle() {
        
        missileDamage = 100
        
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
        missile1.physicsBody?.collisionBitMask = 0
        missile1.size = CGSizeMake(15, 55)
        missile1.physicsBody?.categoryBitMask = missileCatgeory
        missile1.physicsBody?.contactTestBitMask = enemyCategory
        //        missile1.physicsBody?.collisionBitMask = 0
        
        
        addChild(missile1)
        missile1.physicsBody?.affectedByGravity = false
        
        
        let thrust = SKSpriteNode(imageNamed: "thrust1")
        globalThrust = thrust

        
        thrust.size = CGSizeMake(15, 30)
        thrust.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(20, 50))
        thrust.zPosition = 25
        thrust.physicsBody?.collisionBitMask = 0
        
        
        missile1.physicsBody?.applyImpulse(CGVectorMake(3, -1.25))
        
        delay(0.5, closure: { () -> () in
            
            missile1.physicsBody?.applyImpulse(CGVectorMake(-3, 45))
            
            thrust.position = CGPoint(x: missile1.position.x, y: missile1.position.y - 45)
            self.addChild(thrust)
            thrust.physicsBody?.affectedByGravity = false
            thrust.physicsBody?.applyImpulse(CGVectorMake(0, 45))
            
            
        })
        
        
        
        updateMissileCount()
        
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
