// Sources/Core/Personality.swift
import Foundation

public struct Personality: Sendable {
    public let name: String
    public var hyperactivity: Double // 0.0 (lazy) to 1.0 (energetic)
    public var curiosity: Double     // 0.0 (aloof) to 1.0 (inquisitive)
    public var cuddliness: Double    // 0.0 (independent) to 1.0 (lap cat)
    
    public init(
        name: String = "Kiko",
        hyperactivity: Double = 0.6,
        curiosity: Double = 0.75,
        cuddliness: Double = 0.8
    ) {
        self.name = name
        self.hyperactivity = min(max(hyperactivity, 0.0), 1.0)
        self.curiosity = min(max(curiosity, 0.0), 1.0)
        self.cuddliness = min(max(cuddliness, 0.0), 1.0)
    }
    
    public static let standard = Personality(name: "Kiko", hyperactivity: 0.6, curiosity: 0.75, cuddliness: 0.8)
    public static let lazy = Personality(name: "Sleepy Kiko", hyperactivity: 0.2, curiosity: 0.3, cuddliness: 0.9)
    public static let feral = Personality(name: "Chaos Kiko", hyperactivity: 0.95, curiosity: 0.9, cuddliness: 0.4)
}
