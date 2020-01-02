import SpriteKit
extension SKColor {
    class func randomColor() -> SKColor {
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())
        let color = SKColor(red: r, green: g, blue: b, alpha: 1.0)
        return color
    }
    class func randomParticleColor() -> SKColor {
        return randomColorFromColors(colors: particleColors())
    }
    class func randomColorFromColors(colors: [SKColor]) -> SKColor {
        let randIndex: Int = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randIndex]
    }
    class func particleColors() -> [SKColor] {
        return Array(arrayLiteral: SKColor(hex: "F4F671"),
        SKColor(hex:"F470B3"),
        SKColor(hex:"43EFCE"),
        SKColor(hex:"5BEE75"),
        SKColor(hex:"5BDDEE"),
        SKColor(hex:"C27DE6"))
    }
}
