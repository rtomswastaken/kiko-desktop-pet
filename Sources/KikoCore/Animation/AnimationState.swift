// Sources/Animation/AnimationState.swift
import Foundation

public enum AnimationState: String, CaseIterable, Sendable {
    case idle = "sit"
    case walk = "walk"
    case run = "run"
    case sleep = "sleep"
    case stretch = "stretch"
    case climb = "climb"
    case box_peeking = "box_peeking"
    case box_head_out = "box_head_out"
    case dragged = "dragged"
    case surprised = "surprised"
    
    public var frameCount: Int {
        switch self {
        case .idle: return 4
        case .walk: return 2
        case .run: return 2
        case .sleep: return 4
        case .stretch: return 3
        case .climb: return 1
        case .box_peeking: return 1
        case .box_head_out: return 1
        case .dragged: return 1
        case .surprised: return 1
        }
    }
    
    public var frameDuration: TimeInterval {
        switch self {
        case .idle: return 0.28
        case .walk: return 0.15
        case .run: return 0.08
        case .sleep: return 0.42
        case .stretch: return 0.35
        case .climb: return 1.0
        case .box_peeking: return 1.0
        case .box_head_out: return 1.0
        case .dragged: return 1.0
        case .surprised: return 0.20
        }
    }
    
    public var isPingPong: Bool {
        self == .sleep || self == .stretch
    }
}
