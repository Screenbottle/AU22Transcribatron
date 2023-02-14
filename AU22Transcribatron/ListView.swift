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
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("Background"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            HStack {
                List() {
                    if let transcriptions = firestoreManager.transcriptions {
                        ForEach(transcriptions) {transcription in
                            NavigationLink(destination: TranscriptionView(transcription: transcription)
                                .environmentObject(authModel)
                                .environmentObject(firestoreManager))
                            {
                                TranscriptionListItem(transcription: transcription)
                            }
                        }
                        
                    }
                }
                .backgroundStyle(Color("Background"))
                
            }
            .onAppear {
                if let uid = authModel.user?.uid {
                    firestoreManager.fetchTranscriptions(uid: uid)
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
