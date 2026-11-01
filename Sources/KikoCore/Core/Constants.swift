// Sources/Core/Constants.swift
import Foundation

public enum Constants {
    public static let baseSpriteSize: CGFloat = 64.0
    public static let defaultScale: CGFloat = 2.0
    public static let defaultWindowSize: CGFloat = 128.0
    
    // Movement speeds (pixels per second)
    public static let walkSpeed: CGFloat = 70.0
    public static let runSpeed: CGFloat = 140.0
    public static let zoomieSpeed: CGFloat = 320.0
    public static let stalkSpeed: CGFloat = 45.0
    public static let gravity: CGFloat = 980.0
    
    // Animation & update loop
    public static let tickInterval: TimeInterval = 0.033 // ~30 Hz tick for smooth physics & low CPU
    public static let minWalkDuration: TimeInterval = 2.0
    public static let maxWalkDuration: TimeInterval = 6.0
    public static let inactivitySleepDuration: TimeInterval = 120.0 // 2 minutes of idle -> box sleep
    
    // Interaction radiuses
    public static let cursorDetectRadius: CGFloat = 220.0
    public static let cursorPounceRadius: CGFloat = 48.0
    public static let boxEntryRadius: CGFloat = 60.0
    public static let windowLedgeSnapDistance: CGFloat = 35.0
    
    // Meter rates
    public static let defaultEnergyDecayPerSec: Double = 0.0004
    public static let boredomIncreasePerSec: Double = 0.0010
}
