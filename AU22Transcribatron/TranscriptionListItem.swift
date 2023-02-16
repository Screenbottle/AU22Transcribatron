//
//  TranscriptionListItem.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-13.
//

import SwiftUI

struct TranscriptionListItem: View {
    
    var transcription: Transcription
    
    var body: some View {
        VStack {
            Text("\(transcription.startTime) - \(transcription.endTime)")
        }
    }
}

