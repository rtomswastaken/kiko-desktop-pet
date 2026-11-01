// Sources/Desktop/ScreenManager.swift
import AppKit

@MainActor
public final class ScreenManager {
    public static let shared = ScreenManager()
    
    private init() {}
    
    public var primaryWorkArea: NSRect {
        NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
    }
    
    public func randomPointInWorkArea(inset: CGFloat = 80.0) -> CGPoint {
        let frame = primaryWorkArea
        let minX = frame.minX + inset
        let maxX = max(minX, frame.maxX - inset)
        let minY = frame.minY + inset
        let maxY = max(minY, frame.maxY - inset)
        
        return CGPoint(
            x: CGFloat.random(in: minX...maxX),
            y: CGFloat.random(in: minY...maxY)
        )
    }
}
