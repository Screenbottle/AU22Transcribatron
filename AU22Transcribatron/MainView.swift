//
//  MainView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-09.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var firestoreManager: FirestoreManager
    var body: some View {
        NavigationView {
            
            List() {
                if let transcriptions = firestoreManager.transcriptions {
                    ForEach(transcriptions) {transcription in
                        Text(transcription.transcription)
                    }
                    
                }
            }
            .navigationBarItems(trailing:
            NavigationLink(destination: TestView()
                .environmentObject(AuthViewModel())
                .environmentObject(FirestoreManager())) {
                Image(systemName: "mic.fill")
            })
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
