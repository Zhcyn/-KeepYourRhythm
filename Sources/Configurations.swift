import SpriteKit
let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
let kLeftBottomAnchor = CGPoint(0.0, 0.0)
let kLeftTopAnchor = CGPoint(0.0, 1.0)
let kCenterAnchor = CGPoint(0.5, 0.5)
let kCenterBottomAnchor = CGPoint(0.5, 0.0)
let kCenterTopAnchor = CGPoint(0.5, 1.0)
let kLeftCenterAnchor = CGPoint(0.0, 0.5)
let kRightCenterAnchor = CGPoint(1.0, 0.5)
let isPhone = (UI_USER_INTERFACE_IDIOM() == .phone)
let kMaxPolygonCorners: Int = 6
let kMinPolygonCorners: Int = 3
let kDefaultAnimationDuration: TimeInterval = 0.25
