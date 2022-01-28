//
//  ContentView.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 28.01.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var timer = TomatoTimer()
    
    var body: some View {
        VStack {
            Text(String( timer.secondsElapsed))
            NavigationLink(destination: Text("top")) {
                Text("Hello, world!")
                    .padding()
            }
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
            NavigationLink(destination: Text("bottom")) {
                Text("Bottom")
            }
        }
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
