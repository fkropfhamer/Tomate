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
        var endTime: Date
        var phase: String
    }
}

@available(iOS 16.1, *)
var liveActivityHandler = LiveActivityHandler()

@available(iOS 16.1, *)
public class LiveActivityHandler {
    private var liveActivity: Activity<LiveActivityAttributes>? = nil
    
    public func startActivity(secondsRemaining: Int, phase: String) {
        let endTime = Date().addingTimeInterval(TimeInterval(secondsRemaining))
        
        let attributes = LiveActivityAttributes()
        let state = LiveActivityAttributes.LiveActivityStatus(endTime: endTime, phase: phase)
        
        liveActivity = try? Activity<LiveActivityAttributes>.request(attributes: attributes, contentState: state, pushType: .none)
    }

    public func stopActivity() {
        let state = LiveActivityAttributes.LiveActivityStatus(endTime: Date(), phase: "End")
        
        Task {
            await liveActivity?.end(using: state, dismissalPolicy: .immediate)
        }
    }
    
    public func updateActivity(a: Int) {
        /*let state = LiveActivityAttributes.LiveActivityStatus(test: a)
        
        Task {
            await liveActivity?.update(using: state)
        }*/
    }
}
