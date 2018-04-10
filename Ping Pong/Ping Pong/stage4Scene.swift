//
//  stage2Scene.swift
//  Ping Pong
//
//  Created by 新宮広輝 on 2017/01/23.
//  Copyright © 2017年 新宮広輝. All rights reserved.
//

import SpriteKit
import GameplayKit

class stage4Scene: SKScene, SKPhysicsContactDelegate {
    
    var star = SKSpriteNode()
    var ball = SKSpriteNode()
    var me = SKSpriteNode()
    var block = SKSpriteNode()
    
    private var pausePanel:SKSpriteNode?
    
    private var musicBtn:SKSpriteNode?
    private var musicOn = SKTexture(imageNamed: "speaker")
    private var musicOff = SKTexture(imageNamed: "notSpeaker")
    
    
    override func didMove(to view: SKView) {
        
        //        これが衝突した時のすべての判断をするcontactで一番大事
        self.physicsWorld.contactDelegate = self
        
        musicBtn = self.childNode(withName: "music") as! SKSpriteNode?
        
        star =  self.childNode(withName: "star") as! SKSpriteNode
        //        star.physicsBody = SKPhysicsBody()
        star.physicsBody?.affectedByGravity = false
        star.physicsBody?.allowsRotation = false
        star.physicsBody?.isDynamic = false
        //        star.physicsBody?.categoryBitMask = ColliderType.star
        star.physicsBody?.contactTestBitMask = ColliderType.star
        star.physicsBody?.collisionBitMask = ColliderType.star
        star.name = "star"
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        //        ball.physicsBody = SKPhysicsBody()
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.isDynamic = true
        //        ball.physicsBody?.categoryBitMask = ColliderType.ball
        ball.physicsBody?.contactTestBitMask = ColliderType.ball
        ball.physicsBody?.collisionBitMask = ColliderType.ball
        ball.name = "ball"
        
//        ブロックの定義
//        block = self.childNode(withName: "block") as! SKSpriteNode
//        block.physicsBody?.affectedByGravity = false
//        block.physicsBody?.friction = 0
//        block.physicsBody?.restitution = 1
//        block.physicsBody?.isDynamic = false
//        block.physicsBody?.contactTestBitMask = ColliderType.block
//        block.physicsBody?.collisionBitMask = ColliderType.block
//        block.name = "block"
        
        me = self.childNode(withName: "me") as! SKSpriteNode
        me.position.y = (-self.frame.height / 2) + 50
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        startGame()
        
        if AudioManager.instance.isMusicOn == true{
            musicBtn?.texture = SKTexture(imageNamed: "speaker.png")
        }else{
            musicBtn?.texture = SKTexture(imageNamed: "notSpeaker.png")
            AudioManager.instance.stopBGM()
            
        }
        
        
        
    }
    
    func startGame(){
        ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            me.run(SKAction.moveTo(x: location.x, duration: 0.2))
            
            if atPoint(location) == musicBtn{
                setMusic()
            }
            
            if atPoint(location).name == "pause" {
                createPausePanel()
                self.isPaused = true
            }
            if atPoint(location).name == "resume" {
                pausePanel?.removeFromParent()
                self.isPaused = false
            }
            if atPoint(location).name == "quit" {
                let scene = MainMenuScene(fileNamed: "MainMenu")
                scene!.scaleMode = .aspectFill
                
                self.view?.presentScene(scene!, transition: SKTransition.doorway(withDuration: 1))
            }
            //            meをタッチしたら上に上がる
            if atPoint(location).name == "me" {
                me.run(SKAction.moveTo(y: (-self.frame.height / 2) + 90, duration: 0.1))
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        上に上がったmeが元に戻ってくる
        me.position.y = (-self.frame.height / 2) + 50

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            me.run(SKAction.moveTo(x: location.x, duration: 0.2))
            
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "ball" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "ball" && secondBody.node?.name == "star" {
            //        if firstBody.contactTestBitMask == 1 && secondBody.contactTestBitMask == 2 {
            secondBody.node?.removeFromParent()
            //            ステージ２に移動する
            let scene = stage5Scene(fileNamed: "stage5")
            scene?.scaleMode = .aspectFill
            self.view?.presentScene(scene!, transition: SKTransition.doorway(withDuration: 1))
            
            //            star.removeFromParent()
            //            self.scene?.isPaused = true
        } else if firstBody.node?.name == "ball" && secondBody.node?.name == "border" {
            
        } else if firstBody.node?.name == "ball" && secondBody.node?.name == "block"{
            //            block.removeFromParent()
            secondBody.node?.removeFromParent()
        }
    }
    
    func createPausePanel(){
        
        pausePanel = SKSpriteNode(imageNamed: "hukidasi")
        let resumeBtn = SKSpriteNode(imageNamed: "resume")
        let quitBtn = SKSpriteNode(imageNamed: "quit")
        
        pausePanel?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pausePanel?.xScale = 1.6
        pausePanel?.yScale = 1.6
        pausePanel?.zPosition = 4
        pausePanel?.position = CGPoint(x: 0, y: 0)
        
        resumeBtn.name = "resume"
        resumeBtn.zPosition = 5
        resumeBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        resumeBtn.position = CGPoint(x: (pausePanel?.position.x)!, y: (pausePanel?.position.y)! + 65)
        
        quitBtn.name = "quit"
        quitBtn.zPosition = 5
        quitBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quitBtn.position = CGPoint(x: (pausePanel?.position.x)!, y: (pausePanel?.position.y)! + 10)
        
        pausePanel?.addChild(resumeBtn)
        pausePanel?.addChild(quitBtn)
        
        self.addChild(pausePanel!)
        
    }
    
    
    
    private func setMusic(){
        
        if AudioManager.instance.isMusicOn == false{
            AudioManager.instance.play1BGM()
            musicBtn?.texture = musicOn
        }else{
            AudioManager.instance.stopBGM()
            musicBtn?.texture = musicOff
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //        ボールがmeの下に来た時て負けてMainMenuに行く
        if ball.position.y <= me.position.y - 20 {
            
            let scene = MainMenuScene(fileNamed: "MainMenu")
            scene!.scaleMode = .aspectFill
            
            self.view?.presentScene(scene!, transition: SKTransition.fade(withDuration: 1))
            
        }
        
    }
    
    
}






















