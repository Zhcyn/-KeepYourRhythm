import SpriteKit
class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isMultipleTouchEnabled = false
        self.view.isExclusiveTouch = true
        let skView = SKView(frame: self.view.frame)
        self.view.addSubview(skView)
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.backgroundColor = UIColor.black
        skView.ignoresSiblingOrder = true
        let menuScene = MenuScene(size: self.view.frame.size)
        skView.presentScene(menuScene)
        GameCenterManager.sharedManager.rootController = self
        GameCenterManager.sharedManager.authenticateLocalUser()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}
