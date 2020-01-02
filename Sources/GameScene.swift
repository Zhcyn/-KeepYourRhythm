import SpriteKit
private let kRoundStartDelay = 1.0
private let kAccurateBeatBonusCoeff: CGFloat = 2.0
private let kBadBeatCoeff: CGFloat = 0.5
private let kAccurateBeatEpsilon: CGFloat = 0.01;
private let kScoreLabelIndent: CGFloat = isPhone ? 100.0 : 150.0
private let kEqualizerBottomIndent: CGFloat = isPhone ? 40.0 : 50.0
private let kScoreLabelFontSize: CGFloat = isPhone ? 40.0 : 70.0
private let kEarnedScoreFontSize: CGFloat = isPhone ? 55.0 : 90.0
private let kTutorFontSize: CGFloat = isPhone ? 30.0 : 50.0
private let kEqualizerColor = SKColor(hex:"FFFFFF")
private let kAccurateEearnedScoreColor = SKColor.red
protocol GameSceneDelegate: NSObjectProtocol {
    func gameSceneDidLose(gameScene: GameScene)
}
class GameScene: BasicScene {
    weak var gameDelegate: GameSceneDelegate?
    var equalizer: Equalizer?
    var roundsProvider = RoundsProvider()
    var currentRound: Round!
    var tutorLabel = UILabel()
    var scoreLabel = SKLabelNode()
    var roundNode: RoundNode!
    var waitingForStart: Bool = false
    var needHandleTaps: Bool = false
    var tappedBeatNumber: Int = 0
    var lastTapDate: NSDate = NSDate()
    override init(size: CGSize) {
        super.init(size: size)
        self.setupContentsAndAnimations()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.setupTutorNode()
        self.startNextRound()
        self.startBackgroundColorAnimation()
    }
    func setupContentsAndAnimations() {
        self.setupEqualizer()
        self.setupScoreLabel()
        self.setupRoundNode()
    }
    func setupEqualizer(){
        let widthCoeff: CGFloat = isPhone ? 5.5/10.0 : 4.0/10.0
        let heightCoeff: CGFloat = isPhone ? 4.0/10.0 : 2.5/10.0
        let equalizerSize = CGSize(self.frame.width*widthCoeff, self.frame.width*heightCoeff)
        self.equalizer = Equalizer(size: equalizerSize, color: kEqualizerColor)
        self.equalizer?.position = CGPoint(self.frame.midX - self.equalizer!.frame.width/2.0,
            self.equalizer!.frame.height/2.0 + kEqualizerBottomIndent)
        self.addChild(self.equalizer!)
    }
    func setupScoreLabel() {
        self.scoreLabel.fontName = "Wawati SC"
        self.scoreLabel.fontSize = kScoreLabelFontSize
        self.scoreLabel.text = "Score: \(Int(GameManager.score()))"
        self.scoreLabel.position = CGPoint(self.frame.midX,self.frame.height - kScoreLabelIndent)
        self.scoreLabel.alpha = 0.0
        self.addChild(self.scoreLabel)
    }
    func updateScoreLabel() {
        self.scoreLabel.text = "Score: \(Int(GameManager.score()))"
    }
    func setupTutorNode() {
        self.tutorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tutorLabel.textColor = UIColor.white
        self.tutorLabel.font = UIFont(name: "Wawati SC", size: kTutorFontSize)
        self.tutorLabel.numberOfLines = 0
        self.tutorLabel.textAlignment = .center
        self.view?.addSubview(self.tutorLabel)
        let centerX = NSLayoutConstraint(item: self.tutorLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0)
        let centerY = NSLayoutConstraint(item: self.tutorLabel,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        self.view?.addConstraint(centerX)
        self.view?.addConstraint(centerY)
    }
    func startNextRound() {
        GameManager.increaseRound()
        self.currentRound = roundsProvider.roundAtIndex(index: GameManager.round())
        GameManager.sharedManager.totalWinScore += self.currentRound.winScore
        self.hideScore()
        self.hideRoundNode()
        if GameManager.round() != 1 {
            self.showTutorWithText(text: "Great! You won \n Tap to start \n Round \(GameManager.round())\n Listen, then repeat")
        } else {
            self.showTutorWithText(text: "Tap to start\n Round \(GameManager.round()) \n Listen, then repeat")
        }
        call(block:{ self.waitingForStart = true }, after: 0.5)
    }
    func beginRound() {
        self.waitingForStart = false
        self.roundNode.updateWithRound(round: GameManager.round(), winScore: GameManager.winScore())
        self.hideTutor()
        call(block: {
            self.showRoundNode()
            self.showScore()
            let beatsPlayer = BeatsPlayer(beat: self.currentRound.beat, equalizer: self.equalizer!)
            beatsPlayer.startBeat(beatsCount: self.currentRound.introductionNumber, completion: {
                self.showTutorWithText(text: "Tap to start \n repeat")
                self.hideRoundNode()
                self.needHandleTaps = true
            })
        }, after: 1.0)
    }
    func endRound() {
        GameCenterManager.sharedManager.reportScore(score: GameManager.bestScore())
        self.needHandleTaps = false
        self.tappedBeatNumber = 0
        if GameManager.score() >= GameManager.winScore() {
            call(block: {
                self.startNextRound()
            }, after: 1.0)
        } else {
            self.gameOver()
        }
    }
    func gameOver() {
        self.showTutorWithText(text: "You LOST")
        call(block: {
            self.hideTutor()
        }, after: 2.0)
        call(block: {
            self.gameDelegate?.gameSceneDidLose(gameScene: self)
        }, after: 3.0)
    }
    func setupRoundNode() {
        self.roundNode = RoundNode(round: 0, winScore: 0, size: .zero)
        self.roundNode.position = CGPoint(self.frame.midX, self.frame.midY)
        self.roundNode.alpha = 0.0
        self.addChild(self.roundNode)
    }
    func showRoundNode() {
        self.roundNode.alpha = 0.0
        let fadeInAction = SKAction.fadeIn(withDuration: kDefaultAnimationDuration)
        self.roundNode.run(fadeInAction)
    }
    func hideRoundNode() {
        let fadeOutAction = SKAction.fadeOut(withDuration: kDefaultAnimationDuration)
        self.roundNode.run(fadeOutAction)
    }
    func showScore() {
        self.scoreLabel.alpha = 0.0
        let fadeInAction = SKAction.fadeIn(withDuration: kDefaultAnimationDuration)
        self.scoreLabel.run(fadeInAction)
    }
    func hideScore() {
        let fadeOutAction = SKAction.fadeOut(withDuration: kDefaultAnimationDuration)
        self.scoreLabel.run(fadeOutAction)
    }
    func showTutorWithText(text: String) {
        self.tutorLabel.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {
                self.tutorLabel.alpha = 1.0
        })
        self.tutorLabel.text = text
    }
    func hideTutor() {
        UIView.animate(withDuration: 1.0, animations: {
            self.tutorLabel.alpha = 0.0
        })
    }
    func animateEarnedScore(score: CGFloat, isBonus: Bool) {
        let scoreLabel = SKLabelNode(text: "+\(Int(score))")
        scoreLabel.fontSize = kEarnedScoreFontSize
        scoreLabel.fontName = "Wawati SC"
        let rectForAction = CGRect(kEarnedScoreFontSize, self.equalizer!.frame.maxY + kEarnedScoreFontSize,
            self.frame.width - kEarnedScoreFontSize, self.scoreLabel.frame.minY - self.equalizer!.frame.maxY - kEarnedScoreFontSize*2.0)
        scoreLabel.fontColor = isBonus ? kAccurateEearnedScoreColor : SKColor.white
        scoreLabel.position = .random(from: rectForAction)
        let constrictAction = SKAction.scale(to: 0.0, duration: 0.6)
        constrictAction.timingMode = SKActionTimingMode.easeIn
        let sequence = SKAction.sequence([constrictAction, SKAction.removeFromParent()])
        scoreLabel.run(sequence)
        self.addChild(scoreLabel);
    }
    func tapped() {
        let tapDelay: CGFloat = CGFloat(NSDate().timeIntervalSince(self.lastTapDate as Date))
        print("\(tapDelay)")
        self.lastTapDate = NSDate()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.waitingForStart {
            self.beginRound()
            return
        }
        if !self.needHandleTaps {
            return
        }
        self.tappedBeatNumber += 1
        var earnedScore = self.currentRound.accurateBeatScore
        let isFirstTap = self.tappedBeatNumber == 1
        if isFirstTap {
            self.hideTutor()
            earnedScore = 1.0
        } else {
            let tapDelay: CGFloat = CGFloat(NSDate().timeIntervalSince(self.lastTapDate as Date))
            let needDelay: CGFloat = self.currentRound.unionedBeatDelays[self.tappedBeatNumber - 2]
            let epsilon = fabs(tapDelay - needDelay)
            var needBonus = false
            if epsilon <= kAccurateBeatEpsilon {
                earnedScore *= kAccurateBeatBonusCoeff
                needBonus = true
            } else if epsilon > needDelay*kBadBeatCoeff {
                earnedScore = 1.0
            } else {
                earnedScore = earnedScore*(1.0 - epsilon/needDelay)
            }
            print("need delay \(needDelay) tapped delay \(tapDelay)  earned \(earnedScore)")
            self.animateEarnedScore(score: earnedScore, isBonus: needBonus)
        }
        GameManager.increaseScore(score: earnedScore)
        self.updateScoreLabel()
        self.lastTapDate = NSDate()
        SoundManager.sharedManager.playBeat()
        self.equalizer?.pulse()
        let needEndRound = self.tappedBeatNumber - 1 == self.currentRound.unionedBeatDelays.count
        if needEndRound {
            self.endRound()
        }
    }
}
