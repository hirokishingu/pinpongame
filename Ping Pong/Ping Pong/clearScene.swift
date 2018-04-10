//
//  clearScene.swift
//  Ping Pong
//
//  Created by 新宮広輝 on 2017/01/24.
//  Copyright © 2017年 新宮広輝. All rights reserved.
//


import SpriteKit
import GameplayKit


class clearScene: SKScene {
 
    private var createPanel:SKSpriteNode?
    
    
    
    override func didMove(to view: SKView) {
        
        AudioManager.instance.stopBGM()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "goMenu" {
                let scene = MainMenuScene(fileNamed: "MainMenu")
                scene!.scaleMode = .aspectFill
                
                self.view?.presentScene(scene!, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
            }
            
        }
        
    }
    
    
    
    
}




















