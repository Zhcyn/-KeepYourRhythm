import UIKit
private let kFirstBeatDelayEpsilon: CGFloat = 0.1;
private let kVolumeEpsilon: CGFloat = 0.01
private let kDropDownBeatsNumber: Int = 3
class BeatsPlayer {
    var beat: Beat
    var equalizer: Equalizer
    var completion: (()->Void)?
    var currentVolume: CGFloat = 1.0
    var needDropDown: Bool = false
    init(beat: Beat, equalizer: Equalizer){
        self.beat = beat
        self.equalizer = equalizer
    }
    func startBeat(beatsCount:Int, completion: (()-> Void)?){
        self.completion = completion
        var summaryDelays = Array<CGFloat>()
        for i in 0...beatsCount - 1 {
            for j in 0...beat.delays.count - 1 {
                var delay = beat.delays[j]
                if (i == 0) && (j == 0) {
                    delay += kFirstBeatDelayEpsilon
                }
                summaryDelays.append(delay)
            }
        }
        SoundManager.sharedManager.playBeat(volume: self.currentVolume)
        self.equalizer.pulse()
        self.playBeatWithDelays(delays: summaryDelays)
    }
    func playBeatWithDelays(delays: [CGFloat]) {
        if delays.count == 0 || self.currentVolume < kVolumeEpsilon {
            if let callback = self.completion {
                callback()
            }
            return
        }
        if delays.count <= kDropDownBeatsNumber {
            self.needDropDown = true
        }
        let delay = TimeInterval(delays[0])
        print("\(delay)")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.needDropDown {
                self.currentVolume -= 1.0/CGFloat(kDropDownBeatsNumber)
            }
            if self.currentVolume > 0.2 {
                self.equalizer.pulse()
            }
            SoundManager.sharedManager.playBeat(volume: self.currentVolume)
            var newDelays = delays
            newDelays.removeFirst()
            self.playBeatWithDelays(delays: newDelays)
        }
    }
    func stopBeat() {
        self.needDropDown = true
    }
}
