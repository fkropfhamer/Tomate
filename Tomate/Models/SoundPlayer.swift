import Foundation
import AVFoundation

enum PlayerState {
    case playing
    case stopped
}

class SoundPlayer: ObservableObject {
    @Published var state: PlayerState = .stopped
    
    private var player: AVAudioPlayer?
    
    func stop() {
        player?.stop()
        player = nil
        state = .stopped
    }
    
    func play() {
        guard let soundUrl = Bundle.main.url(forResource: "white", withExtension: "wav") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundUrl)
            state = .playing
        } catch {
            
        }
        
        player?.numberOfLoops = -1
        player?.play()
    }
}

