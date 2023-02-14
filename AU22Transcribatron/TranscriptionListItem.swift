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
        HStack {
            Text("\(transcription.startDate) - \(transcription.endDate)")
        }
    }
}

struct TranscriptionListItem_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptionListItem(transcription: Transcription(transcription: "", startDate: "22/01 2023, 11:20", endDate: "22/01 2023, 12:00", duration: "00:40:00"))
    }
}
