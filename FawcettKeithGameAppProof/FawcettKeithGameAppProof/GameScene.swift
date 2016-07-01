//
//  GameScene.swift
//  FawcettKeithGameAppProof
//
//  Created by Keith Fawcett on 6/29/16.
//  Copyright (c) 2016 Keith Fawcett. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  //creates background variable with the BG as it's image
  var background = SKSpriteNode(imageNamed: "BG")
  
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
      //centers the background
      background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
      //pushes the backqround behind the sprits
      background.zPosition = -1
      //adds the background to the scene
      addChild(background)
     
    }
  
  //when a touch begins
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
      let touch:UITouch = touches.first! as UITouch
      let positionInScene = touch.locationInNode(self)
      let touchedNode = self.nodeAtPoint(positionInScene)
      
      //let name be the touched nodes name
      if let name = touchedNode.name
      {
        //if it's one of the fruits
        if name == "pear" || name == "banana" || name == "watermelon" || name == "apple"
        {
          //play the beep sound
          self.runAction(SKAction.playSoundFileNamed("beep.wav", waitForCompletion: true))
        }
          //if it's the bomb
        else if name == "bomb"
        {
          //play the bomb sound
          self.runAction(SKAction.playSoundFileNamed("bomb.wav", waitForCompletion: true))
      }
    }
  }
  
  
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
