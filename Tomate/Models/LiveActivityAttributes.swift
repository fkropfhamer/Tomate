//
//  LiveActivityAttributes.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 04.12.22.
//

import ActivityKit
import SwiftUI


struct LiveActivityAttributes: ActivityAttributes {
    public typealias LiveActivityStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var endTime: Date?
        var phase: String
    }
}

@available(iOS 16.2, *)
var liveActivityHandler = LiveActivityHandler()

@available(iOS 16.2, *)
public class LiveActivityHandler {
    private var liveActivity: Activity<LiveActivityAttributes>? = nil
    
    public func startActivity(secondsRemaining: Int, phase: String) {
        let endTime = Date().addingTimeInterval(TimeInterval(secondsRemaining))
        let state = LiveActivityAttributes.LiveActivityStatus(endTime: endTime, phase: phase)
        
        if liveActivity == nil {
            let attributes = LiveActivityAttributes()
            
            liveActivity = try? Activity<LiveActivityAttributes>.request(attributes: attributes, contentState: state, pushType: .none)
        } else {
            updateActivity(state: state)
        }
    }

    public func stopActivity() {
        let state = LiveActivityAttributes.LiveActivityStatus(phase: "End")
        
        updateActivity(state: state)
        
        /*Task {
            await liveActivity?.update(using: state)
           await liveActivity?.end(using: state, dismissalPolicy: .default)
        }*/
    }
    
    private func updateActivity(state: LiveActivityAttributes.ContentState) {
        Task {
            await liveActivity?.update(using: state)
        }
    }
    
    public func pauseActivity() {
        let state = LiveActivityAttributes.LiveActivityStatus(phase: "Pause")
        
        updateActivity(state: state)
    }
}
