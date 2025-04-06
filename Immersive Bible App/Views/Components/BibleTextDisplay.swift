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
        case .light: return Color.gray
        case .dark: return Color(white: 0.6)
        case .sepia: return Color(red: 0.4, green: 0.3, blue: 0.2)
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
    let bottomPadding: CGFloat
    
    // Bindings passed from parent
    @Binding var fontSize: CGFloat
    @Binding var useSerifFont: Bool
    @Binding var currentTheme: ReadingTheme
    @Binding var showBookSelector: Bool
    @Binding var selectedTranslation: String
    @Binding var showVersionSelector: Bool
    
    // Keep local state for things only this view manages
    @State private var selectedVerseIndex: Int? = nil
    @State private var scrollProgress: CGFloat = 0
    @State private var currentTopVerseIndex: Int = 0
    
    // Constants for Verse Styling
    private let verseNumberFontSize: CGFloat = 11
    private let verseNumberLeadingPadding: CGFloat = 1 // Unused for positioning
    private let verseNumberReservedWidth: CGFloat = 25 // Ensure this is 25
    private let verseBoxCornerRadius: CGFloat = 8
    private let verseBoxShadowRadius: CGFloat = 2
    private let verseBoxShadowY: CGFloat = 1
    
    // Define the font size steps
    let fontSizes: [CGFloat] = [16, 18, 21, 24] // Small, Medium, Large, XLarge
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Info Bar (Version | Book | Progress | Count)
                HStack(spacing: 8) { // Reduced spacing for tighter group
                    // Version Selector Trigger Button
                    Button { 
                        showVersionSelector.toggle() 
                    } label: {
                        Text(selectedTranslation)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(currentTheme.textColor)
                    }
                    
                    // Separator
                    Text("|")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(currentTheme.textColor.opacity(0.5))
                    
                    // Book Selector Trigger Button
                    Button {
                        showBookSelector.toggle()
                    } label: {
                        // You'll need a way to get the abbreviation for the selected book
                        // For now, we'll hardcode "Matt" for demonstration
                        Text("Matt") // Placeholder for book abbreviation
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(currentTheme.textColor)
                    }
                    
                    // REMOVED: Text Size Cycle Button
                    // REMOVED: Theme Toggle Button (Lightbulb)
                    
                    // Spacer to push progress/count right
                    Spacer()
                    
                    // Progress Bar (Takes up remaining space)
                    ProgressView(value: scrollProgress)
                        .progressViewStyle(.linear)
                        .tint(Color.green)
                    
                    // Verse Count
                    if !verses.isEmpty {
                        Text("Verse \(currentTopVerseIndex + 1)/\(verses.count)")
                            .font(.system(size: 12))
                            .foregroundColor(currentTheme.textColor.opacity(0.7))
                            .frame(minWidth: 65, alignment: .trailing)
                            .layoutPriority(1)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .frame(height: 30)
                
                Divider().background(currentTheme.textColor.opacity(0.2))
                
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // Chapter Title (Remove Hamburger Button Here)
                            Text(chapterTitle)
                                .font(.system(size: fontSize + 10, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                                .foregroundColor(currentTheme.textColor)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation { showBookSelector.toggle() }
                                }
                                .padding(.horizontal, adaptiveHorizontalPadding(geometry.size.width))
                                .padding(.top, 24)
                                .padding(.bottom, 16)
                            
                            // Verses
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(verses.enumerated()), id: \.offset) { index, verse in
                                    ZStack(alignment: .leading) {
                                        // Layer 1: Verse Number
                                        Text("\(index + 1)")
                                            .font(.system(size: verseNumberFontSize))
                                            .foregroundColor(currentTheme.verseNumberColor)
                                            .frame(width: verseNumberReservedWidth, alignment: .leading) // Use constant
                                            .padding(.top, 14)
                                            
                                        // Layer 2: Verse Text Card
                                        Text(verse)
                                            .font(fontForCurrentStyle())
                                            .tracking(calculatedTracking())
                                            .lineSpacing(calculatedLineSpacing())
                                            .foregroundColor(currentTheme.textColor)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 14)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .background(
                                                (index == selectedVerseIndex ? currentTheme.highlightColor : Color.clear)
                                                    .background(currentTheme.verseBoxBackgroundColor)
                                            )
                                            .cornerRadius(verseBoxCornerRadius)
                                            .shadow(color: Color.black.opacity(0.15), radius: verseBoxShadowRadius, x: 0, y: verseBoxShadowY)
                                            .padding(.leading, verseNumberReservedWidth)
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture { selectedVerseIndex = (selectedVerseIndex == index) ? nil : index }
                                    .id(index)
                                    .padding(.top, isNewParagraph(index) ? 10 : 0)
                                }
                            }
                            .padding(.horizontal, adaptiveHorizontalPadding(geometry.size.width))
                            .padding(.bottom, bottomPadding)
                            .background(
                                GeometryReader { contentGeo -> Color in
                                    DispatchQueue.main.async {
                                        let scrollViewHeight = geometry.size.height
                                        let contentHeight = contentGeo.size.height
                                        let scrollOffset = -contentGeo.frame(in: .named("scrollCoords")).minY
                                        
                                        // Update Scroll Progress
                                        if contentHeight > scrollViewHeight {
                                            self.scrollProgress = min(max(0, scrollOffset / (contentHeight - scrollViewHeight)), 1)
                                        } else {
                                            self.scrollProgress = 0
                                        }
                                        
                                        // Update Current Top Verse Index (Estimate based on progress)
                                        // More accurate methods exist (checking frame visibility), but this is simpler
                                        if contentHeight > 0 && !verses.isEmpty {
                                            let estimatedVerse = Int((scrollOffset / contentHeight) * CGFloat(verses.count))
                                            self.currentTopVerseIndex = min(max(0, estimatedVerse), verses.count - 1)
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
        }
    }
    
    // Helper Functions
    private func fontForCurrentStyle() -> Font {
        let baseFont: Font = useSerifFont ? .custom("NewYork-Regular", size: fontSize) : .system(size: fontSize)
        return baseFont
    }
    
    private func calculatedLineSpacing() -> CGFloat {
        return fontSize * 0.45
    }
    
    private func calculatedTracking() -> CGFloat {
        return -0.1
    }
    
    private func adaptiveHorizontalPadding(_ width: CGFloat) -> CGFloat {
        // Ensure minimum padding is 8
        return max(8, width * 0.05)
    }
    
    private func isNewParagraph(_ index: Int) -> Bool {
        // --- Placeholder Logic --- 
        return index == 2
    }
    
    private func cycleTheme() {
        switch currentTheme {
        case .light: currentTheme = .dark
        case .dark: currentTheme = .light
        case .sepia: currentTheme = .light // Example: Sepia goes back to light
        }
    }
    
    private func cycleFontSize() {
        guard let currentIndex = fontSizes.firstIndex(of: fontSize) else {
            fontSize = fontSizes[1] // Default to medium
            return
        }
        let nextIndex = (currentIndex + 1) % fontSizes.count
        fontSize = fontSizes[nextIndex]
    }
}

// Data for Preview
let matthew1KJV = [
    "The book of the generation of Jesus Christ, the son of David, the son of Abraham.", // 1
    "Abraham begat Isaac; and Isaac begat Jacob; and Jacob begat Judas and his brethren;", // 2
    "And Judas begat Phares and Zara of Thamar; and Phares begat Esrom; and Esrom begat Aram;", // 3
    "And Aram begat Aminadab; and Aminadab begat Naasson; and Naasson begat Salmon;", // 4
    "And Salmon begat Booz of Rachab; and Booz begat Obed of Ruth; and Obed begat Jesse;", // 5
    "And Jesse begat David the king; and David the king begat Solomon of her that had been the wife of Urias;", // 6
    "And Solomon begat Roboam; and Roboam begat Abia; and Abia begat Asa;", // 7
    "And Asa begat Josaphat; and Josaphat begat Joram; and Joram begat Ozias;", // 8
    "And Ozias begat Joatham; and Joatham begat Achaz; and Achaz begat Ezekias;", // 9
    "And Ezekias begat Manasses; and Manasses begat Amon; and Amon begat Josias;", // 10
    "And Josias begat Jechonias and his brethren, about the time they were carried away to Babylon:", // 11
    "And after they were brought to Babylon, Jechonias begat Salathiel; and Salathiel begat Zorobabel;", // 12
    "And Zorobabel begat Abiud; and Abiud begat Eliakim; and Eliakim begat Azor;", // 13
    "And Azor begat Sadoc; and Sadoc begat Achim; and Achim begat Eliud;", // 14
    "And Eliud begat Eleazar; and Eleazar begat Matthan; and Matthan begat Jacob;", // 15
    "And Jacob begat Joseph the husband of Mary, of whom was born Jesus, who is called Christ.", // 16
    "So all the generations from Abraham to David are fourteen generations; and from David until the carrying away into Babylon are fourteen generations; and from the carrying away into Babylon unto Christ are fourteen generations.", // 17
    "Now the birth of Jesus Christ was on this wise: When as his mother Mary was espoused to Joseph, before they came together, she was found with child of the Holy Ghost.", // 18
    "Then Joseph her husband, being a just man, and not willing to make her a public example, was minded to put her away privily.", // 19
    "But while he thought on these things, behold, the angel of the Lord appeared unto him in a dream, saying, Joseph, thou son of David, fear not to take unto thee Mary thy wife: for that which is conceived in her is of the Holy Ghost.", // 20
    "And she shall bring forth a son, and thou shalt call his name JESUS: for he shall save his people from their sins.", // 21
    "Now all this was done, that it might be fulfilled which was spoken of the Lord by the prophet, saying,", // 22
    "Behold, a virgin shall be with child, and shall bring forth a son, and they shall call his name Emmanuel, which being interpreted is, God with us.", // 23
    "Then Joseph being raised from sleep did as the angel of the Lord had bidden him, and took unto him his wife:", // 24
    "And knew her not till she had brought forth her firstborn son: and he called his name JESUS." // 25
]

#Preview {
    StatefulPreviewWrapper_BibleText { $fontSize, $useSerifFont, $theme, $showBookSelector, $selectedTranslation, $showVersionSelector in
        BibleTextDisplay(
            chapterTitle: "Matthew 1",
            verses: matthew1KJV,
            bottomPadding: 80,
            fontSize: $fontSize,
            useSerifFont: $useSerifFont,
            currentTheme: $theme,
            showBookSelector: $showBookSelector,
            selectedTranslation: $selectedTranslation,
            showVersionSelector: $showVersionSelector
        )
    }
}

// Helper Wrapper for Preview with multiple state bindings
struct StatefulPreviewWrapper_BibleText<Content: View>: View {
    @State private var fontSize: CGFloat = 18
    @State private var useSerifFont: Bool = true
    @State private var currentTheme: ReadingTheme = .light
    @State private var showBookSelector: Bool = false
    @State private var selectedTranslation: String = "KJV"
    @State private var showVersionSelector: Bool = false
    var content: (Binding<CGFloat>, Binding<Bool>, Binding<ReadingTheme>, Binding<Bool>, Binding<String>, Binding<Bool>) -> Content

    var body: some View {
        content($fontSize, $useSerifFont, $currentTheme, $showBookSelector, $selectedTranslation, $showVersionSelector)
    }
} 