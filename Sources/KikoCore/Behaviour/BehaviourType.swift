// Sources/Behaviour/BehaviourType.swift
import Foundation

public enum BehaviourType: String, CaseIterable, Sendable {
    case idle = "Idle"
    case walking = "Walking"
    case running = "Running"
    case playful = "Playful"
    case curious = "Curious"
    case sleeping = "Sleeping"
    case hiding = "Hiding in Box"
    case boxIdle = "Resting in Box"
    case stretching = "Stretching"
    case playing = "Playing with Toy"
    case watchingCursor = "Watching Cursor"
    case surprised = "Surprised"
    case excited = "Excited (Zoomies)"
    case grumpy = "Grumpy"
    case interacting = "Being Petted"
    case windowWatching = "Perched on Window"
    case dragged = "Picked Up"
    
    // Legacy mapping support
    public static var sitting: BehaviourType { .idle }
    public static var wandering: BehaviourType { .walking }
    public static var stalkingCursor: BehaviourType { .playful }
    public static var zoomies: BehaviourType { .excited }
    
    public var associatedAnimation: AnimationState {
        switch self {
        case .idle, .watchingCursor, .grumpy, .interacting, .windowWatching, .curious:
            return .idle
        case .walking:
            return .walk
        case .running, .excited, .playful, .playing:
            return .run
        case .sleeping:
            return .sleep
        case .hiding:
            return .box_peeking
        case .boxIdle:
            return .box_head_out
        case .stretching:
            return .stretch
        case .surprised:
            return .surprised
        case .dragged:
            return .dragged
        }
    }
    
    public var allowsCursorFollow: Bool {
        switch self {
        case .playful, .curious, .playing, .watchingCursor, .walking:
            return true
        default:
            return false
        }
    }
    
    public var isStationary: Bool {
        switch self {
        case .idle, .sleeping, .hiding, .boxIdle, .stretching, .watchingCursor, .grumpy, .interacting, .windowWatching, .surprised:
            return true
        default:
            return false
        }
    }
}
