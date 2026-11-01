// Sources/Behaviour/BehaviourType.swift
import Foundation

public enum BehaviourType: String, CaseIterable, Sendable {
    case sitting = "Sitting"
    case wandering = "Wandering"
    case stalkingCursor = "Stalking Cursor"
    case sleeping = "Sleeping"
    case zoomies = "Zoomies"
    case dragged = "Picked Up"
    
    public var associatedAnimation: AnimationState {
        switch self {
        case .sitting: return .idle
        case .wandering: return .walk
        case .stalkingCursor: return .walk
        case .sleeping: return .sleep
        case .zoomies: return .zoomies
        case .dragged: return .dragged
        }
    }
}
