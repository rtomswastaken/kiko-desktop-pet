// Sources/Animation/AnimationState.swift
import Foundation

public enum AnimationState: String, CaseIterable, Sendable {
    case idle = "kiko_sit"
    case walk = "kiko_walk"
    case sleep = "kiko_sleep"
    case dragged = "kiko_dragged"
    case zoomies = "kiko_zoomies"
    
    public var frameCount: Int {
        switch self {
        case .idle: return 4
        case .walk: return 2
        case .sleep: return 4
        case .dragged: return 1
        case .zoomies: return 2
        }
    }
    
    public var frameDuration: TimeInterval {
        switch self {
        case .idle: return 0.25
        case .walk: return 0.14
        case .sleep: return 0.40
        case .dragged: return 1.0
        case .zoomies: return 0.07
        }
    }
}
