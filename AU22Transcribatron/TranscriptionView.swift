//
//  TranscriptionView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-14.
//

import SwiftUI

struct TranscriptionView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var firestoreManager: FirestoreManager
    
    @State var editedText = ""
    @State var showToast = false
    
    var transcription: Transcription
    
    var body: some View {
        ZStack {
            VStack {
                TextField("", text: $editedText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
                Button("Save") {
                    saveEdits()
                    showToast = true
                    
                }
                
                
            }
            .padding()
        }
        .toast(message: "Saving edits...",
                     isShowing: $showToast,
                     duration: Toast.short)
        .toolbar {
            ToolbarItem {
                Text(transcription.startDate)
            }
        }
        .onAppear {
            editedText = transcription.transcription
        }
    }
    
    func saveEdits() {
        if let uid = authModel.user?.uid {
            firestoreManager.updateTranscription(uid: uid, name: transcription.startDate, editedText: editedText)
        }
    }
    
}

/*
 struct TranscriptionView_Previews: PreviewProvider {
 static var previews: some View {
 TranscriptionView()
 }
 }
 */
