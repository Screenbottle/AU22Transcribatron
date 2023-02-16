//
//  MeetingTimer.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-01-31.
//

import Foundation

class MeetingTimer : ObservableObject {
    
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var timeElapsed = "00:00:00"
    
    private var timer: Timer?
    private var timerStopped = false
    private var timerPaused = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    
    func startTimer() {
        startDate = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince(startDate)
                
                self.timeElapsed = self.format(second: secondsElapsed) ?? "00:00:00"
                
                self.update()
            }
        
        }
        
    }
    
    func pauseTimer() {
        
    }
    
    func resumeTimer() {
        
    }
    
    func resetTimer() {
        timeElapsed = "00:00:00"
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
        endDate = Date()
    }
    
    func update() {
        
    }
    
    private func format(second: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: second)
    }
    
    
}
