import UIKit
private let kBeatsOnRoundKey = "beats_on_round"
private let kIntroductionNumberKey = "introduction_number"
private let kSourceNameKey = "source_name"
private let kWinScoreKey = "win_score"
private let kAccurteBeatScoreKey = "accurate_beat_score"
class RoundsParser {
    class func parseRounds(sourceName: String) -> Array<Round> {
        let url = Bundle.main.url(forResource: sourceName, withExtension: "plist")
        let roundsArray = NSArray(contentsOf: url!)
        if roundsArray == nil {
            return []
        }
        var rounds = Array<Round>()
        for i in 0...roundsArray!.count - 1 {
            let dict: NSDictionary = roundsArray!.object(at: i) as! NSDictionary
            let beatsOnRound = (dict[kBeatsOnRoundKey] as! NSNumber).intValue
            let winScore = CGFloat((dict[kWinScoreKey] as! NSNumber).floatValue)
            let accurateBeatScore = CGFloat((dict[kAccurteBeatScoreKey] as! NSNumber).floatValue)
            let intrNumber = (dict[kIntroductionNumberKey] as! NSNumber).intValue
            let sourceName = dict[kSourceNameKey] as! String
            let beatURL = Bundle.main.url(forResource: sourceName, withExtension: "plist", subdirectory: "beats")
            let beatArray = NSArray(contentsOf: beatURL!)
            if beatArray == nil {
                break
            }
            var delays = Array<CGFloat>()
            for delay in beatArray! {
                delays.append(CGFloat((delay as AnyObject).floatValue))
            }
            let beat = Beat(delays: delays)
            let round = Round(beat: beat, intrNumber: intrNumber, beatsOnRound: beatsOnRound, winScore: winScore, accurateBeatScore: accurateBeatScore)
            rounds.append(round)
        }
        return rounds
    }
}
