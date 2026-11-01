// Sources/Behaviour/ActionPlanner.swift
import Foundation

public struct ActionPlanner: Sendable {
    public static func nextBehaviour(
        current: BehaviourType,
        energy: Double,
        boredom: Double,
        personality: Personality
    ) -> BehaviourType {
        // If energy is critically low, must sleep
        if energy < 0.20 {
            return .sleeping
        }
        
        // High boredom + high energy -> sudden zoomies chance
        if boredom > 0.75 && energy > 0.60 {
            let roll = Double.random(in: 0...1)
            if roll < personality.hyperactivity * 0.40 {
                return .zoomies
            }
        }
        
        // Under normal conditions, alternate between sitting and wandering
        switch current {
        case .sleeping:
            if energy > 0.85 {
                return .sitting
            }
            return .sleeping
            
        case .sitting:
            let wanderChance = 0.50 + (personality.hyperactivity * 0.3)
            return Double.random(in: 0...1) < wanderChance ? .wandering : .sitting
            
        case .wandering:
            return .sitting
            
        case .zoomies:
            return energy < 0.35 ? .sleeping : .sitting
            
        case .stalkingCursor, .dragged:
            return .sitting
        }
    }
}
