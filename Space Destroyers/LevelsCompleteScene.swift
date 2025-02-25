import SpriteKit

class LevelCompleteScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        let startGameButton = SKSpriteNode(imageNamed: "nextlevelbtn")
        startGameButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        startGameButton.name = "nextlevel"
        addChild(startGameButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if touchedNode.name == "nextlevel" {
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameScene, transition: transitionType)
        }
    }
}
