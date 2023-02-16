//
//  FireStoreManager.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-09.
//

import Foundation
import Firebase

class FirestoreManager: ObservableObject {

    @Published var transcriptions: [Transcription]?
    @Published var dateSortedTranscriptions: [TranscriptionRow]?
    
    func fetchTranscriptions(uid: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document("\(uid)").collection("personal").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                
            } else {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E, d MM, yyyy HH:mm"
                
                self.transcriptions = []
                for document in querySnapshot!.documents {
                        //print("\(document.documentID): \(document.data())")
                    let data = document.data()
                    
                    
                    let text = data["transcription"] as? String ?? ""
                    let startTime = data["startTime"] as? String ?? ""
                    let endTime = data["endTime"] as? String ?? ""
                    let duration = data["duration"] as? String ?? ""
                    let dayMonthYear = data["dayMonthYear"] as? String ?? ""
                    
                    let fullDateString = dayMonthYear + " " + startTime
                    
                    if let date = dateFormatter.date(from: fullDateString) {
                        
                        let transcription = Transcription(transcription: text, startTime: startTime, endTime: endTime, duration: duration, dayMonthYear: dayMonthYear, date: date)
                        
                        self.transcriptions?.append(transcription)
                    }
                }
                
                self.sortByDate()
            }
        }
    }
    
    func updateTranscription(uid: String, name: String, editedText: String) {
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid).collection("personal").document(name)
        
        docRef.updateData(["transcription": editedText]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            }
            else {
                print("Document successfully updated!")
            }
        }
    }
    
    func uploadTranscription(uid: String, name: String, transcription: Transcription) {
        let db = Firestore.firestore()
        let docData: [String:Any] = ["transcription": transcription.transcription, "startTime": transcription.startTime, "endTime": transcription.endTime, "duration": transcription.duration, "dayMonthYear": transcription.dayMonthYear]
        
        let docRef = db.collection("users").document(uid).collection("personal").document(name)
        
        docRef.setData(docData) {error in
            if let error = error {
                print("Error writing data: \(error.localizedDescription)")
            }
            else {
                print("Data successfully written")
            }
        }
        
        
    }
    
    func sortByDate() {
        print("is run")
        if let transcriptions = self.transcriptions {
            
            print("gets run more")
            self.dateSortedTranscriptions = []
            
            var row = TranscriptionRow()
            
            for transcription in transcriptions {
                if transcription.dayMonthYear == row.row.last?.dayMonthYear || row.row.isEmpty {
                    row.row.append(transcription)
                    
                    print(row.row as Any)
                }
                else {
                    self.dateSortedTranscriptions?.append(row)
                    row = TranscriptionRow()
                    row.row.append(transcription)
                    
                    
                }
            }
            
            self.dateSortedTranscriptions?.append(row)
        }
        
    }
    
}
