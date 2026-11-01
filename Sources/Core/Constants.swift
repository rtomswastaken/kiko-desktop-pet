// Sources/Core/Constants.swift
import Foundation

public enum Constants {
    public static let defaultWindowSize: CGFloat = 128.0
    public static let baseSpriteSize: CGFloat = 64.0
    public static let defaultScale: CGFloat = 2.0
    
    public static let walkSpeed: CGFloat = 65.0
    public static let zoomieSpeed: CGFloat = 280.0
    public static let gravity: CGFloat = 980.0
    
    public static let tickInterval: TimeInterval = 0.05 // 20 Hz tick
    public static let minWalkDuration: TimeInterval = 2.0
    public static let maxWalkDuration: TimeInterval = 6.0
    
    public static let defaultEnergyDecayPerSec: Double = 0.0003
    public static let boredomIncreasePerSec: Double = 0.0008
}
