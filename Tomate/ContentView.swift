//
//  ContentView.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 28.01.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var timer = TomatoTimer()
    @StateObject var score = Score.shared
    
    private var backgroundColor: Color {
        switch timer.state {
        case .longBreak:
            return Color.purple
        case .shortBreak:
            return Color.brown
        case .working:
            return Color.red
        }
    }
    
    private var status: String {
        switch timer.state {
        case .longBreak:
            return "long Break"
        case .shortBreak:
            return "Break"
        case .working:
            return "Work"
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: Text("Score " + String(score.score))) {
                Text("Hello, world!")
            }
            Text(status)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            ZStack {
                ProgressBar(progress: $timer.progress).padding(50)
                if (timer.timerStopped) {
                    Button(action: start) {
                        Text("Start")
                    }
                } else {
                    Button(action: stop) {
                        Text("Stop")
                    }
                }
            }
            Text(String(timer.secondsElapsed))
                .font(.largeTitle)
                .fontWeight(.bold).padding(.bottom, 50)
            HStack {
                Text(String(timer.tomatoCount) + " / 4")
                Button(action: skip) {
                    Text("Skip")
                }
            }
        }.background(backgroundColor)
    }
    
    private func start() {
        timer.start()
    }
    
    private func stop() {
        timer.stop()
    }
         
         private func skip() {
             timer.skip()
         }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
