//
//  GameScene.swift
//  SpaceGame
//
//  Created by Reed Carson on 6/26/15.
//  Copyright (c) 2015 Reed Carson. All rights reserved.
//

import SpriteKit
import AVFoundation

let playerShip = SKSpriteNode(imageNamed: "ship1")



class GameScene: SKScene {
    
    func initialGameState() {
        
        
        addChild(playerShip)
        
    }
    
    override func didMoveToView(view: SKView) {
        
        initialGameState()
        
        fireMissile = childNodeWithName("fireTwo") as? SKSpriteNode
        fireChaingun = childNodeWithName("fireOne") as? SKSpriteNode
        
        moveRight = childNodeWithName("moveRight") as? SKSpriteNode
        moveLeft = childNodeWithName("moveLeft") as? SKSpriteNode
        
        playerShip.position = CGPoint(x: frame.width / 2, y: frame.height / 4)
        playerShip.size = CGSize(width: 125, height: 150)
        playerShip.zPosition = 50
        
        backgroundColor = UIColor.blackColor()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            
            if moveRight .containsPoint(location) {
                
                playerShip.position.x = playerShip.position.x + 15
                
            }
            
            if moveLeft .containsPoint(location) {
                
                playerShip.position.x = playerShip.position.x - 15
                
            }
            
           
            if fireChaingun .containsPoint(location) {
                
                /// shells
                let shells = SKShapeNode(rectOfSize: CGSize(width: 8, height: 20))
//                let shellsPosition: CGPoint = CGPoint(x: 15, y: 30)
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
        
            if fireMissile .containsPoint(location) {
                
                let missile1 = SKSpriteNode(imageNamed: "missile1")
                missile1.position = CGPoint(x: playerShip.position.x + 35, y: playerShip.position.y - 30)
                missile1.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(20, 50))
                missile1.zPosition = 25
                
                missile1.size = CGSizeMake(15, 55)
                addChild(missile1)
                missile1.physicsBody?.affectedByGravity = false
                missile1.physicsBody?.applyImpulse(CGVectorMake(0, 20))
                
            }
        
        
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
