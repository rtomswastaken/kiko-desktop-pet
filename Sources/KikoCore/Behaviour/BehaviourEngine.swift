// Sources/KikoCore/Behaviour/BehaviourEngine.swift
import AppKit

@MainActor
public final class BehaviourEngine {
    public static let shared = BehaviourEngine()
    
    public private(set) var currentBehaviour: BehaviourType = .idle
    private var stateTimeRemaining: TimeInterval = 3.0
    private var walkTarget: CGPoint = .zero
    
    // Mini-game active target
    public var customTargetPoint: CGPoint?
    public var isChasingLaser: Bool = false
    public var isChasingYarn: Bool = false
    
    private init() {
        self.stateTimeRemaining = Double.random(in: 2.5...5.0)
    }
    
    public func transitionTo(_ newBehaviour: BehaviourType) {
        guard newBehaviour != currentBehaviour else { return }
        let prev = currentBehaviour
        currentBehaviour = newBehaviour
        
        switch newBehaviour {
        case .idle, .sitting:
            stateTimeRemaining = Double.random(in: 2.0...6.0)
            PetState.shared.velocity = .zero
            
        case .walking:
            stateTimeRemaining = Double.random(in: Constants.minWalkDuration...Constants.maxWalkDuration)
            walkTarget = ScreenManager.shared.randomPointInWorkArea()
            
        case .running, .excited:
            stateTimeRemaining = Double.random(in: 3.5...7.0)
            walkTarget = ScreenManager.shared.randomPointInWorkArea()
            SoundManager.shared.play(.chirp)
            
        case .jumping:
            stateTimeRemaining = 0.9
            PetState.shared.velocity = .zero
            SoundManager.shared.play(.pounce)
            
        case .dramaticFlop:
            stateTimeRemaining = 1.4
            PetState.shared.velocity = .zero
            SoundManager.shared.play(.meow)
            
        case .sleeping:
            stateTimeRemaining = Double.random(in: 8.0...20.0)
            PetState.shared.velocity = .zero
            SoundManager.shared.play(.snore)
            
        case .hiding:
            stateTimeRemaining = Double.random(in: 5.0...12.0)
            PetState.shared.velocity = .zero
            PetState.shared.isInBox = true
            
        case .boxIdle:
            stateTimeRemaining = Double.random(in: 4.0...10.0)
            PetState.shared.velocity = .zero
            PetState.shared.isInBox = true
            
        case .stretching:
            stateTimeRemaining = 1.2
            PetState.shared.velocity = .zero
            PetState.shared.isInBox = false
            
        case .curious, .watchingCursor:
            stateTimeRemaining = Double.random(in: 2.5...5.5)
            PetState.shared.velocity = .zero
            
        case .playful, .playing:
            stateTimeRemaining = Double.random(in: 3.0...8.0)
            
        case .grumpy:
            stateTimeRemaining = Double.random(in: 3.0...6.0)
            PetState.shared.velocity = .zero
            
        case .surprised:
            stateTimeRemaining = 0.5
            PetState.shared.velocity = .zero
            SoundManager.shared.play(.chirp)
            
        case .windowWatching:
            stateTimeRemaining = Double.random(in: 5.0...15.0)
            PetState.shared.velocity = .zero
            
        case .interacting, .dragged:
            PetState.shared.velocity = .zero
            PetState.shared.isInBox = false
        }
        
        if prev == .hiding || prev == .boxIdle {
            if newBehaviour != .hiding && newBehaviour != .boxIdle {
                PetState.shared.isInBox = false
            }
        }
    }
    
    public func update(deltaTime: TimeInterval) {
        let petState = PetState.shared
        petState.tickMeters(dt: deltaTime)
        
        // Dragging overrides normal state machine
        if InteractionManager.shared.isDragging {
            return
        }
        
        // Check for active mini-game target (Laser pointer or Yarn ball)
        if let target = customTargetPoint {
            handleTargetChase(target: target, deltaTime: deltaTime)
            return
        }
        
        // Normal cursor reaction logic if cursor is active and nearby
        let mouseLocation = NSEvent.mouseLocation
        let petPos = petState.position
        let size = Constants.defaultWindowSize
        let catCenter = CGPoint(x: petPos.x + size / 2.0, y: petPos.y + size / 2.0)
        let distToCursor = hypot(mouseLocation.x - catCenter.x, mouseLocation.y - catCenter.y)
        
        if Preferences.shared.cursorTrackingEnabled &&
            distToCursor < Constants.cursorDetectRadius &&
            !petState.isInBox &&
            currentBehaviour != .sleeping &&
            currentBehaviour != .grumpy {
            
            // Cat turns towards cursor:
            // Mouse is to the left of cat center -> isFacingLeft = true
            // Mouse is to the right of cat center -> isFacingLeft = false
            petState.isFacingLeft = mouseLocation.x < catCenter.x
            
            // If playful or curious, approach cursor
            if distToCursor > Constants.cursorPounceRadius && (currentBehaviour == .playful || currentBehaviour == .walking || currentBehaviour == .curious) {
                let speed = (currentBehaviour == .playful ? Constants.runSpeed : Constants.walkSpeed) * petState.currentMood.movementSpeedMultiplier
                let step = min(distToCursor, CGFloat(speed * deltaTime))
                let dx = mouseLocation.x - catCenter.x
                let dy = mouseLocation.y - catCenter.y
                let newX = petPos.x + (dx / distToCursor) * step
                let newY = petPos.y + (dy / distToCursor) * step
                petState.position = CGPoint(x: newX, y: newY)
                return
            } else if distToCursor <= Constants.cursorPounceRadius && currentBehaviour != .idle && currentBehaviour != .watchingCursor {
                // Close enough to wait or watch
                transitionTo(.watchingCursor)
            }
        }
        
        // Advance state time
        stateTimeRemaining -= deltaTime
        
        // Movement during walking or running
        if currentBehaviour == .walking || currentBehaviour == .running || currentBehaviour == .excited {
            stepTowardsWalkTarget(deltaTime: deltaTime)
        }
        
        // Transition when timer expires
        if stateTimeRemaining <= 0 {
            let next = ActionPlanner.nextBehaviour(
                current: currentBehaviour,
                energy: petState.energy,
                boredom: petState.boredom,
                inactivityDuration: petState.timeSinceLastInteraction,
                mood: petState.currentMood,
                personality: petState.personality,
                nearBox: isNearBox()
            )
            transitionTo(next)
        }
    }
    
    private func stepTowardsWalkTarget(deltaTime: TimeInterval) {
        let petState = PetState.shared
        let pos = petState.position
        let dx = walkTarget.x - pos.x
        let dy = walkTarget.y - pos.y
        let dist = hypot(dx, dy)
        
        if dist < 16.0 {
            // Reached waypoint early
            transitionTo(.sitting)
            return
        }
        
        let baseSpeed: CGFloat
        switch currentBehaviour {
        case .excited: baseSpeed = Constants.zoomieSpeed
        case .running: baseSpeed = Constants.runSpeed
        default: baseSpeed = Constants.walkSpeed
        }
        
        let speed = baseSpeed * CGFloat(petState.currentMood.movementSpeedMultiplier)
        let step = min(dist, speed * CGFloat(deltaTime))
        
        let nx = pos.x + (dx / dist) * step
        let ny = pos.y + (dy / dist) * step
        petState.position = CGPoint(x: nx, y: ny)
        // Moving left when target is to the left (dx < 0)
        petState.isFacingLeft = dx < 0
    }
    
    private func handleTargetChase(target: CGPoint, deltaTime: TimeInterval) {
        let petState = PetState.shared
        let pos = petState.position
        let dx = target.x - pos.x
        let dy = target.y - pos.y
        let dist = hypot(dx, dy)
        
        petState.isFacingLeft = dx < 0
        
        if dist < 20.0 {
            // Reached target
            if isChasingLaser {
                SoundManager.shared.play(.pounce)
            }
            return
        }
        
        let speed = Constants.zoomieSpeed * 0.85
        let step = min(dist, speed * CGFloat(deltaTime))
        let nx = pos.x + (dx / dist) * step
        let ny = pos.y + (dy / dist) * step
        petState.position = CGPoint(x: nx, y: ny)
    }
    
    private func isNearBox() -> Bool {
        guard let boxPos = BoxInteractionController.shared.boxPosition else { return false }
        let petPos = PetState.shared.position
        return hypot(boxPos.x - petPos.x, boxPos.y - petPos.y) < Constants.boxEntryRadius
    }
    
    public func triggerZoomies() {
        PetState.shared.currentMood = .excited
        transitionTo(.excited)
    }
    
    public func forceSleep() {
        PetState.shared.currentMood = .sleepy
        transitionTo(.sleeping)
    }
    
    public func wakeUp() {
        PetState.shared.restoreEnergy(amount: 0.5)
        transitionTo(.stretching)
    }
}
