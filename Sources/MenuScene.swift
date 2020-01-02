import SpriteKit
private let kTitleToAchiveIndent: CGFloat = screenHeight*0.08
private let kSubtitleToTitleIndent: CGFloat = screenHeight*0.05
private let kBestScoreToSubtitleIndent: CGFloat = screenHeight*0.05
private let kTitleFontSize: CGFloat = screenHeight*0.06
private let kSubtitleFontSize: CGFloat = screenHeight*0.044
private let kBestScoreFontSize: CGFloat = screenHeight*0.044
private let kAchivmentIndent: CGFloat = 20.0
private let kEqualizerColor = SKColor(hex:"FFFFFF")
private let kEqualizerHeight = screenHeight*0.05
class MenuScene: BasicScene, GameSceneDelegate {
    var playButton: Button!
    var shareButton: Button!
    var achivmentButton: Button!
    var titleLabel: SKLabelNode!
    var subtitleLabel: SKLabelNode!
    var bestLabel: SKLabelNode!
    var equilizer: Equalizer?
    var superView: SKView?
    var gameScene: GameScene?
    override func didMove(to view: SKView) {
        self.removeAllChildren()
        super.didMove(to: view)
        self.superView = view
        self.setupPlayButton()
        self.setupAchivmentButton()
        self.startBackgroundColorAnimation()
        self.setupLabels()
        self.setupShareButton()
        self.setupEqulizer()
        self.subscribeForNotification()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func setupPlayButton() {
        self.playButton = Button(imageNamed: "play_button")
        self.playButton.setTarget(target: self, action: #selector(playPressed))
        self.playButton.position = CGPoint(self.frame.midX, self.frame.height*0.33)
        self.addChild(self.playButton)
    }
    func setupShareButton() {
        self.shareButton = Button(imageNamed: "share_button")
        self.shareButton.setTarget(target: self, action: #selector(sharePressed))
        self.shareButton.position = CGPoint(self.frame.midX, (self.bestLabel.frame.minY - self.playButton.frame.maxY)/2.0 + self.playButton.frame.maxY)
        self.addChild(self.shareButton)
    }
    func setupAchivmentButton() {
        self.achivmentButton = Button(imageNamed: "achivment")
        self.achivmentButton.setTarget(target: self, action: #selector(achivmentPressed))
        self.achivmentButton.position = CGPoint(kAchivmentIndent + self.achivmentButton.frame.height/2.0,
            self.frame.height - kAchivmentIndent - self.achivmentButton.frame.height/2.0)
        self.addChild(self.achivmentButton)
        self.achivmentButton.alpha = 0.0
    }
    func setupLabels() {
        self.titleLabel = SKLabelNode(text: "KEEP RHYTHM");
        self.titleLabel.fontName = "Wawati SC"
        self.titleLabel.fontSize = kTitleFontSize
        self.titleLabel.position = CGPoint(self.frame.midX,
            self.achivmentButton.frame.minY - kTitleToAchiveIndent - kTitleFontSize/2.0);
        self.addChild(self.titleLabel)
        self.subtitleLabel = SKLabelNode(text: "always keep the rhythm")
        self.subtitleLabel.fontName = "Wawati SC"
        self.subtitleLabel.fontSize = kSubtitleFontSize
        self.subtitleLabel.position = CGPoint(self.frame.midX,
            self.titleLabel.frame.minY - kSubtitleToTitleIndent - kSubtitleFontSize/2.0);
        self.addChild(self.subtitleLabel)
        self.bestLabel = SKLabelNode(text:"best score: \(Int(GameManager.bestScore()))")
        self.bestLabel.fontName = "Wawati SC"
        self.bestLabel.fontSize = kBestScoreFontSize
        self.bestLabel.position = CGPoint(self.frame.midX,
        self.subtitleLabel.frame.minY - kBestScoreToSubtitleIndent - kBestScoreFontSize/2.0);
        self.addChild(self.bestLabel)
    }
    func setupEqulizer() {
        self.equilizer = Equalizer(size: CGSize(self.frame.width, kEqualizerHeight), color: SKColor.white)
        self.equilizer?.position = .zero
        self.equilizer?.startRandomPulsing()
        self.addChild(self.equilizer!)
    }
    func subscribeForNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(gameCenterManagerDidAuthenticate),
            name: .GameCenterManagerDidAuthenticateNotification,
            object: nil)
    }
    @objc func gameCenterManagerDidAuthenticate() {
        self.achivmentButton.alpha = 1.0
    }
    func gameSceneDidLose(gameScene: GameScene) {
        GameCenterManager.sharedManager.reportScore(score: GameManager.bestScore())
        self.gameScene?.removeAllActions()
        self.gameScene?.removeAllChildren()
        self.gameScene?.removeFromParent()
        self.gameScene = nil
        self.superView?.presentScene(self)
    }
    @objc func playPressed() {
        GameManager.reset()
        self.gameScene = GameScene(size: self.size)
        self.gameScene!.gameDelegate = self
        self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: kDefaultAnimationDuration))
    }
    @objc func sharePressed() {
        let activity = ActivityForwarder()
        let rootController = UIApplication.shared.delegate!.window??.rootViewController
        let image = GameManager.bestScoreSharingImage()
        activity.present(in: rootController!, with: image, from: self.shareButton.frame)
    }
    @objc func achivmentPressed() {
        GameCenterManager.sharedManager.showLeaderboard()
    }
}
