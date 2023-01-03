//
//  TomatoTimer.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 28.01.22.
//

import Foundation
import AudioToolbox
import UserNotifications


public class NotificationHandler {
    public static func askNotificationPermission() {
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings() {  settings in
            if settings.authorizationStatus == .notDetermined {
                current.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    public static func scheduleNotification(timeInterval: TimeInterval, phase: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm! You finished \(phase)"
        //content.subtitle = ""
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    public static func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}



public enum TimerState {
    case longBreak
    case shortBreak
    case working
    
    var name: String {
        switch self {
        case .longBreak:
            return "long Break"
        case .shortBreak:
            return "short Break"
        case .working:
            return "Work"
        }
    }
}

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
    
    public init() {
        secondsRemaining = targetSeconds - secondsElapsed
    }
    
    public func start() {
        startTimer()
        scheduleNotification()
    }
    
    private func scheduleNotification() {
        NotificationHandler.scheduleNotification(timeInterval: TimeInterval(secondsRemaining), phase: state.name)
        
        if #available(iOS 16.2, *) {
            liveActivityHandler.startActivity(secondsRemaining: secondsRemaining, phase: state.name)
        }
    }
    
    private func cancelNotification() {
        NotificationHandler.cancelNotifications()
        
        if #available(iOS 16.2, *) {
            liveActivityHandler.pauseActivity()
        }
    }
    
    private func updateRemainingSeconds() {
        self.secondsRemaining = targetSeconds - secondsElapsed
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
        updateRemainingSeconds()
        if timerStopped {return}
        updateProgress()
        
       updateState(secondsElapsed: secondsElapsed)
    }
    
    private func updateProgress() {
        progress = Double(secondsElapsed) / Double(targetSeconds)
    }
    
    private func updateState(secondsElapsed: Int) {
        if (secondsElapsed < targetSeconds) {
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
        updateRemainingSeconds()
    }
}
