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
        if timer.isWorking {
            return Color.red
        } else if timer.isShortBreak {
            return Color.green
        }
        
        return Color.purple
    }
    
    private var status: String {
        if timer.isWorking {
            return "Work"
        }
        
        return "Break"
    }
    
    var body: some View {
        VStack {
            Text(String(timer.secondsElapsed))
            NavigationLink(destination: Text("Score " + String(score.score))) {
                Text("Hello, world!")
            }
            Text(status)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            ZStack {
                Circle().strokeBorder(lineWidth: 50)
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
            Text(String(timer.tomatoCount) + " / 4")
        }.background(backgroundColor)
    }
    
    private func start() {
        timer.startTimer()
    }
    
    private func stop() {
        timer.stop()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
