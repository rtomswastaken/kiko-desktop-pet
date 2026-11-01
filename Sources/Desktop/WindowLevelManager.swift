// Sources/Desktop/WindowLevelManager.swift
import AppKit

@MainActor
public final class WindowLevelManager {
    public static let shared = WindowLevelManager()
    
    public private(set) var isAlwaysOnTop: Bool = true
    
    private init() {}
    
    public func toggleAlwaysOnTop(for window: NSWindow) {
        isAlwaysOnTop.toggle()
        applyLevel(to: window)
    }
    
    public func applyLevel(to window: NSWindow) {
        window.level = isAlwaysOnTop ? .floating : .normal
    }
}
