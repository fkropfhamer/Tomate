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
    @Published var timerStopped = true
    @Published var isBigBreak = false
    @Published var isShortBreak = false
    @Published var isWorking = true
    @Published var tomatoCount = 0
    
    private var timer: Timer?
    private var frequency = 1.0 / 60.0
    private var startDate: Date?
    private var workingSeconds = 60
    private var shortBreakSeconds = 10
    private var bigBreakSeconds = 30
    private var isPaused = false
    private var targetSeconds: Int {
        if (isWorking) {
            return workingSeconds
        } else if (isBigBreak) {
            return bigBreakSeconds
        } else {
            return shortBreakSeconds
        }
    }
    
    public func startTimer() {
        startDate = Date()
        let secondsAlreadyElapsed = secondsElapsed
        timer = Timer.scheduledTimer(withTimeInterval: frequency , repeats: true) {
            [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(secondsElapsed: Int(secondsElapsed) + secondsAlreadyElapsed)
            }
        }
        timerStopped = false
    }
    
    public func stop() {
        timer?.invalidate()
        timerStopped = true
    }
    
    public func pause() {
        stop()
    }
    
    public func skip() {
        stop()
        
        updateState(secondsElapsed: targetSeconds)
    }
    
    private func notify() {
        print("Alarm!")
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
    }
    
    private func update(secondsElapsed: Int) {
        self.secondsElapsed = secondsElapsed
        if timerStopped {return}
        
       updateState(secondsElapsed: secondsElapsed)
    }
    
    private func updateState(secondsElapsed: Int) {
        if (isWorking && secondsElapsed == workingSeconds) {
            stop()
            notify()
            isWorking = false
            tomatoCount += 1
            Score.shared.scored()
            if (tomatoCount >= 4) {
                isBigBreak = true
            } else {
                isShortBreak = true
            }
            self.secondsElapsed = 0
        } else if (isBigBreak && secondsElapsed == bigBreakSeconds) {
            stop()
            notify()
            isWorking = true
            isShortBreak = false
            tomatoCount = 0
            self.secondsElapsed = 0
        } else if (isShortBreak && secondsElapsed == shortBreakSeconds) {
            stop()
            notify()
            isWorking = true
            isShortBreak = false
            self.secondsElapsed = 0
        }
    }
}
