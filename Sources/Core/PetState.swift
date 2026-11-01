// Sources/Core/PetState.swift
import Foundation

@MainActor
public final class PetState: ObservableObject {
    public static let shared = PetState()
    
    @Published public var position: CGPoint = .zero
    @Published public var velocity: CGVector = .zero
    @Published public var isFacingLeft: Bool = true
    @Published public var currentMood: Mood = .happy
    
    // Continuous meters (0.0 to 1.0)
    @Published public var energy: Double = 0.85
    @Published public var boredom: Double = 0.15
    @Published public var affection: Double = 0.70
    
    public var personality: Personality = .standard
    
    public init() {}
    
    public func pet() {
        affection = min(1.0, affection + 0.08)
        boredom = max(0.0, boredom - 0.10)
        currentMood = affection > 0.6 ? .happy : .playful
    }
    
    public func drainEnergy(amount: Double) {
        energy = max(0.0, energy - amount)
        if energy < 0.20 {
            currentMood = .sleepy
        }
    }
    
    public func restoreEnergy(amount: Double) {
        energy = min(1.0, energy + amount)
        if energy > 0.50 && currentMood == .sleepy {
            currentMood = .happy
        }
    }
    
    public func tickMeters(dt: TimeInterval) {
        if currentMood == .sleepy {
            restoreEnergy(amount: 0.05 * dt)
        } else if currentMood == .chaotic {
            drainEnergy(amount: 0.12 * dt)
        } else {
            drainEnergy(amount: Constants.defaultEnergyDecayPerSec * dt)
            boredom = min(1.0, boredom + Constants.boredomIncreasePerSec * dt)
        }
    }
}
