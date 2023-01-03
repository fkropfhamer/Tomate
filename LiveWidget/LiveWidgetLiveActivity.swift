//
//  LiveWidgetLiveActivity.swift
//  LiveWidget
//
//  Created by Fabian Kropfhamer on 04.12.22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivityView: View {
    let context: ActivityViewContext<LiveActivityAttributes>
    
    var body: some View {
        HStack {
            Text(context.state.phase).font(.headline)
            if (context.state.endTime != nil) {
                Text(context.state.endTime!, style: .timer)
            }
        }
        .activityBackgroundTint(Color.cyan)
        .activitySystemActionForegroundColor(Color.black)
    }
}


struct LiveWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            LiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
