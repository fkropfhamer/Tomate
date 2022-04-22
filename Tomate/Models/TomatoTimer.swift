//
//  TomatoTimer.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 28.01.22.
//

enum TimerState {
    case longBreak
    case shortBreak
    case working
}

import Foundation
import AudioToolbox

class TomatoTimer : ObservableObject {
    @Published var secondsElapsed = 0
    @Published var secondsRemaining = 0
    @Published var timerStopped = true
    @Published var state = TimerState.working
    @Published var tomatoCount = 0
    @Published var progress = 0.0
    
    private var timer: Timer?
    private var frequency = 1.0 / 60.0
    private var startDate: Date?
    private var workingSeconds = 60
    private var shortBreakSeconds = 10
    private var longBreakSeconds = 30
    private var isPaused = false
    private var targetSeconds: Int {
        switch state {
        case .longBreak:
            return longBreakSeconds
        case .shortBreak:
            return shortBreakSeconds
        case .working:
            return workingSeconds
        }
    }
    
    public func start() {
        startTimer()
        scheduleNotification()
    }
    
    private func scheduleNotification() {
        call()
    }
    
    private func cancelNotification() {
        cancel()
    }
    
    private func startTimer() {
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
        cancelNotification()
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
        updateProgress()
        
       updateState(secondsElapsed: secondsElapsed)
    }
    
    private func updateProgress() {
        progress = Double(secondsElapsed) / Double(targetSeconds)
    }
    
    private func updateState(secondsElapsed: Int) {
        if (secondsElapsed != targetSeconds) {
            return
        }
        
        switch state {
        case .longBreak:
            stop()
            notify()
            state = .working
            tomatoCount = 0
        case .shortBreak:
            stop()
            notify()
            state = .working
        case .working:
            stop()
            notify()
            tomatoCount += 1
            Score.shared.scored()
            if (tomatoCount >= 4) {
                state = .longBreak
            } else {
                state = .shortBreak
            }
        }
        
        self.secondsElapsed = 0
        updateProgress()
    }
}
