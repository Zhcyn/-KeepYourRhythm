import UIKit
private let kBestScoreKey = "total_best_score"
class GameManager {
    static let sharedManager = GameManager()
    var totalWinScore: CGFloat = 0.0
    var currentScore: CGFloat = 0.0
    var currentRound: Int = 0
    class func round() -> Int {
        return sharedManager.currentRound
    }
    class func score() -> CGFloat {
        return sharedManager.currentScore
    }
    class func winScore() -> CGFloat {
        return sharedManager.totalWinScore
    }
    class func increaseRound() {
        sharedManager.currentRound += 1
    }
    class func increaseScore(score: CGFloat) {
        sharedManager.currentScore += score
        self.checkForBestScore()
    }
    class func reset() {
        sharedManager.totalWinScore = 0.0
        sharedManager.currentScore = 0.0
        sharedManager.currentRound = 0
    }
    class func checkForBestScore() {
        if (sharedManager.currentScore > self.bestScore()) {
            UserDefaults.standard.set(sharedManager.currentScore, forKey: kBestScoreKey)
        }
    }
    class func bestScore() -> CGFloat {
        return CGFloat(UserDefaults.standard.float(forKey: kBestScoreKey))
    }
    class func bestScoreSharingImage() -> UIImage {
        let maxWidth: CGFloat = 1000
        let indent:CGFloat = 20.0
        let text = "KEEP RHYTHM BEST: \(Int(self.bestScore()))"
        let font = UIFont(name: "Wawati SC", size: 50.0)
        let bounds = text.boundingRect(
            with: CGSize(maxWidth, 0),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil
        )
        let contextSize = CGSize(2*indent + bounds.width, 2*indent + bounds.height)
        let rect = CGRect(0, 0, contextSize.width, contextSize.height)
        UIGraphicsBeginImageContext(contextSize)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor.black.cgColor)
        context!.fill(rect)
        text.draw(
            with: CGRect(indent, indent, bounds.width, bounds.height),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!, .foregroundColor: UIColor.white],
            context: nil
        )
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}
