// Sources/Core/Mood.swift
import Foundation

public enum Mood: String, CaseIterable, Sendable {
    case happy = "Happy"
    case sleepy = "Sleepy"
    case curious = "Curious"
    case playful = "Playful"
    case grumpy = "Grumpy"
    case excited = "Excited"
    case bored = "Bored"
    case scared = "Scared"
    case relaxed = "Relaxed"
    
    public var emoji: String {
        switch self {
        case .happy: return "😸"
        case .sleepy: return "😴"
        case .curious: return "😺"
        case .playful: return "😼"
        case .grumpy: return "😾"
        case .excited: return "😻"
        case .bored: return "🥱"
        case .scared: return "🙀"
        case .relaxed: return "😽"
        }
    }
    
    public var description: String {
        switch self {
        case .happy: return "Content and purring softly"
        case .sleepy: return "Dozing off into a warm nap"
        case .curious: return "Investigating desktop surroundings and windows"
        case .playful: return "Ready to chase cursors and toys"
        case .grumpy: return "Aloof and doing its own thing"
        case .excited: return "Bursting with bouncy energy!"
        case .bored: return "Seeking something novel to explore"
        case .scared: return "Startled! Retreating to safety"
        case .relaxed: return "Peacefully watching the desktop world"
        }
    }
    
    public var movementSpeedMultiplier: Double {
        switch self {
        case .happy: return 1.1
        case .sleepy: return 0.65
        case .curious: return 0.95
        case .playful: return 1.35
        case .grumpy: return 0.5
        case .excited: return 2.2
        case .bored: return 0.75
        case .scared: return 2.5
        case .relaxed: return 0.8
        }
    }
}
