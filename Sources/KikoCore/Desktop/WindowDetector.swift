// Sources/Desktop/WindowDetector.swift
import AppKit

public struct DetectedWindow: Sendable {
    public let windowID: UInt32
    public let appName: String
    public let bounds: NSRect
    public let topEdgeY: CGFloat
    
    public init(windowID: UInt32, appName: String, bounds: NSRect) {
        self.windowID = windowID
        self.appName = appName
        self.bounds = bounds
        self.topEdgeY = bounds.maxY
    }
}

@MainActor
public final class WindowDetector {
    public static let shared = WindowDetector()
    
    private init() {}
    
    /// Queries visible on-screen application windows using macOS Quartz Window Server APIs
    public func getVisibleAppWindows() -> [DetectedWindow] {
        guard let windowInfoList = CGWindowListCopyWindowInfo(
            [.optionOnScreenOnly, .excludeDesktopElements],
            kCGNullWindowID
        ) as? [[String: Any]] else {
            return []
        }
        
        let primaryScreenHeight = NSScreen.screens.first?.frame.height ?? 1080.0
        var detected: [DetectedWindow] = []
        
        for info in windowInfoList {
            // Only inspect standard normal layer windows (layer == 0)
            guard let layer = info[kCGWindowLayer as String] as? Int, layer == 0 else { continue }
            guard let boundsDict = info[kCGWindowBounds as String] as? [String: CGFloat] else { continue }
            
            let x = boundsDict["X"] ?? 0
            let y = boundsDict["Y"] ?? 0
            let w = boundsDict["Width"] ?? 0
            let h = boundsDict["Height"] ?? 0
            
            // Filter out tiny windows or huge wallpaper overlays
            guard w > 200 && h > 150 else { continue }
            
            let ownerName = (info[kCGWindowOwnerName as String] as? String) ?? "Unknown"
            // Ignore Dock, Window Server, Kiko
            if ownerName == "Dock" || ownerName == "Window Server" || ownerName == "Kiko" {
                continue
            }
            
            // Convert Quartz top-left coordinates to Cocoa bottom-left coordinates
            let cocoaY = primaryScreenHeight - (y + h)
            let cocoaRect = NSRect(x: x, y: cocoaY, width: w, height: h)
            
            let windowID = (info[kCGWindowNumber as String] as? UInt32) ?? 0
            detected.append(DetectedWindow(windowID: windowID, appName: ownerName, bounds: cocoaRect))
        }
        
        return detected
    }
    
    /// Finds a window top edge / title bar near the given point
    public func findNearestTitleBar(to point: CGPoint, maxDistance: CGFloat = 60.0) -> DetectedWindow? {
        let windows = getVisibleAppWindows()
        var nearest: DetectedWindow?
        var minDistance = maxDistance
        
        for win in windows {
            // Check if point x is within window horizontal span
            if point.x >= win.bounds.minX - 20 && point.x <= win.bounds.maxX + 20 {
                let dist = abs(point.y - win.topEdgeY)
                if dist < minDistance {
                    minDistance = dist
                    nearest = win
                }
            }
        }
        
        return nearest
    }
}
