// Sources/Core/Personality.swift
import Foundation

public struct Personality: Sendable, Codable {
    public let name: String
    
    // Core traits (0.0 to 1.0)
    public var playful: Double
    public var lazy: Double
    public var curious: Double
    public var mischievous: Double
    public var shy: Double
    public var affectionate: Double
    public var energetic: Double
    public var independent: Double
    
    public init(
        name: String = "Kiko",
        playful: Double = 0.7,
        lazy: Double = 0.3,
        curious: Double = 0.8,
        mischievous: Double = 0.5,
        shy: Double = 0.2,
        affectionate: Double = 0.8,
        energetic: Double = 0.7,
        independent: Double = 0.4
    ) {
        self.name = name
        self.playful = min(max(playful, 0.0), 1.0)
        self.lazy = min(max(lazy, 0.0), 1.0)
        self.curious = min(max(curious, 0.0), 1.0)
        self.mischievous = min(max(mischievous, 0.0), 1.0)
        self.shy = min(max(shy, 0.0), 1.0)
        self.affectionate = min(max(affectionate, 0.0), 1.0)
        self.energetic = min(max(energetic, 0.0), 1.0)
        self.independent = min(max(independent, 0.0), 1.0)
    }
    
    // Legacy compatibility accessors
    public var hyperactivity: Double {
        get { energetic }
        set { energetic = newValue }
    }
    public var curiosity: Double {
        get { curious }
        set { curious = newValue }
    }
    public var cuddliness: Double {
        get { affectionate }
        set { affectionate = newValue }
    }
    
    // Presets for the 4 cat avatars
    public static let kiko = Personality(
        name: "Kiko",
        playful: 0.80,
        lazy: 0.30,
        curious: 0.85,
        mischievous: 0.60,
        shy: 0.15,
        affectionate: 0.85,
        energetic: 0.80,
        independent: 0.35
    )
    
    public static let smokey = Personality(
        name: "Smokey",
        playful: 0.30,
        lazy: 0.90,
        curious: 0.40,
        mischievous: 0.20,
        shy: 0.30,
        affectionate: 0.75,
        energetic: 0.25,
        independent: 0.60
    )
    
    public static let kuro = Personality(
        name: "Kuro",
        playful: 0.85,
        lazy: 0.25,
        curious: 0.90,
        mischievous: 0.95,
        shy: 0.20,
        affectionate: 0.45,
        energetic: 0.90,
        independent: 0.85
    )
    
    public static let mochi = Personality(
        name: "Mochi",
        playful: 0.65,
        lazy: 0.50,
        curious: 0.60,
        mischievous: 0.30,
        shy: 0.70,
        affectionate: 0.95,
        energetic: 0.50,
        independent: 0.20
    )
    
    public static let standard = kiko
}
