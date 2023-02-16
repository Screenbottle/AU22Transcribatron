//
//  CalendarView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-16.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var firestoreManager: FirestoreManager
    
    @State private var date = Date.now
    
    let heightRatio: CGFloat = 0.5

    var body: some View {
        GeometryReader { geo in
            VStack {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(
                        GraphicalDatePickerStyle()
                    )
                    .frame(height: geo.size.height * heightRatio, alignment: .top)
                
                List() {
                    if let allTranscriptions = firestoreManager.transcriptions {
                        ForEach(allTranscriptions) { transcription in
                            
                            if dateChecker(date1: transcription.date, date2: date) {
                                NavigationLink(destination: TranscriptionView(transcription: transcription)
                                    .environmentObject(authModel)
                                    .environmentObject(firestoreManager))
                                {
                                    TranscriptionListItem(transcription: transcription)
                                }
                            }
                        }
                        
                    }
                }
                .frame(height: geo.size.height * heightRatio, alignment: .bottom)
            }
        }
        .onAppear {
            if let uid = authModel.user?.uid {
                firestoreManager.fetchTranscriptions(uid: uid)
            }
        }
    }
    
    func dateChecker(date1: Date, date2: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"
        
        return formatter.string(from: date1) == formatter.string(from: date2)
    }
}


