import Foundation

class Score : ObservableObject {
    static let shared = Score()
    
    @Published private(set) var score = 0
    
    public func scored() {
        score += 1
    }
}
