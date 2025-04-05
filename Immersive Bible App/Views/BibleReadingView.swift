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
    @State private var settingsMenuState: SettingsMenuState = .main
    @State private var showBookSelector = false
    @State private var showVersionSelector = false // State for version selector overlay
    
    // Demo book list
    let books = ["Matthew", "Mark", "Luke", "John"]
    @State private var selectedBook = "Matthew" // Add state for selected book
    
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
        ZStack { // Main ZStack for layering
            // Layer 1: Main Content Area (Bible Text)
            VStack(spacing: 0) {
                // Top Nav (Still commented out for now)
                // TopNavigationBar(...) 
                
                BibleTextDisplay(
                    chapterTitle: "\(selectedBook) 1",
                    verses: chapterVerses,
                    bottomPadding: settingsButtonSize + settingsButtonPadding * 2,
                    fontSize: $fontSize,
                    useSerifFont: .constant(true),
                    currentTheme: $currentTheme,
                    showBookSelector: $showBookSelector,
                    selectedTranslation: $selectedTranslation,
                    showVersionSelector: $showVersionSelector
                )
            }
            // Dim content when settings OR book selector are shown
            .opacity(showSettingsMenu || showBookSelector ? 0.3 : 1.0)
            .allowsHitTesting(!(showSettingsMenu || showBookSelector)) // Disable interaction when dimmed
            
            // Layer 2: Dimming Layer (Common for both overlays)
            if showSettingsMenu || showBookSelector || showVersionSelector {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { 
                        // Dismiss whichever overlay is active
                        withAnimation { 
                            if showSettingsMenu {
                                settingsMenuState = .main // Reset state first
                                showSettingsMenu = false 
                            }
                            if showBookSelector {
                                showBookSelector = false
                            }
                            if showVersionSelector {
                                showVersionSelector = false
                            }
                        }
                    }
                    // Ensure dimming layer is below the menus/selectors
                    .zIndex(0) 
            }
            
            // Layer 3: Settings Gear Button Overlay
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
            .zIndex(1) // Ensure button is above dimming, below menus
            
            // Layer 4: Settings Menu Overlay
            if showSettingsMenu {
                settingsMenuView
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(2) // Ensure menu is on top
            }
            
            // Layer 5: Book Selector Overlay
            if showBookSelector {
                bookSelectorView
                    .transition(.opacity.combined(with: .scale)) 
                    .zIndex(2)
            }
            
            // Layer 6: Version Selector Overlay
            if showVersionSelector {
                versionSelectorView
                    .transition(.opacity) // Simple fade for this one?
                    .zIndex(3) // Ensure it's on top of everything else
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
    
    // Book Selector View Builder
    @ViewBuilder
    private var bookSelectorView: some View {
        VStack(spacing: 20) {
            ForEach(books, id: \.self) { book in
                Text(book)
                    .font(.custom("Menlo-Regular", size: 20))
                    .foregroundColor(selectedBook == book ? Color.green : Color.white)
                    .onTapGesture {
                        selectedBook = book
                        // Add logic here later to load the new book/chapter data
                        withAnimation { showBookSelector = false } // Dismiss selector
                    }
            }
        }
        // Center the VStack on the screen
        .frame(maxWidth: .infinity, maxHeight: .infinity) 
        // Styling (similar to settings menu but distinct?)
        // No explicit background needed if dimming layer is used
    }
    
    // Version Selector View Builder
    @ViewBuilder
    private var versionSelectorView: some View {
        // Use a ZStack to layer the content over the dismissable background
        ZStack {
            // Semi-Transparent Background (Dismisses on tap)
            Color.black.opacity(0.75) // Adjust opacity as desired
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { 
                    withAnimation { showVersionSelector = false } 
                }
            
            // Content VStack
            VStack(spacing: 20) {
                // Example versions (adjust as needed)
                ForEach(["KJV", "NLT", "AMP"], id: \.self) { version in 
                    Text(version)
                        .font(.custom("Menlo-Regular", size: 20))
                        .foregroundColor(selectedTranslation == version ? Color.green : Color.white)
                        .padding(.vertical, 5) // Add padding for easier tapping
                        .contentShape(Rectangle()) // Ensure gesture covers padding
                        .onTapGesture {
                            selectedTranslation = version
                            withAnimation { showVersionSelector = false } // Dismiss selector
                        }
                }
            }
            .padding(40)
            // Center the VStack on the screen (already done by ZStack alignment)
        }
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