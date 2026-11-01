// Sources/Core/Mood.swift
import Foundation

public enum Mood: String, CaseIterable, Sendable {
    case happy = "Happy"
    case curious = "Curious"
    case sleepy = "Sleepy"
    case playful = "Playful"
    case chaotic = "Chaotic" // Zoomies mode
    
    public var emoji: String {
        switch self {
        case .happy: return "😸"
        case .curious: return "😺"
        case .sleepy: return "😴"
        case .playful: return "😼"
        case .chaotic: return "🙀"
        }
    }
    
    public var description: String {
        switch self {
        case .happy: return "Content and purring softly"
        case .curious: return "Investigating desktop surroundings"
        case .sleepy: return "Dozing off into a warm nap"
        case .playful: return "Looking for something to pounce on"
        case .chaotic: return "Unstoppable midnight zoomies!"
        }
    }
}
