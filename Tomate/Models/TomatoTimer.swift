//
//  TomatoTimer.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 28.01.22.
//

import Foundation
import AudioToolbox

class TomatoTimer : ObservableObject {
    @Published var secondsElapsed = 0
    @Published var secondsRemaining = 0
    
    private var timer: Timer?
    public var timerStopped = true
    private var frequency = 1.0 / 60.0
    private var startDate: Date?
    
    public func startTimer() {
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency , repeats: true) {
            [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(secondsElapsed: Int(secondsElapsed))
            }
        }
        timerStopped = false
    }
    
    public func stop() {
        timerStopped = true
    }
    
    private func update(secondsElapsed: Int) {
        self.secondsElapsed = secondsElapsed
        if (secondsElapsed == 10) {
            print("Alarm!")
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                
            }
        }
    }
}
