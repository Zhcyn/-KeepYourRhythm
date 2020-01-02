import UIKit
import AVFoundation.AVPlayer
class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let sharedManager = SoundManager()
    var players = [AVAudioPlayer]()
    var backgroundSoundPlayer: AVAudioPlayer?
    func playBeat() {
        self.playBeat(volume: 1.0)
    }
    func playBeat(volume: CGFloat) {
        let url = Bundle.main.url(forResource: "beat1", withExtension: "m4a")
        do {
            let player = try AVAudioPlayer(contentsOf: url!)
            player.volume = Float(volume)
            player.delegate = self
            player.prepareToPlay()
            players.append(player)
            DispatchQueue.main.async {
                player.play()
            }
        } catch {
            debugPrint("sound manager play beat error: \(error)")
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let idx = players.index(where: { $0 == player }) {
            players.remove(at: idx)
        }
    }
}
