// Sources/Audio/SoundEffect.swift
import Foundation

public enum SoundEffect: String, CaseIterable, Sendable {
    case meow = "meow.wav"
    case purr = "purr.wav"
    case chirp = "chirp.wav"
    case pounce = "pounce.wav"
    case snore = "snore.wav"
    case footstep = "footstep.wav"
    
    public var defaultVolume: Float {
        switch self {
        case .meow: return 0.75
        case .purr: return 0.50
        case .chirp: return 0.65
        case .pounce: return 0.70
        case .snore: return 0.40
        case .footstep: return 0.25
        }
    }
}
