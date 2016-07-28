//
//  GameScene.swift
//  FawcettKeithGameAppGold
//
//  Created by Keith Fawcett on 6/29/16.
//  Copyright (c) 2016 Keith Fawcett. All rights reserved.
//

import SpriteKit
import AVFoundation

//create the masks for the different collision elements
let floorMask:UInt32 = 0x1 << 0
let fruitMask:UInt32 = 0x1 << 1
let bombMask:UInt32 = 0x1 << 2


class GameScene: SKScene, SKPhysicsContactDelegate {
  
  
  //create the variable for the launch emitters
  var launcher1: SKEmitterNode!
  var launcher2: SKEmitterNode!
  var launcher3: SKEmitterNode!
  var launcher4: SKEmitterNode!
  
  //create the variables for the hearts
  var heart1: SKSpriteNode!
  var heart2: SKSpriteNode!
  var heart3: SKSpriteNode!
  
  //create explotion variable
  var explotion: SKSpriteNode!
  
  //create animated atlas variables
  var textureAtlas = SKTextureAtlas()
  var textureArray = [SKTexture]()
  
  //connect win loss labels to code
  var winLoss: SKLabelNode!
  var playAgain: SKLabelNode!
  var finalScoreLabel: SKLabelNode!
  var menu: SKLabelNode!
  
  //is the game currently being played
  var playingGame = true
  
  //create the score and multiplier labels
  var scoreLabel: SKLabelNode!
  var multiplierLabel: SKLabelNode!
  var timerLabel: SKLabelNode!
  
  //create the variables to keep track of the score
  var score = 0
  var multiplier = 1
  var fruitInARow = 0
  
  var interval = 2.0
  
  //number of lifes variable
  var lifes = 3
  
  //countdown timer
  var time = 60
  var timer = NSTimer()
  
  var sounds = []
  //creates background variable with the BG as it's image
  var background = SKSpriteNode(imageNamed: "BG")
  
  
  
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
      
      //scale the scene to the device size
     // scene!.scaleMode = SKSceneScaleMode.Fill
      
      //preload the sound elements
      do {
         sounds = ["bomb", "beep","powerup","powerdown"]
        for sound in sounds{
          let player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound as? String, ofType: "wav")!))
          player.prepareToPlay()
        }
      }catch{
        
      }
      self.physicsWorld.contactDelegate = self

      
      //centers the background
      background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
      //pushes the backqround behind the sprits
      background.zPosition = -1
      //adds the background to the scene
      addChild(background)
      
      //setup the score and multiplier labels
      scoreLabel = self.childNodeWithName("ScoreLabel") as! SKLabelNode
      multiplierLabel = self.childNodeWithName("Multiplier") as! SKLabelNode
      multiplierLabel.text = "X" + String(multiplier)
      timerLabel = self.childNodeWithName("timeLabel") as! SKLabelNode
      timerLabel.text = String(time)
      
      //setup the ending labels and hid them
      winLoss = self.childNodeWithName("winLoss") as! SKLabelNode
      winLoss.hidden = true
      
      finalScoreLabel = self.childNodeWithName("finalScoreLabel") as! SKLabelNode
      finalScoreLabel.hidden = true
      
      playAgain = self.childNodeWithName("playAgain") as! SKLabelNode
      playAgain.hidden = true
      
      menu = self.childNodeWithName("menu") as! SKLabelNode
      menu.hidden = true
     
      //connect the launchers in code with the scene
      launcher1 = self.childNodeWithName("launcher1") as! SKEmitterNode
      launcher2 = self.childNodeWithName("launcher2") as! SKEmitterNode
      launcher3 = self.childNodeWithName("launcher3") as! SKEmitterNode
      launcher4 = self.childNodeWithName("launcher4") as! SKEmitterNode
      
      //connect the hearts in code with the scene
      heart1 = self.childNodeWithName("heart1") as! SKSpriteNode
      heart2 = self.childNodeWithName("heart2") as! SKSpriteNode
      heart3 = self.childNodeWithName("heart3") as! SKSpriteNode
      
      
      
      
      textureAtlas = SKTextureAtlas(named: "explotion")
      
      //order the textureAtlas
      for i in 1...textureAtlas.textureNames.count{
        let name = "\(i).png"
        textureArray.append(SKTexture(imageNamed: name))
        
      }
    //start the explotion at the first image
      explotion = SKSpriteNode(imageNamed: textureAtlas.textureNames[0] )
      
      //set the size and add it to the screen
      explotion.size = CGSize(width: 170, height: 170)
      explotion.position = CGPoint(x: -50, y:0)
      self.addChild(explotion)
      
      
      //run the timer
      runTimer()
      //create the countdown timer
      timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
    }
  //subtract from the timerLabel 1
  func update() {
    time -= 1
      timerLabel.text = String(time)
    }
  
  //create a timer that fires the items
  func runTimer(){
    _ = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(GameScene.launchItem), userInfo: nil, repeats: false)
  }
  
  
  
  //launch the items function to reset the timer and launch a item
  func launchItem(){
    if scene?.view?.paused == false{
    runTimer()
    }
    interval = ((Double(arc4random_uniform(21))/9))
    
    //connect the sprits in code with the scene
    let bomb: SKSpriteNode = SKScene(fileNamed: "Bomb")!.childNodeWithName("bomb")! as! SKSpriteNode
    let watermelon: SKSpriteNode = SKScene(fileNamed: "Watermelon")!.childNodeWithName("watermelon")! as! SKSpriteNode
    let banana: SKSpriteNode = SKScene(fileNamed: "Banana")!.childNodeWithName("banana")! as! SKSpriteNode
    let pear: SKSpriteNode = SKScene(fileNamed: "Pear")!.childNodeWithName("pear")! as! SKSpriteNode
    let apple: SKSpriteNode = SKScene(fileNamed: "Apple")!.childNodeWithName("apple")! as! SKSpriteNode
    
    //generate a random number to choose the item launched
    let itemSelect = arc4random_uniform(5)
    
    //create the item variable
    var item = bomb
    
   
    if itemSelect == 0{ //if the number was 0 launch a bomb
      item = bomb
    }else if itemSelect == 1{ //if the number was 1 launch a watermelon
      item = watermelon
    }else if itemSelect == 2{ //if the number was 2 launch a banana
      item = banana
    }else if itemSelect == 3{ //if the number was 3 launch a pear
      item = pear
    }else if itemSelect == 4{ //if the number was 4 launch a apple
      item = apple
    }
    
    
    item.removeFromParent()
    self.addChild(item)
    item.zPosition = 0
    
    //generate random number to pick which emmiter the item will launch from
    let chooseLauncher = arc4random_uniform(4)
    
    if chooseLauncher == 0{ //if it's a 0 launch from launcher 1
    item.position = launcher1.position
    }else if chooseLauncher == 1{ //if it's a 1 launch from launcher 2
      item.position = launcher2.position
    }else if chooseLauncher == 2{ //if it's a 2 launch from launcher 3
      item.position = launcher3.position
    }else if chooseLauncher == 3{ //if it's a 3 launch from launcher 4
      item.position = launcher4.position
    }
    //launch at a random x between -200 and 200 and a y of 400
    item.physicsBody?.applyImpulse(CGVectorMake((CGFloat(arc4random_uniform(5)) * 100) - 200, 400))
    
    item.physicsBody?.collisionBitMask = floorMask | fruitMask | bombMask
    item.physicsBody?.contactTestBitMask = (item.physicsBody?.collisionBitMask)!
    
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
        //if it's one of the fruits and we are playing the game
        if name == "pear" && playingGame || name == "apple" && playingGame || name == "watermelon" && playingGame || name == "banana" && playingGame
        {
          //play the beep sound
          self.runAction(SKAction.playSoundFileNamed(sounds[1] as! String, waitForCompletion: true))
          if name == "pear"{ //if a pear is taped add 5 points to the score
            score += 5 * multiplier
        }else if name == "apple"{ //if a apple is taped add 10 points to the score
            score += 10 * multiplier
          }else if name == "watermelon"{ //if a watermelon is taped add 15 points to the score
            score += 15 * multiplier
          }else if name == "banana"{ //if a banana is taped add 20 points to the score
            score += 20 * multiplier
          }
          //add one to fruitInARow
          fruitInARow += 1
          //if fruitInARow is 5, 15, or 40
          if fruitInARow == 5 || fruitInARow == 15 || fruitInARow == 40{
            //play the powerup sound
            self.runAction(SKAction.playSoundFileNamed(sounds[2] as! String, waitForCompletion: true))
          }
          //remove the taped fruit
          touchedNode.removeFromParent()
        }
          //if it's the bomb and we are playing the game
        else if name == "bomb" && playingGame
        {
          //subtract 100 from score and reset the multiplier
          lifes -= 1
          score -= 100
          fruitInARow = 0
          multiplier = 1
          
          //run the explotion
          explotion.position = CGPoint(x: touchedNode.position.x, y: touchedNode.position.y)
          explotion.runAction(SKAction.animateWithTextures(textureArray, timePerFrame: 0.01))
          
          
          if lifes == 2{ //if you have 2 lives
            heart3.hidden = true //hide the 3 heart
          }else if lifes == 1{ //if you have 1 life
            heart2.hidden = true //hide the 2 heart
          }else if lifes == 0 { //if you have 0 lifes
            heart1.hidden = true //hide the 1 heart
            //display the end game labels and stop the timer
            winLoss.hidden = false
            winLoss.text = "You loss"
            playAgain.hidden = false
            menu.hidden = false
            playingGame = false
            timer.invalidate()
          }
          //play the bomb sound
          self.runAction(SKAction.playSoundFileNamed(sounds[0] as! String, waitForCompletion: true))
          touchedNode.removeFromParent()
          //if the pause button is press and we are playing the game
        }else if name == "pause" && playingGame{
          
          //if it is not paused pause the scene
          if scene?.view?.paused == false{
            scene?.view?.paused = true
            scene?.physicsWorld.speed = 0
            timer.invalidate()
            
          //if it is paused unpause the scene
          }else if scene?.view?.paused == true{
           scene?.view?.paused = false
            scene?.physicsWorld.speed = 1
            //start the timer again
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
            launchItem()
          }
          //when the playAgain label is pressed
        }else if name == "playAgain"{
          //reset everything to start the game over
          score = 0
          time = 60
          multiplier = 1
          fruitInARow = 0
          lifes = 3
          playingGame = true
          winLoss.hidden = true
          finalScoreLabel.hidden = true
          playAgain.hidden = true
          menu.hidden = true
          heart1.hidden = false
          heart2.hidden = false
          heart3.hidden = false
          timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
        }else if name == "menu"{
          let myScene = MainMenuScreen(fileNamed: "MainMenuScreen")
          myScene!.scaleMode = scaleMode
          let reveal = SKTransition.fadeWithDuration(1.0)
          self.view?.presentScene(myScene!, transition: reveal)
        }
        
    }
  }
  
  
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
      //set the scor lable to the score
      scoreLabel.text = String(score)
      //set the multiplier label to the multiplier adding an x in front of it
      multiplierLabel.text = "X" + String(multiplier)
      if fruitInARow > 39{
        multiplier = 8 //if fruit is over 39 set multiplier to 8
      }else if fruitInARow > 14{
        multiplier = 4 //if fruit is over 14 set multiplier to 4
      }else if fruitInARow > 4{
        multiplier = 2 //if fruit is over 4 set multiplier to 2
      }
      //when the timer runs out
      if time == 0{
        //stop everything display they won and their score
        timer.invalidate()
        winLoss.text = "You win"
        winLoss.hidden = false
        finalScoreLabel.text = "Your score is \(score)"
        finalScoreLabel.hidden = false
        playingGame = false
        playAgain.hidden = false
        menu.hidden = false
        
      }
    }

  //when a contact begins
  func didBeginContact(contact: SKPhysicsContact) {
    //check what is hitting what
    let item = (contact.bodyA.categoryBitMask == fruitMask) ? contact.bodyA : contact.bodyB
    let other = (item == contact.bodyA) ? contact.bodyB : contact.bodyA
  
    if other.categoryBitMask == floorMask{
      
      //if a fruit hits the floor
      if item.categoryBitMask == fruitMask{
        //if the fruitInARow is over 4
        if fruitInARow > 4{
          //reset the fruitInARow and the multiplier and play the sound
          fruitInARow = 0
          multiplier = 1
          self.runAction(SKAction.playSoundFileNamed(sounds[2] as! String, waitForCompletion: true))
        }else{
          //otherwise just reset the fruitInARow and the multiplier
        fruitInARow = 0
        multiplier = 1
      }
      }
      //remove the item that hit the ground
      item.node?.removeFromParent()
    }
  }

}

















