// Sources/KikoCore/Behaviour/BehaviourType.swift
import Foundation

public enum BehaviourType: String, CaseIterable, Sendable {
    case idle = "Idle"
    case sitting = "Sitting"
    case walking = "Walking"
    case running = "Running"
    case jumping = "Jumping"
    case playful = "Playful (Pounce)"
    case curious = "Curious"
    case sleeping = "Sleeping"
    case dramaticFlop = "Dramatic Flop"
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
    public static var wandering: BehaviourType { .walking }
    public static var stalkingCursor: BehaviourType { .playful }
    public static var zoomies: BehaviourType { .excited }
    
    public var associatedAnimation: AnimationState {
        switch self {
        case .idle:
            return .idle
        case .sitting, .grumpy, .interacting:
            return .sitting
        case .walking, .running, .excited:
            return .run
        case .jumping:
            return .jump
        case .playful, .playing:
            return .attack
        case .curious, .watchingCursor, .stretching:
            return .idle2
        case .windowWatching:
            return .sitting
        case .sleeping:
            return .sleep
        case .dramaticFlop:
            return .die
        case .hiding:
            return .box_peeking
        case .boxIdle:
            return .box_head_out
        case .surprised, .dragged:
            return .hurt
        }
    }
    
    public var allowsCursorFollow: Bool {
        switch self {
        case .playful, .curious, .playing, .watchingCursor, .walking, .running:
            return true
        default:
            return false
        }
    }
    
    public var isStationary: Bool {
        switch self {
        case .idle, .sitting, .sleeping, .dramaticFlop, .hiding, .boxIdle, .stretching, .watchingCursor, .grumpy, .interacting, .windowWatching, .surprised:
            return true
        default:
            return false
        }
    }
}
