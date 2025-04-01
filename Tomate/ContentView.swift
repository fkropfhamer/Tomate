import SwiftUI

struct ContentView: View {
    @StateObject private var soundPlayer = SoundPlayer()
    @StateObject var score = Score.shared
    @StateObject var timer = TomatoTimer()
    
    
    
    private var status: String {
        timer.state.name
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(named: "BackgroundColor")!)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text(status)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor(named: "TextColor")!))
                    ZStack {
                        ProgressBar(progress: $timer.progress).padding(50)
                        if (timer.timerStopped) {
                            Button(action: start) {
                                StartButton(color: Color(UIColor(named: "WorkColor")!))
                            }
                        } else {
                            Button(action: stop) {
                                Text("Stop")
                            }
                        }
                    }
                    Text(String(timer.secondsRemaining))
                        .font(.largeTitle)
                        .fontWeight(.bold).padding(.bottom, 50).foregroundColor(Color(UIColor(named: "TextColor")!))
                    HStack {
                        Text(String(timer.tomatoCount) + " / 4")
                        Button(action: {}) {
                            Text("Skip")
                        }
                        .highPriorityGesture(TapGesture().onEnded({ _ in skip()}))
                        .simultaneousGesture(LongPressGesture().onEnded({_ in
                            reset()
                        }))
                    }
                }
            }
            .navigationBarItems(trailing: NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gear").foregroundColor(Color(UIColor(named: "TextColor")!))
            })
        }
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
    
    private func reset() {
        timer.reset()
    }
}

#Preview {
    ContentView()
}
