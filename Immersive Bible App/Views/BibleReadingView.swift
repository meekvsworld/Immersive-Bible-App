//
//  BibleReadingView.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/4/25.
//

import SwiftUI

struct BibleReadingView: View {
    @State private var selectedTranslation = "KJV"
    @State private var isAudioPlaying = false
    @State private var showAmbientSoundPicker = false
    
    // Sample data - will be replaced with actual data later
    let sampleVerses = [
        "The book of the generation of Jesus Christ, the son of David, the son of Abraham.",
        "Abraham begat Isaac; and Isaac begat Jacob; and Jacob begat Judas and his brethren;"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TopNavigationBar(selectedTranslation: $selectedTranslation)
            
            BibleTextDisplay(
                chapterTitle: "Matthew 1",
                verses: sampleVerses
            )
            
            BottomControls(
                isAudioPlaying: $isAudioPlaying,
                showAmbientSoundPicker: $showAmbientSoundPicker
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    BibleReadingView()
} 