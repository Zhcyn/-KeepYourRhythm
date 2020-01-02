import SpriteKit
private let kSelectedOpacity: CGFloat = 0.5
class Button: SKSpriteNode {
    private(set) var isSelected: Bool = false
    var isEnabled: Bool = true
    private(set) weak var target: AnyObject?
    private(set) var action: Selector?
    init(imageNamed name: String) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.isUserInteractionEnabled = true
        self.anchorPoint = kCenterAnchor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTarget(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isEnabled {
            return
        }
        self.isSelected = true
        self.alpha = kSelectedOpacity
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isEnabled {
            return
        }
        let point = touches.first!.location(in: self) as CGPoint
        if self.pointInside(point: point) {
            self.isSelected = true
            self.alpha = kSelectedOpacity
        } else {
            self.isSelected = false
            self.alpha = 1.0
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1.0
        if !isEnabled || !isSelected {
            return
        }
        let point = touches.first!.location(in: self) as CGPoint
        if self.pointInside(point: point) {
            _ = self.target?.perform(self.action!, with: nil)
        }
    }
    func pointInside(point: CGPoint) -> Bool {
        let insideRadius = self.size.width*pow(2.0,0.5)/2.0
        let isInside = pow(pow(point.x,2.0) + pow(point.y, 2.0), 0.5) < insideRadius
        return isInside
    }
}
