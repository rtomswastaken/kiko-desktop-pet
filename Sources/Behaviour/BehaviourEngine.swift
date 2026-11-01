// Sources/Behaviour/BehaviourEngine.swift
import Foundation

@MainActor
public final class BehaviourEngine: ObservableObject {
    public static let shared = BehaviourEngine()
    
    @Published public private(set) var currentBehaviour: BehaviourType = .sitting
    public private(set) var stateTimer: TimeInterval = 0.0
    public var targetPosition: CGPoint?
    
    private init() {}
    
    public func update(deltaTime: TimeInterval) {
        stateTimer += deltaTime
        let petState = PetState.shared
        petState.tickMeters(dt: deltaTime)
        
        switch currentBehaviour {
        case .sitting:
            if stateTimer > 4.0 {
                transitionTo(ActionPlanner.nextBehaviour(
                    current: .sitting,
                    energy: petState.energy,
                    boredom: petState.boredom,
                    personality: petState.personality
                ))
            }
        case .wandering:
            if stateTimer > 5.0 {
                transitionTo(.sitting)
            }
        case .sleeping:
            if petState.energy > 0.90 || stateTimer > 15.0 {
                transitionTo(.sitting)
            }
        case .zoomies:
            if stateTimer > 6.0 || petState.energy < 0.25 {
                transitionTo(.sitting)
            }
        case .stalkingCursor, .dragged:
            break
        }
    }
    
    public func transitionTo(_ newBehaviour: BehaviourType) {
        guard newBehaviour != currentBehaviour else { return }
        currentBehaviour = newBehaviour
        stateTimer = 0.0
    }
    
    public func triggerZoomies() {
        transitionTo(.zoomies)
    }
    
    public func forceSleep() {
        transitionTo(.sleeping)
    }
}
