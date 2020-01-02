import SpriteKit
class GradientNode: SKSpriteNode {
    init(size: CGSize, color: UIColor) {
        super.init(texture: nil, color: color, size: size)
        self.setupContents()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupContents() {
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsBeginImageContext(self.size)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = []
        gradientLayer.renderInContext(context)
        UIGraphicsEndImageContext()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let texture = SKTexture(CGImage: image.CGImage!)
        let gradient = SKSpriteNode(texture: texture)
        gradient.anchorPoint = kLeftBottomAnchor
        self.addChild(gradient)
    }
}
