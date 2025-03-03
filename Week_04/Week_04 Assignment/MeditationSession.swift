import Foundation
import AVFoundation
import SwiftUI
import UIKit

class MeditationSession: ObservableObject {
    @Published var selectedSound: Sound = .rain
    @Published var timerDuration: TimeInterval = 600 // Default 10 minutes
    @Published var timeRemaining: TimeInterval = 600
    @Published var isTimerRunning = false

    var audioPlayer: AVAudioPlayer?
    private var timer: Timer?

    enum Sound: String, CaseIterable, Identifiable {
        case oceanWaves, forestBirds, rain
        var id: Self { self }

        var filename: String {
            switch self {
            case .oceanWaves: return "ocean_waves"
            case .forestBirds: return "forest_birds"
            case .rain: return "rain"  //  rain.mp3
            }
        }
    }

    func start() {
        setupAudio()
        startTimer()
        isTimerRunning = true
    }

    func pause() {
        timer?.invalidate()
        audioPlayer?.pause()
        isTimerRunning = false
    }

    func reset() {
        pause()
        timeRemaining = timerDuration
        audioPlayer?.stop()
        audioPlayer = nil
    }

    private func startTimer() {
        timer?.invalidate() // Prevent multiple timers
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.reset()
            }
        }
    }

    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: selectedSound.filename, withExtension: "mp3") else {
            print("🚫 Audio file not found: \(selectedSound.filename).mp3")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // 🔁 Infinite loop
            audioPlayer?.play()
        } catch {
            print("❌ Audio setup failed: \(error.localizedDescription)")
        }
    }
}

