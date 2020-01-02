import SpriteKit
class RoundNode: SKSpriteNode {
    var round: Int
    var winScore: CGFloat
    var roundLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    init(round: Int, winScore: CGFloat, size: CGSize) {
        self.round = round
        self.winScore = winScore
        super.init(texture: nil, color: SKColor.red, size: size)
        self.setupContents()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupContents(){
        roundLabel = SKLabelNode(text: "Round \(self.round)")
        roundLabel.fontName = "Wawati SC"
        roundLabel.fontSize = isPhone ? 55.0 : 90.0
        roundLabel.position = CGPoint(0, 0)
        self.addChild(roundLabel)
        scoreLabel = SKLabelNode(text: "get \(Int(self.winScore))+ score")
        scoreLabel.fontName = "Wawati SC"
        scoreLabel.fontSize = isPhone ? 25.0 : 40.0
        scoreLabel.position = CGPoint(0, -roundLabel.frame.height - 10.0)
        self.addChild(scoreLabel)
    }
    func updateWithRound(round: Int, winScore: CGFloat){
        self.winScore = winScore
        self.round = round
        self.scoreLabel.text = "get \(Int(self.winScore))+ score"
        self.roundLabel.text = "Round \(self.round)"
    }
}
