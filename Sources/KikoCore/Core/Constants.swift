// Sources/KikoCore/Core/Constants.swift
import Foundation

public enum Constants {
    public static let baseSpriteSize: CGFloat = 32.0
    public static let defaultScale: CGFloat = 2.0
    public static let defaultWindowSize: CGFloat = 64.0
    
    // Movement speeds (pixels per second)
    public static let walkSpeed: CGFloat = 60.0
    public static let runSpeed: CGFloat = 120.0
    public static let zoomieSpeed: CGFloat = 260.0
    public static let stalkSpeed: CGFloat = 40.0
    public static let gravity: CGFloat = 980.0
    
    // Animation & update loop
    public static let tickInterval: TimeInterval = 0.033 // ~30 Hz tick for smooth physics & low CPU
    public static let minWalkDuration: TimeInterval = 2.0
    public static let maxWalkDuration: TimeInterval = 6.0
    public static let inactivitySleepDuration: TimeInterval = 180.0
    
    // Interaction radiuses
    public static let cursorDetectRadius: CGFloat = 180.0
    public static let cursorPounceRadius: CGFloat = 32.0
    public static let boxEntryRadius: CGFloat = 45.0
    public static let windowLedgeSnapDistance: CGFloat = 30.0
    
    // Meter rates
    public static let defaultEnergyDecayPerSec: Double = 0.0004
    public static let boredomIncreasePerSec: Double = 0.0010
}
