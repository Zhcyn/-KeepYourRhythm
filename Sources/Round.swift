import UIKit
struct Round {
    var beat: Beat
    var introductionNumber: Int 
    var beatsOnRound: Int
    var winScore: CGFloat
    var accurateBeatScore: CGFloat
    var unionedBeatDelays: [CGFloat]
    init(beat: Beat, intrNumber: Int, beatsOnRound: Int, winScore: CGFloat, accurateBeatScore: CGFloat) {
        self.beat = beat
        self.introductionNumber = intrNumber
        self.beatsOnRound = beatsOnRound
        self.winScore = winScore
        self.accurateBeatScore = accurateBeatScore
        var summaryDelays = [CGFloat]()
        for _ in 0...self.beatsOnRound - 1 {
            for j in 0...self.beat.delays.count - 1 {
                summaryDelays.append(self.beat.delays[j])
            }
        }
        unionedBeatDelays = summaryDelays
    }
}
