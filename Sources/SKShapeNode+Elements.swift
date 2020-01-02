import SpriteKit
extension SKShapeNode {
    class func randomPolygonWithColor(color: SKColor, radius: CGFloat) -> SKShapeNode {
        let cornersNumber: Int =  kMinPolygonCorners + Int(arc4random_uniform(UInt32(kMaxPolygonCorners - kMinPolygonCorners + 1 )))
        let polygon = SKShapeNode(path: self.polygonPath(radius: radius, sides: cornersNumber))
        polygon.fillColor = color
        polygon.strokeColor = SKColor.clear
        polygon.zRotation = CGFloat(drand48())*2.0*CGFloat.pi
        return polygon
    }
    class func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat.pi * a / 180
        return b
    }
    class func polygonPointArray(sides:Int, radius:CGFloat)->[CGPoint] {
        let angle = degree2radian(a: 360/CGFloat(sides))
        let r  = radius 
        var i = 0
        var points = [CGPoint]()
        while i <= sides {
            let xpo = r * cos(angle * CGFloat(i))
            let ypo = r * sin(angle * CGFloat(i))
            points.append(CGPoint(x: xpo, y: ypo))
            i += 1;
        }
        return points
    }
    class func polygonPath(radius:CGFloat, sides:Int) -> CGPath {
        let path = CGMutablePath()
        let points = self.polygonPointArray(sides: sides, radius: radius)
        let cpg = points[0]
        path.move(to: cpg)
        for p in points {
            path.addLine(to: p)
        }
        path.closeSubpath()
        return path
    }
}
