//
//  Transcription.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-09.
//

import Foundation

class Transcription : ObservableObject, Identifiable{
    
    @Published var id = UUID()
    @Published var transcription : String
    @Published var startTime : String
    @Published var endTime : String
    @Published var duration : String
    @Published var dayMonthYear: String
    @Published var date: Date
    
    init(transcription: String, startTime : String, endTime : String, duration : String, dayMonthYear: String, date: Date) {
        self.transcription = transcription
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.dayMonthYear = dayMonthYear
        self.date = date
    }
}
