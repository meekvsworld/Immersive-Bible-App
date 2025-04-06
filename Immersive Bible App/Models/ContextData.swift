//
//  ContextData.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/6/25.
//

import Foundation

// Represents a single item within a context category
struct ContextItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
}

// Represents a category of context information
struct ContextCategory: Identifiable {
    let id = UUID()
    let title: String
    let icon: String // Emoji or SF Symbol name
    let items: [ContextItem]
}

// Holds all context for a specific reference (e.g., chapter)
struct ChapterContext {
    let referenceTitle: String // e.g., "Matthew Chapter 1"
    let categories: [ContextCategory]
}

// --- Sample Data (Define globally here for easy access by previews/views for now) ---
// Ideally, this would come from a DataManager or similar service later
let sampleMatthew1Context = ChapterContext(
    referenceTitle: "Matthew Chapter 1",
    categories: [
        ContextCategory(title: "People", icon: "👤", items: [
            ContextItem(name: "Jesus", description: "Central figure; the Messiah."),
            ContextItem(name: "Mary", description: "Mother of Jesus."),
            ContextItem(name: "Joseph", description: "Legal father of Jesus."),
            ContextItem(name: "David", description: "Part of Jesus' lineage."),
            ContextItem(name: "Abraham", description: "Ancestor; father of the Hebrew nation.")
        ]),
        ContextCategory(title: "Places", icon: "🗺️", items: [
            ContextItem(name: "Bethlehem", description: "Birthplace of Jesus (implied context)."),
            ContextItem(name: "Babylon", description: "Referenced during the exile period in genealogy."),
            ContextItem(name: "Israel", description: "The national and cultural setting.")
        ]),
        ContextCategory(title: "Things", icon: "📦", items: [
            ContextItem(name: "Genealogy", description: "A list tracing Jesus' ancestry."),
            ContextItem(name: "Betrothal", description: "Jewish engagement custom relevant to Mary and Joseph."),
            ContextItem(name: "Angel", description: "Appears to Joseph in a dream."),
            ContextItem(name: "Holy Ghost", description: "Source of Mary's conception.")
        ]),
        ContextCategory(title: "Timeline", icon: "🕰️", items: [
            ContextItem(name: "Circa 4–6 BC", description: "Estimated timeframe of Jesus' birth."),
            ContextItem(name: "Roman Occupation", description: "Judea was under Roman rule."),
            ContextItem(name: "Genealogy Period", description: "Covers generations from Abraham to Christ.")
        ]),
        ContextCategory(title: "Lineage / Ancestry", icon: "🧬", items: [
            ContextItem(name: "Son of David, Son of Abraham", description: "Titles emphasizing Jesus' rightful heritage."),
            ContextItem(name: "Generational Structure", description: "Organized into three sets of 14 generations.")
        ]),
        ContextCategory(title: "Fulfilled Prophecies", icon: "🔮", items: [
            ContextItem(name: "Isaiah 7:14", description: "Prophecy of a virgin birth (quoted in verse 23).")
        ]),
        ContextCategory(title: "Historical Setting", icon: "🏛️", items: [
            ContextItem(name: "Roman Rule", description: "Political context of Judea."),
            ContextItem(name: "Messianic Expectation", description: "Widespread hope for a Messiah among Jews."),
            ContextItem(name: "Genealogical Importance", description: "Used to establish lineage and authority.")
        ])
    ]
) 