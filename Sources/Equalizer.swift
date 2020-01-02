import SpriteKit
private let kLineWidth: CGFloat = 5.5
private let kDefaultLineHeight: CGFloat = 1.0
private let kPulseEpsilon: CGFloat = 11.0
private let kAnimationDuration: TimeInterval = 0.2
final class Equalizer: SKSpriteNode {
    var lines: NSMutableArray = NSMutableArray()
    var needRandPulsing: Bool = false
    init(size: CGSize, color: SKColor) {
        super.init(texture: nil, color: SKColor.clear, size: size)
        self.anchorPoint = kLeftCenterAnchor
        self.setupContentsAndAnimation(color: color)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupContentsAndAnimation(color: SKColor) {
        let linesNumber = Int((self.frame.width/kLineWidth)/2.2)
        let linesInsets = (self.frame.width - CGFloat(linesNumber)*kLineWidth)/CGFloat(linesNumber - 1) + kLineWidth
        for i in 0...linesNumber - 1 {
            let line = self.line()
            line.fillColor = color
            line.position = CGPoint(CGFloat(i)*linesInsets + kLineWidth/2.0, 0.0)
            self.addChild(line)
            self.lines.add(line)
        }
    }
    func line() -> SKShapeNode {
        let line = SKShapeNode(rectOf: CGSize(kLineWidth, self.frame.height))
        let scaleCoeff = kDefaultLineHeight/self.frame.height
        line.run(SKAction.scaleY(to: scaleCoeff, duration: 0.0))
        return line
    }
    func pulseDifference() -> CGFloat {
        let lineNumber = self.lines.count
        if lineNumber == 0 {
            return 0.0
        }
        let halfNumber: Int = Int(CGFloat(lineNumber)/2.2)
        let midDifferenceValue = self.frame.height/CGFloat(halfNumber)
        return midDifferenceValue
    }
    func randPulseDifference() -> CGFloat {
        let min = self.pulseDifference() - kPulseEpsilon
        let max = self.pulseDifference() + kPulseEpsilon
        let difference = CGFloat(drand48())*(max - min) + min
        return (difference > 0) ? difference : 0
    }
    func startRandomPulsing() {
        needRandPulsing = true
        self.startPulsing()
    }
    func stopRandomPulsing() {
        self.needRandPulsing = false
    }
    func startPulsing() {
        if !needRandPulsing {
            return
        }
        let delay: TimeInterval = drand48()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.startPulsing()
        }
        self.pulse()
    }
    func pulse() {
        let lineNumber = self.lines.count
        if lineNumber == 0 {
            return
        }
        let halfNumber: Int = lineNumber - Int(CGFloat(lineNumber)/2.0)
        for i in 0...lineNumber - 1 {
            let line: SKShapeNode = self.lines.object(at: i) as! SKShapeNode
            line.removeAllActions()
            var linePosition = i + 1
            if linePosition > halfNumber {
                linePosition = lineNumber - i
            }
            var lineHeight = CGFloat(linePosition)*self.randPulseDifference()
            lineHeight = lineHeight > kDefaultLineHeight ? lineHeight : kDefaultLineHeight
            let startScaleCoeff = lineHeight/self.frame.height
            let endScaleCoeff = kDefaultLineHeight/self.frame.height
            let stretchAction = SKAction.scaleY(to: startScaleCoeff, duration: kAnimationDuration)
            stretchAction.timingMode = SKActionTimingMode.easeOut
            let constrictAction = SKAction.scaleY(to: endScaleCoeff, duration: kAnimationDuration)
            constrictAction.timingMode = SKActionTimingMode.easeIn
            let sequence = SKAction.sequence([stretchAction,constrictAction])
            line.run(sequence)
        }
    }
}
