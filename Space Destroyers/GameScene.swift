import UIKit
import SpriteKit
import GameplayKit


var levelNum = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    let rowsOfInvaders = 4
    var invaderSpeed = 2
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(500)
    var invadersWhoCanFire: [Invader] = []
    let player: Player = Player()
    let maxLevels = 3
    
//    extension Array {
//        func randomElement() -> Element? {
//            return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(count)))]
//        }
//    }

    
    // MARK: - Invader Methods
    func invokeInvaderFire() {
        let fireBullet = SKAction.run { [weak self] in
            self?.fireInvaderBullet()
        }
        let waitToFireInvaderBullet = SKAction.wait(forDuration: 1.5)
        let invaderFire = SKAction.sequence([fireBullet, waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatForever(invaderFire)
        run(repeatForeverAction)
    }

    func fireInvaderBullet() {
        if invadersWhoCanFire.isEmpty {
            levelNum += 1
            // Logic to handle level completion
        } else {
            let randomInvader = invadersWhoCanFire.randomElement()
            randomInvader?.fireBullet(scene: self)
        }
    }


    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        setupInvaders()
        setupPlayer()
        invokeInvaderFire()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
    }



    // MARK: - Invader Methods
    func setupInvaders() {
        var invaderRow = 0
        var invaderColumn = 0
        let numberOfInvaders = levelNum * 2 + 1
        for i in 1...rowsOfInvaders {
            invaderRow = i
            for j in 1...numberOfInvaders {
                invaderColumn = j
                let tempInvader = Invader()
                let invaderHalfWidth = tempInvader.size.width / 2
                let xPositionStart = size.width / 2 - invaderHalfWidth - (CGFloat(levelNum) * tempInvader.size.width) + CGFloat(10)
                tempInvader.position = CGPoint(x: xPositionStart + ((tempInvader.size.width + CGFloat(10)) * (CGFloat(j - 1))),
                                               y: CGFloat(self.size.height - CGFloat(i) * 46))
                tempInvader.invaderRow = invaderRow
                tempInvader.invaderColumn = invaderColumn
                addChild(tempInvader)
                if i == rowsOfInvaders {
                    invadersWhoCanFire.append(tempInvader)
                }
            }
        }
    }

//    func invokeInvaderFire() {
//        let fireBullet = SKAction.run { [weak self] in
//            self?.fireInvaderBullet()
//        }
//        let waitToFireInvaderBullet = SKAction.wait(forDuration: 1.5)
//        let invaderFire = SKAction.sequence([fireBullet, waitToFireInvaderBullet])
//        let repeatForeverAction = SKAction.repeatForever(invaderFire)
//        run(repeatForeverAction)
//    }

//    func fireInvaderBullet() {
//        if invadersWhoCanFire.isEmpty {
//            levelNum += 1
//        } else {
//            let randomInvader = invadersWhoCanFire.randomElement()
//            randomInvader?.fireBullet(scene: self)
//        }
//    }

    // MARK: - Player Methods
    func setupPlayer() {
        player.position = CGPoint(x: self.frame.midX, y: player.size.height / 2 + 10)
        addChild(player)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.fireBullet(scene: self)
    }

    // MARK: - Invader Movement
    func moveInvaders() {
        var changeDirection = false
        enumerateChildNodes(withName: "invader") { node, stop in
            let invader = node as! SKSpriteNode
            let invaderHalfWidth = invader.size.width / 2
            invader.position.x -= CGFloat(self.invaderSpeed)
            if invader.position.x > self.rightBounds - invaderHalfWidth || invader.position.x < self.leftBounds + invaderHalfWidth {
                changeDirection = true
            }
        }
        if changeDirection {
            self.invaderSpeed *= -1
            enumerateChildNodes(withName: "invader") { node, stop in
                let invader = node as! SKSpriteNode
                invader.position.y -= CGFloat(46)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        moveInvaders()
    }
    
    
    // MARK: - Implementing SKPhysicsContactDelegate protocol
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0)) {
            if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
                return
            }
            
            let theInvader = firstBody.node as! Invader
            let invaderIndex = invadersWhoCanFire.firstIndex(of: theInvader)
            if invaderIndex != nil {
                invadersWhoCanFire.remove(at: invaderIndex!)
            }
            theInvader.removeFromParent()
            secondBody.node?.removeFromParent()
        }

        if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0)) {
            player.die()
        }

        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Player != 0)) {
            player.kill()
        }
    }

    
    

    
    
}

extension Array {
    func randomElement() -> Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(count)))]
    }
}

