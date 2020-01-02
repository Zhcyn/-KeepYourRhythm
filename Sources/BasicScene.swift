import SpriteKit
private let kColorActionDuration = 7.0
class BasicScene: SKScene {
    var needBackgroundAnimate: Bool = false
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backgroundColor = SKColor.black
        self.isUserInteractionEnabled = true
        self.addNoteEmmiter()
    }
    func addNoteEmmiter() {
        let path = Bundle.main.path(forResource: "note_emmiter", ofType: "sks")
        let noteEmmiter = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        noteEmmiter.position = CGPoint(self.size.width/2, self.size.height/2.0)
        noteEmmiter.name = "note_emmiter"
        noteEmmiter.targetNode = self.scene
        self.addChild(noteEmmiter)
    }
    func startBackgroundColorAnimation() {
        self.needBackgroundAnimate = true
        self.changeBackgroundColor()
    }
    func changeBackgroundColor() {
        if !self.needBackgroundAnimate {
            return
        }
        let r = CGFloat(drand48()*0.2)
        let g = CGFloat(drand48()*0.2)
        let b = CGFloat(drand48()*0.2)
        let newColor = SKColor(red: r, green: g, blue: b, alpha: 1.0)
        let changeColorAction = SKAction.colorize(with: newColor, colorBlendFactor: 0.0, duration: kColorActionDuration)
        self.run(changeColorAction, completion: {
            self.call(block: {
                self.startBackgroundColorAnimation()
            }, after: kColorActionDuration)
        })
    }
    func call(block: @escaping () -> Void, after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
    }
}
