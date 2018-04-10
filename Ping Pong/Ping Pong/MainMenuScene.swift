//
//  MainMenuScene.swift
//  Ping Pong
//
//  Created by 新宮広輝 on 2017/01/22.
//  Copyright © 2017年 新宮広輝. All rights reserved.
//

import SpriteKit

enum gameType {
    case easy
    case medium
    case hard
    case player2
}

class MainMenuScene: SKScene {
    
    
    var player2Btn:SKLabelNode?
    var easyBtn:SKLabelNode?
    var mediumBtn:SKLabelNode?
    var hardBtn:SKLabelNode?
    var stageBtn:SKLabelNode?
    
    private var musicBtn:SKSpriteNode?
    private var musicOn = SKTexture(imageNamed: "speaker")
    private var musicOff = SKTexture(imageNamed: "notSpeaker")
    
    
    override func didMove(to view: SKView) {
        
        musicBtn = self.childNode(withName: "music") as! SKSpriteNode?

        
        player2Btn = self.childNode(withName: "player2") as! SKLabelNode?
        easyBtn = self.childNode(withName: "easy") as! SKLabelNode?
        mediumBtn = self.childNode(withName: "medium") as! SKLabelNode?
        hardBtn = self.childNode(withName: "hard") as! SKLabelNode?
        stageBtn = self.childNode(withName: "stage") as! SKLabelNode?
        
        if AudioManager.instance.isMusicOn == true{
            musicBtn?.texture = SKTexture(imageNamed: "speaker.png")
        }else{
            musicBtn?.texture = SKTexture(imageNamed: "notSpeaker.png")
            AudioManager.instance.stopBGM()
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location) == player2Btn {
                let scene = GameScene(fileNamed: "GameScene")
                moveToGame(game: .player2)
                scene!.scaleMode = .aspectFill
                
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1))
            }
            if atPoint(location) == easyBtn {
                let scene = GameScene(fileNamed: "GameScene")
                moveToGame(game: .easy)
                scene!.scaleMode = .aspectFill
                
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1))
            }
            if atPoint(location) == mediumBtn {
                let scene = GameScene(fileNamed: "GameScene")
                moveToGame(game: .medium)
                scene!.scaleMode = .aspectFill
                
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1))
            }
            if atPoint(location) == hardBtn {
                let scene = GameScene(fileNamed: "GameScene")
                moveToGame(game: .hard)
                scene!.scaleMode = .aspectFill
                
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseVertical(withDuration: 1))
            }
            if atPoint(location) == stageBtn {
                let scene = stage1Scene(fileNamed: "stage1")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.fade(withDuration: 1))
            }
            if atPoint(location) == musicBtn{
                setMusic()
            }
            
            
        }
        
    }
    
    func moveToGame(game : gameType){
        
//        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        currentGameType = game
        
//        self.navigationController?.pushViewController(gameVC, animated: true)
        
        
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
    
    
}





















