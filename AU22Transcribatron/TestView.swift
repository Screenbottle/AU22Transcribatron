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
    
    @State var options: [String] = [""]
    @State var selectedItem = ""
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("Background"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            
            VStack {
                Text("\(meetingTimer.timeElapsed)")
                    .font(.largeTitle)
                
                Picker("Välj grupp", selection: $selectedItem) {
                    ForEach(options, id: \.self) { item in
                        Text(item)
                    }
                }
                .disabled(isRecording)
                
                
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
            }
            .padding()
                
            
        }
        .onAppear {
            if let uid = authModel.user?.uid {
                firestoreManager.fetchTeams(uid: uid)
                
                if let teams = firestoreManager.teams {
                    options.append(contentsOf: teams)
                }
            }
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
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            let dmyFormatter = DateFormatter()
            dmyFormatter.dateFormat = "E, d MM, yyyy"
            
            
            if let startDate = meetingTimer.startDate,
               let endDate = meetingTimer.endDate {
                
                let transcription = Transcription(transcription: text, startTime: timeFormatter.string(from: startDate), endTime: timeFormatter.string(from: endDate), duration: meetingTimer.timeElapsed, dayMonthYear: dmyFormatter.string(from: startDate), date: startDate)
                if let uid = authModel.user?.uid {
                    
                    let name = dmyFormatter.string(from: startDate) + " " + timeFormatter.string(from: startDate)
                    if selectedItem.isEmpty {
                        firestoreManager.uploadTranscription(uid: uid, name: name, transcription: transcription)
                    }
                    else {
                        
                    }
                }
                
            }
            
            meetingTimer.resetTimer()
                
            
            
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
