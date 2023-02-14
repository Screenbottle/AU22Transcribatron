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
    
    func fetchTranscriptions(uid: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document("\(uid)").collection("personal").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                
            } else {
                self.transcriptions = []
                for document in querySnapshot!.documents {
                        print("\(document.documentID): \(document.data())")
                    let data = document.data()
                    
                    
                    let text = data["transcription"] as? String ?? ""
                    let startDate = data["startdate"] as? String ?? ""
                    let endDate = data["endDate"] as? String ?? ""
                    let duration = data["duration"] as? String ?? ""
                    
                    let transcription = Transcription(transcription: text, startDate: startDate, endDate: endDate, duration: duration)
                        
                    self.transcriptions?.append(transcription)
                }
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
        let docData: [String:Any] = ["transcription": transcription.transcription, "startdate": transcription.startDate, "enddate": transcription.endDate, "duration": transcription.duration]
        
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
    
}
