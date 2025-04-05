# 🧠 PLANNING.md for Immersive Bible App

**Purpose:** This document outlines the high-level vision, architecture, constraints, technology stack, tools, and key decisions for the Immersive Bible App project. This will serve as a central reference point for development using AI coding assistants like Cursor. The AI should reference this file at the beginning of any new conversation.

## 1. Project Overview

The Immersive Bible App aims to provide users with an engaging and multi-sensory experience of the Bible on iOS devices. It will incorporate text, high-quality audio narration, ambient background sounds, and the unique ability to "Songify" Bible chapters.

## 2. Target Platform

*   **iOS** [previous conversation]

## 3. Development Environment

*   **Programming Language:** Swift
*   **IDE:** Xcode
*   **AI Coding Assistant:** Cursor [previous conversation]

## 4. Bible Translations

The app will support the following Bible translations:

*   King James Version (KJV) [previous conversation]
*   English Standard Version (ESV) [previous conversation]
*   New Living Translation (NLT) [previous conversation]
*   Amplified Bible (AMP) [previous conversation]

## 5. Data Management

*   **Preloaded Bible Data:** The Bible data for the supported translations will be preloaded into the app using **Supabase** [previous conversation, your previous query].
    *   *Further details on the structure and format of this preloaded data within the iOS app will be specified later.* [your second turn]

## 6. Audio Integration

*   **Text-to-Speech Narration:** The **Eleven Labs API** will be used for high-quality text-to-speech narration of the Bible text [previous conversation, your previous query].
    *   *The technical approach or mechanism for real-time synchronization of the audio narration with the highlighted Bible verses within the iOS app will be specified later.* [your fourth turn]
*   **Ambient Sounds:** **Ten (10) different ambient background sound options** will be pre-loaded into the app's database [your previous query]. Users will be able to select and play these sounds to enhance immersion.
*   **Bible Chapter Songs ("Songify"):** The **Suno AI API** will be integrated to allow users to turn a selected Bible chapter into a song [your previous query].
    *   When a user clicks a "Songify" option, a prompt will be sent to the Suno AI API on the backend. This prompt will be designed to keep the generated song biblically focused and appropriate [your previous query].
    *   Users will be able to listen to and share the generated songs [your previous query].

## 7. User Interface (UI) and User Experience (UX)

*   The app will feature **thin top and bottom navigation bars** [previous conversation].
    *   *The specific user flow for navigating between Bible books, chapters, and versions using the top bar will be detailed later.* [your second turn]
    *   *The specific user flow for accessing and interacting with voice, sound, ambience, and cross-reference controls in the bottom bar will be detailed later.* [your second turn]
*   *Initial UI/UX visions have been discussed previously and will be further refined.* [previous conversation]

## 8. Technology Stack Rationale

*   **Swift and Xcode:** Chosen for native iOS development, providing optimal performance and user experience on Apple devices [previous conversation].
*   **Supabase:** Selected for its ease of use in preloading and managing the Bible data, offering a robust backend-as-a-service solution [previous conversation, your previous query].
*   **Eleven Labs API:** Chosen for its high-quality and natural-sounding text-to-speech capabilities, enhancing the audio narration experience [previous conversation, your previous query].
*   **Suno AI API:** Integrated to provide a unique and engaging feature allowing users to experience Bible chapters in song format, leveraging AI-powered music generation [your previous query].

## 9. Suno AI Integration Details

*   **Backend Prompt for Song Generation:** The backend logic will construct a prompt for the Suno AI API that emphasizes biblical focus and appropriate musical style to generate meaningful songs from Bible chapters [your previous query].

## 10. Constraints

*   Keep code files under 500 lines [1].
*   Aim for a clean and intuitive user interface.
*   Ensure efficient data access for smooth navigation.

## 11. Future Considerations

*   Cross-references and study notes integration (mentioned previously).
*   User account management for saved preferences and content.
*   Offline access to downloaded translations and audio.

This **`PLANNING.md`** will be continuously updated as the project evolves.
