import UIKit
class RoundsProvider {
    var rounds: Array<Round>
    init(){
        self.rounds = RoundsParser.parseRounds(sourceName: "rounds")
    }
    func roundAtIndex(index: Int) -> Round {
        let realIndex = index - 1
        if index > self.rounds.count {
            let roundIndex = (realIndex) % rounds.count
            var round = rounds[roundIndex]
            round.accurateBeatScore = self.accurateBeatScoreForRound(round: realIndex);
            round.winScore = self.winScoreForRound(round: round)
            return round;
        } else {
            return rounds[realIndex]
        }
    }
    func accurateBeatScoreForRound(round: Int) -> CGFloat {
        return (CGFloat(round)*10.0 + 40.0)
    }
    func winScoreForRound(round: Round) -> CGFloat {
        return (CGFloat(round.beatsOnRound)*CGFloat(round.beat.delays.count)*round.accurateBeatScore + 3.0*round.accurateBeatScore)
    }
}
