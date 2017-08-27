//
//  GameScene.swift
//  Ping Pong
//
//  Created by 新宮広輝 on 2017/01/21.
//  Copyright © 2017年 新宮広輝. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    private var pausePanel:SKSpriteNode?
    
    
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var me = SKSpriteNode()
    
    var topLabel = SKLabelNode()
    var btmLabel = SKLabelNode()
    
    var score = [Int]()
    
    private var musicBtn:SKSpriteNode?
    private var musicOn = SKTexture(imageNamed: "speaker")
    private var musicOff = SKTexture(imageNamed: "notSpeaker")
    
    override func didMove(to view: SKView) {
        
        musicBtn = self.childNode(withName: "music") as! SKSpriteNode?
        
        topLabel = self.childNode(withName: "topLabel") as! SKLabelNode
        
        btmLabel = self.childNode(withName: "btmLabel") as! SKLabelNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 50
        
            
        me = self.childNode(withName: "me") as! SKSpriteNode
        me.position.y = (-self.frame.height / 2) + 50
        
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        startGame()
        
//        AudioManager.instance.stopBGM()
        if AudioManager.instance.isMusicOn == true{
            musicBtn?.texture = SKTexture(imageNamed: "speaker.png")
        }else{
            musicBtn?.texture = SKTexture(imageNamed: "notSpeaker.png")
            AudioManager.instance.stopBGM()
        }
    }
    
    
    
    
    func startGame(){
        
        score = [0,0]
        
        topLabel.text = "\(score[1])"
        btmLabel.text = "\(score[0])"
        ball.physicsBody?.applyImpulse(CGVector(dx: 22, dy: 20))

        
    }
    
    func addScore(playerWhoWon : SKSpriteNode){
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 5, dy: 5)
        
        if playerWhoWon == me {
            
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 22, dy: 20))
            
        }else if playerWhoWon == enemy {
            
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -22, dy: -20))

            
        }
        
        topLabel.text = "\(score[1])"
        btmLabel.text = "\(score[0])"
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    
                }
                if location.y < 0 {
                    
                    me.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            } else {
                me.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        
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
        
//            タッチしたら動く設定
            if atPoint(location).name == "me" {
                me.run(SKAction.moveTo(y: (-self.frame.height / 2) + 80, duration: 0.1))
            }
            
            if currentGameType == .player2{
                if atPoint(location).name == "enemy" {
                    enemy.run(SKAction.moveTo(y: (self.frame.height / 2) - 80, duration: 0.1))
                }
            }
            
        }
            
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        me.position.y = (-self.frame.height / 2) + 50
        enemy.position.y = self.frame.height / 2 + 50

    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    me.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            } else {
                me.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        switch currentGameType {
            
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.27))
            break
            
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.24))
            break
            
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
            break
            
        case .player2:
            
            break
        }
        
        if ball.position.y <= me.position.y - 20 {
            
            addScore(playerWhoWon: enemy)
            
            
        }else if ball.position.y >= enemy.position.y + 20 {
            
            addScore(playerWhoWon: me)
            
        }
    
    }
    
    
    private func setMusic(){
            
        if AudioManager.instance.isMusicOn == false {
            AudioManager.instance.playBGM()
            musicBtn?.texture = musicOn
        }else{
            AudioManager.instance.stopBGM()
            musicBtn?.texture = musicOff
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
    
    
    
}


































