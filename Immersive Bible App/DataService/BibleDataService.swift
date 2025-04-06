import Foundation
import Supabase

// Define a struct to represent a verse, matching your table structure
struct BibleVerse: Decodable, Identifiable {
    let id: Int // Assuming 'id' is your primary key
    let bookName: String // Matches 'book' column
    let chapterNumber: Int // Matches 'chapter' column
    let verseNumber: Int // Matches 'verse' column
    let verseText: String // Matches 'text' column

    // Map database column names to struct property names if they differ
    enum CodingKeys: String, CodingKey {
        case id
        case bookName = "book"
        case chapterNumber = "chapter"
        case verseNumber = "verse"
        case verseText = "text"
    }
}

class BibleDataService {
    
    static let shared = BibleDataService() // Singleton pattern
    
    private let supabase: SupabaseClient
    
    // Helper function to load configuration from plist
    private static func loadConfigValue(forKey key: String) -> String? {
        guard let filePath = Bundle.main.path(forResource: "SupabaseKeys", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath) else {
            print("Error: Could not find or load SupabaseKeys.plist")
            return nil
        }
        return plist.object(forKey: key) as? String
    }
    
    private init() {
        // Load URL and Key from SupabaseKeys.plist
        guard let urlString = BibleDataService.loadConfigValue(forKey: "SUPABASE_URL"),
              let supabaseURL = URL(string: urlString), // Validate the URL string
              let supabaseKey = BibleDataService.loadConfigValue(forKey: "SUPABASE_KEY") else {
            // Fatal error is appropriate here because the app cannot function without Supabase configured.
            // In a production app, you might want more robust error handling.
            fatalError("Supabase configuration is missing or invalid in SupabaseKeys.plist")
        }
        
        self.supabase = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
        print("Supabase client initialized from plist.")
    }
    
    // Function to fetch verses for a specific book and chapter
    func fetchVerses(book: String, chapter: Int) async throws -> [BibleVerse] {
        print("Fetching verses for \(book) Chapter \(chapter)...")
        do {
            let query = supabase
                .from("bible_verses") // Your table name
                .select() // Select all columns (or specify: "id, book, chapter, verse, text")
                .eq("book", value: book) // Filter by book name
                .eq("chapter", value: chapter) // Filter by chapter number
                .order("verse", ascending: true) // Order by verse number
            
            let verses: [BibleVerse] = try await query.execute().value
            print("Successfully fetched \(verses.count) verses.")
            return verses
        } catch {
            print("Error fetching verses: \(error.localizedDescription)")
            // Log the detailed error
            if let postgrestError = error as? PostgrestError {
                 print("PostgrestError details: Code - \(postgrestError.code ?? "N/A"), Message - \(postgrestError.message), Hint - \(postgrestError.hint ?? "N/A")")
             }
            throw error // Re-throw the error to be handled by the caller
        }
    }
} 