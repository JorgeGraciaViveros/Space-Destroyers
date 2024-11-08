import UIKit
import SpriteKit
import GameplayKit


class StartGameScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        print("StartGameScene didMove called") // Debugging
        
        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        startGameButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        startGameButton.name = "startgame"
        startGameButton.zPosition = 1  // Ensures button is on top of other nodes
        addChild(startGameButton)
        
        print("Start game button added at position: \(startGameButton.position)") // Debugging
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        print("Touch detected at: \(touchLocation)") // Debugging
        
        let touchedNode = self.atPoint(touchLocation)
        print("Touched node: \(String(describing: touchedNode.name))") // Debugging
        
        if touchedNode.name == "startgame" {
            print("Start game button touched") // Debugging
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameScene, transition: transitionType)
        }
    }
}
