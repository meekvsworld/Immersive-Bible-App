//
//  BibleTextDisplay.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/4/25.
//

import SwiftUI

// MARK: - Theme Definitions
enum ReadingTheme {
    case light, dark, sepia
    
    var backgroundColor: Color {
        switch self {
        case .light: return Color(.systemBackground)
        case .dark: return Color.black
        case .sepia: return Color(red: 0.96, green: 0.93, blue: 0.86)
        }
    }
    
    // Optional: Define a separate color for the verse box background
    var verseBoxBackgroundColor: Color {
        switch self {
        case .light: return Color.white // White box on system background
        case .dark: return Color(white: 0.1) // Dark gray box on black
        case .sepia: return Color.white.opacity(0.7) // Slightly transparent white on sepia
        }
    }
    
    var textColor: Color {
        switch self {
        case .light: return Color.black
        case .dark: return Color.white
        case .sepia: return Color(red: 0.3, green: 0.2, blue: 0.1)
        }
    }
    
    var verseNumberColor: Color {
        switch self {
        case .light: return Color.gray.opacity(0.8)
        case .dark: return Color.gray
        case .sepia: return Color(red: 0.5, green: 0.4, blue: 0.3)
        }
    }
    
    var highlightColor: Color { // Changed to Green
        switch self {
        case .light: return Color.green.opacity(0.2)
        case .dark: return Color.green.opacity(0.3)
        case .sepia: return Color.green.opacity(0.3)
        }
    }
}

struct BibleTextDisplay: View {
    let chapterTitle: String
    let verses: [String]
    
    // State for Features (Would move to App Settings/State)
    @State private var selectedVerseIndex: Int? = nil
    @State private var fontSize: CGFloat = 18 // Example: Make configurable
    @State private var useSerifFont: Bool = true // Example: Make configurable
    @State private var currentTheme: ReadingTheme = .light // Example: Make configurable
    @State private var scrollProgress: CGFloat = 0
    
    // Constants for Verse Styling
    private let verseNumberFontSize: CGFloat = 11
    private let verseNumberWidth: CGFloat = 25
    private let verseBoxCornerRadius: CGFloat = 8
    private let verseBoxShadowRadius: CGFloat = 2
    private let verseBoxShadowY: CGFloat = 1
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Reading Progress Bar
                ProgressView(value: scrollProgress)
                    .progressViewStyle(.linear)
                    .tint(currentTheme.textColor.opacity(0.5))
                    .padding(.horizontal)
                    .padding(.top, 5)
                
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // Chapter Title
                            Text(chapterTitle)
                                .font(.system(size: fontSize + 10, weight: .bold))
                                .padding(.horizontal, adaptiveHorizontalPadding(geometry.size.width))
                                .padding(.top, 24)
                                .padding(.bottom, 16)
                                .foregroundColor(currentTheme.textColor)
                            
                            // Verses - Use LazyVStack for potentially better performance with many boxes
                            LazyVStack(alignment: .leading, spacing: 12) { // Spacing between verse boxes
                                ForEach(Array(verses.enumerated()), id: \.offset) { index, verse in
                                    // Verse Box Container
                                    HStack(alignment: .top, spacing: 8) {
                                        // Verse Number
                                        Text("\(index + 1)")
                                            .font(.system(size: verseNumberFontSize))
                                            .foregroundColor(currentTheme.verseNumberColor)
                                            .frame(width: verseNumberWidth, alignment: .leading)
                                            .padding(.top, fontSize * 0.15)
                                        
                                        // Verse Text
                                        Text(verse)
                                            .font(fontForCurrentStyle())
                                            .tracking(calculatedTracking())
                                            .foregroundColor(currentTheme.textColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(12) // Padding inside the box
                                    .background(
                                        // Apply highlight color first if selected
                                        (index == selectedVerseIndex ? currentTheme.highlightColor : Color.clear)
                                            // Then apply the box background color over it
                                            .background(currentTheme.verseBoxBackgroundColor)
                                    )
                                    .cornerRadius(verseBoxCornerRadius)
                                    .shadow(color: Color.black.opacity(0.1), radius: verseBoxShadowRadius, x: 0, y: verseBoxShadowY)
                                    .contentShape(Rectangle()) // Make tappable
                                    .onTapGesture {
                                        selectedVerseIndex = (selectedVerseIndex == index) ? nil : index
                                    }
                                    .id(index) // ID for ScrollViewReader
                                    .padding(.top, isNewParagraph(index) ? 10 : 0) // Add space before paragraph starts
                                }
                            }
                            .padding(.horizontal, adaptiveHorizontalPadding(geometry.size.width))
                            .padding(.bottom, 24)
                            // Geometry Reader for Scroll Progress Calculation
                            .background(
                                GeometryReader { contentGeo -> Color in
                                    DispatchQueue.main.async {
                                        let scrollViewHeight = geometry.size.height
                                        let contentHeight = contentGeo.size.height
                                        let scrollOffset = -contentGeo.frame(in: .named("scrollCoords")).minY
                                        
                                        if contentHeight > scrollViewHeight {
                                            self.scrollProgress = min(max(0, scrollOffset / (contentHeight - scrollViewHeight)), 1)
                                        } else {
                                            self.scrollProgress = 0
                                        }
                                    }
                                    return Color.clear
                                }
                            )
                        }
                    }
                    .coordinateSpace(name: "scrollCoords")
                }
            }
            .background(currentTheme.backgroundColor)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    // Helper Functions
    private func fontForCurrentStyle() -> Font {
        let baseFont: Font = useSerifFont ? .custom("NewYork-Regular", size: fontSize) : .system(size: fontSize)
        return baseFont
    }
    
    private func calculatedLineSpacing() -> CGFloat {
        return fontSize * 0.5
    }
    
    private func calculatedTracking() -> CGFloat {
        return -0.1
    }
    
    private func adaptiveHorizontalPadding(_ width: CGFloat) -> CGFloat {
        return max(15, width * 0.05)
    }
    
    private func isNewParagraph(_ index: Int) -> Bool {
        // --- Placeholder Logic --- 
        return index == 2
    }
    
    private func cycleTheme() -> ReadingTheme {
        switch currentTheme {
        case .light: return .sepia
        case .sepia: return .dark
        case .dark: return .light
        }
    }
}

#Preview {
    BibleTextDisplay(
        chapterTitle: "Matthew 1",
        verses: [
            "The book of the generation of Jesus Christ, the son of David, the son of Abraham.",
            "Abraham begat Isaac; and Isaac begat Jacob; and Jacob begat Judas and his brethren;",
            "And Judas begat Phares and Zara of Thamar; and Phares begat Esrom; and Esrom begat Aram;",
            "And Aram begat Aminadab; and Aminadab begat Naasson; and Naasson begat Salmon;",
            "And Salmon begat Booz of Rachab; and Booz begat Obed of Ruth; and Obed begat Jesse;",
            "And Jesse begat David the king; and David the king begat Solomon of her that had been the wife of Urias;"
        ]
    )
} 