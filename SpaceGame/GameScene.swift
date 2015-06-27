//
//  GameScene.swift
//  SpaceGame
//
//  Created by Reed Carson on 6/26/15.
//  Copyright (c) 2015 Reed Carson. All rights reserved.
//

import SpriteKit

let playerShip = SKSpriteNode(imageNamed: "ship1")



class GameScene: SKScene {
    
    
    
    override func didMoveToView(view: SKView) {
        
        //        var backgroundImage = SKSpriteNode(imageNamed: "space2")
        //
        //        backgroundImage.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        playerShip.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        playerShip.size = CGSize(width: 100, height: 100)
        
        addChild(playerShip)
        
        backgroundColor = UIColor.blackColor()
        
        //        initialGameState()
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>) {
            

            /// shells
            let shells = SKShapeNode(rectOfSize: CGSize(width: 8, height: 20))
            let shellsPosition: CGPoint = CGPoint(x: 15, y: 30)
            shells.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(8, 20))
            shells.physicsBody?.allowsRotation = true
            shells.fillColor = UIColor.yellowColor()
//   shells.position = CGPoint(x: (frame.width / 2) + 15, y: (frame.height / 2) + 30)
            
            shells.position = playerShip.position
            
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
            //            chainGun.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addChild(chainGun)
            chainGun.physicsBody?.applyImpulse(CGVectorMake(0, 12))
            chainGun.physicsBody?.affectedByGravity = false
            chainGun.physicsBody?.collisionBitMask = 0  //change later
            //// chain gun
            
        }
        
    }
    
    //    func initialGameState() {
    //
    ////        let playerShip = SKSpriteNode(imageNamed: "ship1")
    ////
    ////        playerShip.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
    ////
    ////       playerShip.size = CGSize(width: 100, height: 100)
    ////
    ////        addChild(playerShip)
    //    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
