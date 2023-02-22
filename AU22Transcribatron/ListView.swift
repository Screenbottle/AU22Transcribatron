//
//  ListView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-14.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var firestoreManager: FirestoreManager
    
    @State var selections = ["Personliga", "Delade"]
    @State var choice = 0
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("Background"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            HStack {
                Form {
                    Section {
                        /*Picker("Personlinga/Delade", selection: $choice) {
                            Text(selections[0])
                            Text(selections[1])
                        }
                        .pickerStyle(SegmentedPickerStyle()) */
                        List() {
                            if choice == 0 {
                                if let dateSortedTranscriptions = firestoreManager.dateSortedTranscriptions {
                                    
                                    ForEach(dateSortedTranscriptions) { row in
                                        if let dayMonthYear = row.row.first?.dayMonthYear {
                                            Section(header: Text(dayMonthYear)) {
                                                
                                                ForEach(row.row) {transcription in
                                                    NavigationLink(destination: TranscriptionView(transcription: transcription)
                                                        .environmentObject(authModel)
                                                        .environmentObject(firestoreManager))
                                                    {
                                                        TranscriptionListItem(transcription: transcription)
                                                    }
                                                }
                                            }
                                            .headerProminence(.increased)
                                        }
                                    }
                                    
                                }
                            }
                            else if choice == 1 {
                                if let sharedTranscriptions = firestoreManager.sharedTranscriptions {
                                    
                                    ForEach(sharedTranscriptions) { row in
                                        if let teamName = row.teamName {
                                            Section(header: Text(teamName)) {
                                                ForEach(row.row) {transcription in
                                                    TranscriptionListItem(transcription: transcription)
                                                }
                                            }
                                            .headerProminence(.increased)
                                        }
                                    }
                                    
                                }
                            }
                        }
                        .backgroundStyle(Color("Background"))
                    }
                }
                
            }
            .onAppear {
                if let uid = authModel.user?.uid {
                    firestoreManager.fetchTranscriptions(uid: uid)
                    firestoreManager.fetchSharedTranscriptions(uid: uid)
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
