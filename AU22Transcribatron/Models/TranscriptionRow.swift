//
//  TranscriptionRow.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-16.
//

import Foundation

class TranscriptionRow: Identifiable {
    var uuid = UUID()
    var row: [Transcription] = []
}
