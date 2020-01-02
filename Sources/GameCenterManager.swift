import GameKit
extension Notification.Name {
    static let GameCenterManagerDidAuthenticateNotification = NSNotification.Name("gameCenterManagerDidAuthenticate")
}
class GameCenterManager: NSObject, GKGameCenterControllerDelegate {
    static let sharedManager: GameCenterManager = GameCenterManager()
    var rootController: UIViewController?
    var gameCenterEnabled: Bool = false
    var gameCenterLeaderboardID: String?
    func authenticateLocalUser() {
        let localPlayer = GKLocalPlayer.localPlayer()
    }
    func showLeaderboard() {
        if self.gameCenterEnabled && self.gameCenterLeaderboardID != nil {
            let gcController = GKGameCenterViewController()
            gcController.gameCenterDelegate = self
            gcController.viewState = .leaderboards
            gcController.leaderboardIdentifier = self.gameCenterLeaderboardID
            self.rootController?.present(gcController, animated: true, completion: nil)
        }
    }
    func reportScore(score: CGFloat) {
        if self.gameCenterEnabled && self.gameCenterLeaderboardID != nil {
            let gkScore = GKScore(leaderboardIdentifier: self.gameCenterLeaderboardID!)
            gkScore.value = Int64(score)
            GKScore.report([gkScore], withCompletionHandler: nil)
        }
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
