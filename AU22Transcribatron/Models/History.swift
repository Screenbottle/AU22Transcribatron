//
//  History.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-01-26.
//

/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    var attendees: [DailyScrum.Attendee]
    var lengthInMinutes: Int
    var transcript: String?

    init(id: UUID = UUID(), date: Date = Date(), attendees: [DailyScrum.Attendee], lengthInMinutes: Int = 5, transcript: String? = nil) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.transcript = transcript
    }
}
