import UIKit
class ActivityForwarder {
    func present(in controller: UIViewController, with image: UIImage, from: CGRect) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.present(activityController, animated: true, completion: nil)
    }
}
