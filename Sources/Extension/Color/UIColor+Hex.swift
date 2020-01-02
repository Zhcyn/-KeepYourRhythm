import UIKit
extension UIColor {
    var image: UIImage {
        return image(size: CGSize(width: 1, height: 1))
    }
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if cString.count != 6 {
            fatalError("invalid hex")
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func image(size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(origin: .zero, size: size)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.clear(rect)
            ctx.setFillColor(cgColor)
        }
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).fill()
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
