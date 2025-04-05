//
//  TopNavigationBar.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/4/25.
//

import SwiftUI

struct TopNavigationBar: View {
    // Bindings to control state in the parent view
    @Binding var selectedTranslation: String
    @Binding var currentTheme: ReadingTheme
    @Binding var fontSize: CGFloat
    
    let translations = ["KJV", "ESV", "NLT", "AMP"]
    // Define the font size steps
    let fontSizes: [CGFloat] = [16, 18, 21] // Small, Medium, Large
    
    var body: some View {
        HStack {
            // Translation Selector
            Menu {
                ForEach(translations, id: \.self) { translation in
                    Button(translation) {
                        selectedTranslation = translation
                    }
                }
            } label: {
                HStack {
                    Text(selectedTranslation)
                        .font(.system(size: 16, weight: .medium))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                }
            }
            
            Spacer()
            
            // Theme Toggle Button (Lightbulb)
            Button(action: cycleTheme) {
                // Icon changes based on theme (example)
                Image(systemName: currentTheme == .dark ? "lightbulb.slash" : "lightbulb")
                    .font(.system(size: 18))
            }
            .padding(.horizontal, 8)
            
            // Text Size Cycle Button
            Button(action: cycleFontSize) {
                Image(systemName: "textformat.size")
                    .font(.system(size: 18))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8) // Reduced vertical padding for thinner bar
        .frame(height: 44) // Set a thinner fixed height
        .background(Color.black) // Black background
        .foregroundColor(.white) // White text/icons
        // No shadow needed for a simple thin bar
    }
    
    // Helper function to cycle theme
    private func cycleTheme() {
        switch currentTheme {
        case .light: currentTheme = .sepia
        case .sepia: currentTheme = .dark
        case .dark: currentTheme = .light
        }
    }
    
    // Helper function to cycle font size
    private func cycleFontSize() {
        guard let currentIndex = fontSizes.firstIndex(of: fontSize) else {
            // If current size isn't one of the steps, default to the middle size
            fontSize = fontSizes[1]
            return
        }
        
        let nextIndex = (currentIndex + 1) % fontSizes.count
        fontSize = fontSizes[nextIndex]
    }
}

// Preview needs updated bindings
#Preview {
    StatefulPreviewWrapper_TopNav { $translation, $theme, $size in // Use the specific wrapper and accept bindings
        VStack {
            TopNavigationBar(
                selectedTranslation: $translation,
                currentTheme: $theme,
                fontSize: $size
            )
            Spacer() // Push to top for preview
        }
        .background(Color.gray) // Add background to see bar
    }
}

// Helper Wrapper specifically for TopNavigationBar Previews
struct StatefulPreviewWrapper_TopNav<Content: View>: View {
    @State private var translation = "KJV"
    @State private var theme = ReadingTheme.light
    @State private var size: CGFloat = 18
    // Closure accepts the three specific bindings
    var content: (Binding<String>, Binding<ReadingTheme>, Binding<CGFloat>) -> Content

    var body: some View {
        // Provide the bindings to the content closure
        content($translation, $theme, $size)
    }
} 