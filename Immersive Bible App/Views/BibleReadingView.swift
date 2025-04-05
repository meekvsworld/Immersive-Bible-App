//
//  BibleReadingView.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/4/25.
//

import SwiftUI

struct BibleReadingView: View {
    @State private var selectedTranslation = "KJV"
    // Removed isAudioPlaying state
    
    // State for theme, font size, and settings menu visibility
    @State private var currentTheme: ReadingTheme = .light
    @State private var fontSize: CGFloat = 18
    @State private var showSettingsMenu = false
    @State private var settingsMenuState: SettingsMenuState = .main // Add state for menu content
    
    // Enum to manage settings menu content
    enum SettingsMenuState {
        case main
        case versionSelect
    }
    
    // Use the full chapter text
    let chapterVerses = matthew1KJV
    
    // Define Button size for padding calculation
    private let settingsButtonSize: CGFloat = 55
    private let settingsButtonPadding: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Main Content Area (Bible Text)
            VStack(spacing: 0) {
                // Top Nav (Still commented out for now)
                // TopNavigationBar(...) 
                
                BibleTextDisplay(
                    chapterTitle: "Matthew 1",
                    verses: chapterVerses,
                    bottomPadding: settingsButtonSize + settingsButtonPadding * 2,
                    fontSize: $fontSize,
                    useSerifFont: .constant(true),
                    currentTheme: $currentTheme
                )
            }
            // Dim content when settings are shown
            .opacity(showSettingsMenu ? 0.3 : 1.0)
            .allowsHitTesting(!showSettingsMenu) // Disable interaction when dimmed
            
            // Dimming Layer
            if showSettingsMenu {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { 
                        withAnimation { 
                            settingsMenuState = .main // Reset state first
                            showSettingsMenu = false 
                        }
                    }
            }
            
            // Settings Gear Button Overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    BottomControls(settingsAction: { 
                        withAnimation { showSettingsMenu.toggle() } 
                    })
                        .padding(settingsButtonPadding)
                }
            }
            
            // Settings Menu Overlay (Pops up from bottom right-ish)
            if showSettingsMenu {
                settingsMenuView
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1) // Ensure menu is on top
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    // Settings Menu View Builder
    @ViewBuilder
    private var settingsMenuView: some View {
        VStack(alignment: .leading) { // Allow content to define spacing
            // Back button for sub-menus
            if settingsMenuState != .main {
                Button(action: { 
                    withAnimation { settingsMenuState = .main } 
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .font(.custom("Menlo-Regular", size: 16))
                .padding(.bottom, 15)
            }
            
            // Content based on state
            switch settingsMenuState {
            case .main:
                mainSettingsItems
                    .transition(.opacity.combined(with: .scale(scale: 0.95))) // Fade/slight scale
            case .versionSelect:
                versionSelectionItems
                    .transition(.opacity.combined(with: .scale(scale: 1.05))) // Fade/slight grow
            }
        }
        .padding(30)
        .background(Color.black.opacity(0.85))
        .cornerRadius(15)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .frame(maxWidth: 250) // Limit width
        // Position near the bottom right, adjust offset as needed
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(.bottom, settingsButtonSize + settingsButtonPadding + 10)
        .padding(.trailing, settingsButtonPadding)
        .id(settingsMenuState) // Ensure transition triggers on state change
    }
    
    // Main Settings Items View Builder
    @ViewBuilder
    private var mainSettingsItems: some View {
        VStack(alignment: .leading, spacing: 20) {
            SettingsMenuItem(label: "Bible Version")
                .onTapGesture {
                    withAnimation { settingsMenuState = .versionSelect }
                }
            SettingsMenuItem(label: "Text Size") // Add action later
            SettingsMenuItem(label: "Voice Selection") // Add action later
        }
    }
    
    // Version Selection Items View Builder
    @ViewBuilder
    private var versionSelectionItems: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(["KJV", "NLT", "AMP"], id: \.self) { version in
                Text(version)
                    .font(.custom("Menlo-Regular", size: 18))
                    .foregroundColor(selectedTranslation == version ? Color.green : Color.white) // Highlight selected
                    .onTapGesture {
                        selectedTranslation = version
                        // Optionally close menu or go back
                        // withAnimation { settingsMenuState = .main } 
                    }
            }
        }
    }
}

// Simple struct for menu item display
struct SettingsMenuItem: View {
    let label: String
    
    var body: some View {
        Text(label)
            .font(.custom("Menlo-Regular", size: 18)) // Coding font
            // Add tap gesture later for actions
    }
}

#Preview {
    BibleReadingView()
}