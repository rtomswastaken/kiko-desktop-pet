// Sources/Audio/SoundEffect.swift
import Foundation

public enum SoundEffect: String, CaseIterable, Sendable {
    case purr = "purr"
    case meow = "meow"
    case pounce = "pounce"
    case footstep = "footstep"
    
    public var defaultVolume: Float {
        switch self {
        case .purr: return 0.4
        case .meow: return 0.6
        case .pounce: return 0.5
        case .footstep: return 0.2
        }
    }
}
