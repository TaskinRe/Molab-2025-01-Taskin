import SwiftUI

struct MeditationView: View {
    @EnvironmentObject var session: MeditationSession

    var body: some View {
        VStack(spacing: 40) {

            // 🕒 Timer Display
            Text(timeString(from: session.timeRemaining))
                .font(.largeTitle)
                .fontWeight(.bold)

            // 🎵 Sound Picker
            Picker("Sound", selection: $session.selectedSound) {
                ForEach(MeditationSession.Sound.allCases) { sound in
                    Text(sound.rawValue.capitalized).tag(sound)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            // ⏱️ Duration Picker
            DurationPicker(selectedDuration: $session.timerDuration)
                .disabled(session.isTimerRunning) //

            // 🎮 Control Buttons
            HStack(spacing: 20) {
                Button(action: session.start) {
                    Label("Start", systemImage: "play.circle.fill")
                        .font(.title2)
                }
                .disabled(session.isTimerRunning)

                Button(action: session.pause) {
                    Label("Pause", systemImage: "pause.circle.fill")
                        .font(.title2)
                }
                .disabled(!session.isTimerRunning)

                Button(action: session.reset) {
                    Label("Reset", systemImage: "stop.circle.fill")
                        .font(.title2)
                }
            }
        }
        .padding()
        .navigationTitle("Mindful Moments")
    }

    private func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
