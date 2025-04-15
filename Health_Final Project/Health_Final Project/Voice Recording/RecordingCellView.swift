//
//  RecordingCellView.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 15/04/2025.
//


import SwiftUI

struct RecordingCellView: View {
    let recording: Recording

    var body: some View {
        NavigationLink(destination: PlaybackView(recording: recording)) {
            VStack(alignment: .leading) {
                Text(recording.date, style: .date)
                    .font(.headline)
                Text(recording.transcription)
                    .lineLimit(2)
                    .font(.subheadline)
            }
            .padding(.vertical, 8)
        }
    }
}

struct RecordingCellView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingCellView(recording: Recording.example)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
