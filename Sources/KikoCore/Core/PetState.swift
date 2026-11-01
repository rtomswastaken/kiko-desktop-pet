// Sources/Core/PetState.swift
import Foundation

@MainActor
public final class PetState: ObservableObject {
    public static let shared = PetState()
    
    @Published public var position: CGPoint = .zero
    @Published public var velocity: CGVector = .zero
    @Published public var isFacingLeft: Bool = true
    @Published public var currentMood: Mood = .happy
    @Published public var currentAvatar: CatAvatar = .kiko
    
    // Continuous meters (0.0 to 1.0)
    @Published public var energy: Double = 0.85
    @Published public var boredom: Double = 0.15
    @Published public var affection: Double = 0.70
    
    // Inactivity & interaction history
    @Published public var timeSinceLastInteraction: TimeInterval = 0.0
    public var lastPetTimestamp: TimeInterval = 0.0
    public var petStrokeCount: Int = 0
    public var isInBox: Bool = false
    public var isPerchedOnWindow: Bool = false
    public var perchedWindowID: UInt32?
    
    public var personality: Personality = .kiko
    
    public init() {
        self.personality = currentAvatar.defaultPersonality
    }
    
    public func selectAvatar(_ avatar: CatAvatar) {
        currentAvatar = avatar
        personality = avatar.defaultPersonality
    }
    
    public func recordInteraction() {
        timeSinceLastInteraction = 0.0
    }
    
    public func pet() {
        recordInteraction()
        affection = min(1.0, affection + 0.06 * personality.affectionate)
        boredom = max(0.0, boredom - 0.12)
        
        let now = Date().timeIntervalSince1970
        if now - lastPetTimestamp < 1.2 {
            petStrokeCount += 1
        } else {
            petStrokeCount = 1
        }
        lastPetTimestamp = now
        
        if affection > 0.75 {
            currentMood = .happy
        } else if currentMood != .excited {
            currentMood = .relaxed
        }
    }
    
    public func playWithToy() {
        recordInteraction()
        affection = min(1.0, affection + 0.10)
        boredom = max(0.0, boredom - 0.35)
        drainEnergy(amount: 0.05)
        currentMood = .playful
    }
    
    public func feedTreat() {
        recordInteraction()
        affection = min(1.0, affection + 0.20)
        boredom = max(0.0, boredom - 0.15)
        restoreEnergy(amount: 0.15)
        currentMood = .happy
    }
    
    public func startle() {
        recordInteraction()
        currentMood = .scared
        boredom = 0.0
        drainEnergy(amount: 0.08)
    }
    
    public func drainEnergy(amount: Double) {
        energy = max(0.0, energy - amount)
        if energy < 0.20 && currentMood != .scared {
            currentMood = .sleepy
        }
    }
    
    public func restoreEnergy(amount: Double) {
        energy = min(1.0, energy + amount)
        if energy > 0.50 && currentMood == .sleepy {
            currentMood = .relaxed
        }
    }
    
    public func tickMeters(dt: TimeInterval) {
        timeSinceLastInteraction += dt
        
        if currentMood == .sleepy || isInBox {
            restoreEnergy(amount: 0.06 * dt)
            boredom = max(0.0, boredom - 0.02 * dt)
        } else if currentMood == .excited {
            drainEnergy(amount: 0.08 * dt)
            boredom = 0.0
        } else {
            drainEnergy(amount: Constants.defaultEnergyDecayPerSec * dt)
            boredom = min(1.0, boredom + Constants.boredomIncreasePerSec * dt * (1.0 + personality.curious * 0.5))
        }
        
        // Dynamic mood shifts based on meters
        if energy < 0.18 && currentMood != .sleepy {
            currentMood = .sleepy
        } else if boredom > 0.85 && energy > 0.5 && currentMood != .bored && currentMood != .excited {
            currentMood = .bored
        }
    }
}
