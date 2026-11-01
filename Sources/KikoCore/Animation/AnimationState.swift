// Sources/KikoCore/Animation/AnimationState.swift
import Foundation

public enum AnimationState: String, CaseIterable, Sendable {
    case sitting = "sitting"
    case idle = "idle"
    case idle2 = "idle2"
    case run = "run"
    case jump = "jump"
    case attack = "attack"
    case hurt = "hurt"
    case sleep = "sleep"
    case die = "die"
    case box_peeking = "box_peeking"
    case box_head_out = "box_head_out"
    case dragged = "dragged"
    
    // Legacy aliases
    public static var walk: AnimationState { .run }
    public static var stretch: AnimationState { .idle2 }
    public static var climb: AnimationState { .jump }
    public static var surprised: AnimationState { .hurt }
    
    public var frameCount: Int {
        switch self {
        case .sitting: return 3
        case .idle: return 7
        case .idle2: return 14
        case .run: return 7
        case .jump: return 13
        case .attack: return 9
        case .hurt: return 7
        case .sleep: return 3
        case .die: return 14
        case .box_peeking: return 1
        case .box_head_out: return 1
        case .dragged: return 7
        }
    }
    
    public var frameDuration: TimeInterval {
        switch self {
        case .sitting: return 0.22
        case .idle: return 0.14
        case .idle2: return 0.11
        case .run: return 0.085
        case .jump: return 0.075
        case .attack: return 0.08
        case .hurt: return 0.10
        case .sleep: return 0.35
        case .die: return 0.09
        case .box_peeking: return 1.0
        case .box_head_out: return 1.0
        case .dragged: return 0.12
        }
    }
    
    public var isPingPong: Bool {
        self == .sleep || self == .sitting
    }
}
