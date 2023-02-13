//
//  CircleButtonView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-01-30.
//

import SwiftUI

struct CircleButtonView: View {
    
    @Binding var isRecording : Bool
    
    var body: some View {
        ZStack {
            Image(systemName: isRecording ? "stop.circle" : "record.circle")
                .font(.system(size: 100, weight: .light))
                .foregroundColor(Color("RecordStop"))
        }
        .background(
        ZStack {
            Circle()
                .fill(Color("Background"))
                .frame(width: 300, height: 300)
                .shadow(color: Color("LightShadow"), radius: 8, x:-8, y: -8)
                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
        }
        
        )
    }
}
/*
struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(isRecording: )
    }
}
*/
