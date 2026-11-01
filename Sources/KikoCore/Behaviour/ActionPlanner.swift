// Sources/KikoCore/Behaviour/ActionPlanner.swift
import Foundation

public struct ActionPlanner: Sendable {
    public static func nextBehaviour(
        current: BehaviourType,
        energy: Double,
        boredom: Double,
        inactivityDuration: TimeInterval = 0.0,
        mood: Mood = .happy,
        personality: Personality = .ginger,
        nearBox: Bool = false
    ) -> BehaviourType {
        // 1. Critical low energy -> must sleep
        if energy < 0.18 {
            return nearBox ? .hiding : .sleeping
        }
        
        // 2. Long user inactivity -> retreat to cardboard box and sleep
        if inactivityDuration > Constants.inactivitySleepDuration {
            if nearBox {
                return .boxIdle
            } else if current != .walking && current != .running {
                return .walking // Head towards box
            }
        }
        
        // 3. Mood-driven immediate transitions
        if mood == .scared {
            return .hiding
        }
        if mood == .excited && personality.energetic > 0.4 {
            return .excited // Zoomies!
        }
        if mood == .grumpy {
            return .grumpy
        }
        
        // 4. State-specific natural transitions
        switch current {
        case .sleeping:
            // Wake up when energy is restored
            if energy > 0.65 {
                return .stretching
            }
            return .sleeping
            
        case .dramaticFlop:
            return energy < 0.5 ? .sleeping : .idle
            
        case .stretching:
            // After stretch, transition to curious or walking
            let roll = Double.random(in: 0...1)
            return roll < 0.6 ? .idle : .walking
            
        case .hiding:
            if mood == .playful || boredom > 0.5 {
                return .boxIdle
            }
            return .hiding
            
        case .boxIdle:
            if energy > 0.5 && Double.random(in: 0...1) < (personality.curious * 0.7) {
                return .stretching
            }
            return .boxIdle
            
        case .surprised:
            return mood == .scared ? .hiding : .curious
            
        case .grumpy:
            if Double.random(in: 0...1) < 0.4 {
                return .sitting
            }
            return .grumpy
            
        case .excited:
            if energy < 0.45 {
                return .idle
            }
            return .excited
            
        case .jumping:
            return .windowWatching
            
        case .playing:
            if boredom < 0.2 || energy < 0.3 {
                return .sitting
            }
            return .playing
            
        case .windowWatching:
            if Double.random(in: 0...1) < 0.35 {
                return .walking
            }
            return .windowWatching
            
        case .sitting, .idle:
            let roll = Double.random(in: 0...100)
            let zoomieChance = personality.energetic * (boredom > 0.7 ? 25.0 : 8.0)
            let sleepChance = personality.lazy * (energy < 0.45 ? 40.0 : 15.0)
            let curiousChance = personality.curious * 30.0
            let flopChance = 10.0
            let walkChance = 30.0
            
            if roll < zoomieChance {
                return .excited
            } else if roll < zoomieChance + sleepChance {
                return .sleeping
            } else if roll < zoomieChance + sleepChance + flopChance {
                return .dramaticFlop
            } else if roll < zoomieChance + sleepChance + flopChance + curiousChance {
                return .curious
            } else if roll < zoomieChance + sleepChance + flopChance + curiousChance + walkChance {
                return .walking
            } else {
                return .watchingCursor
            }
            
        case .walking, .running:
            let roll = Double.random(in: 0...1)
            if roll < 0.40 {
                return .idle
            } else if roll < 0.70 {
                return .curious
            } else {
                return .watchingCursor
            }
            
        case .playful, .curious, .watchingCursor:
            let roll = Double.random(in: 0...1)
            if roll < 0.5 {
                return .sitting
            } else {
                return .walking
            }
            
        case .interacting, .dragged:
            return .sitting
        }
    }
}
