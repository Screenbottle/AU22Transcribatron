//
//  TestView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-01-30.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct TestView: View {
    
    @EnvironmentObject var authModel: AuthViewModel
    @EnvironmentObject private var firestoreManager: FirestoreManager
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    @StateObject var meetingTimer = MeetingTimer()
    @State var circleTapped = false
    @State private var isRecording = false
    @State private var text = ""
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("Background"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            
            VStack {
                Text("\(meetingTimer.timeElapsed)")
                
                Spacer()
                
                CircleButtonView( isRecording: $isRecording
                )
                .scaleEffect(circleTapped ? 1.1 : 1)
                .onTapGesture(count: 1) {
                    
                    if !self.circleTapped {
                        Transcriber()
                    }
                        
                    self.circleTapped = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.circleTapped = false
                    }
                }
                
                Spacer()
                
                Text("\(text)")
            }
            .padding()
                
            
        }
        
        .onDisappear {
            meetingTimer.stopTimer()
            speechRecognizer.stopTranscribing()
        }
        
    }
    
    func Transcriber() {
        if isRecording {
            speechRecognizer.stopTranscribing()
            isRecording.toggle()
            meetingTimer.stopTimer()
            text = speechRecognizer.transcript
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM y, HH:mm"
            
            
            if let startDate = meetingTimer.startDate,
               let endDate = meetingTimer.endDate {
                
                let transcription = Transcription(transcription: text, startDate: dateFormatter.string(from: startDate), endDate: dateFormatter.string(from: endDate), duration: meetingTimer.timeElapsed)
                if let uid = authModel.user?.uid {
                    firestoreManager.uploadTranscription(uid: uid, name: dateFormatter.string(from: startDate), transcription: transcription)
                }
                
            }
                
            
            
        }
        else {
            speechRecognizer.reset()
            speechRecognizer.transcribe()
            isRecording.toggle()
            meetingTimer.startTimer()
        }
        
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
