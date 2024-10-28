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
        timer.state.name
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack {
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
                Text(String(timer.secondsRemaining))
                    .font(.largeTitle)
                    .fontWeight(.bold).padding(.bottom, 50)
                HStack {
                    Text(String(timer.tomatoCount) + " / 4")
                    Button(action: skip) {
                        Text("Skip")
                    }
                }
            }
        }.navigationBarItems(trailing: NavigationLink {
            SettingsView()
        } label: {
            Image(systemName: "gear").foregroundColor(.black)
        })
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
