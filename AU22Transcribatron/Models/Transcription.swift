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
    @Published var startDate : String
    @Published var endDate : String
    @Published var duration : String
    
    init(transcription: String, startDate : String, endDate : String, duration : String) {
        self.transcription = transcription
        self.startDate = startDate
        self.endDate = endDate
        self.duration = duration
    }
}
