import UIKit
extension CGPoint {
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }
    static func random(from rect: CGRect) -> CGPoint {
        let rx = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.width)
        let ry = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.height)
        return CGPoint(rx + rect.origin.x, ry + rect.origin.y)
    }
}
extension CGSize {
    init(_ w: CGFloat, _ h: CGFloat) {
        self.init(width: w, height: h)
    }
}
extension CGRect {
    init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
}
