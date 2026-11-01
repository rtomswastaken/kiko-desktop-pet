// Sources/Animation/SpriteManager.swift
import AppKit

@MainActor
public final class SpriteManager {
    public static let shared = SpriteManager()
    
    private var imageCache: [String: NSImage] = [:]
    
    private init() {}
    
    public func frameImage(for state: AnimationState, frameIndex: Int) -> NSImage? {
        let key = "\(state.rawValue)_\(frameIndex)"
        if let cached = imageCache[key] {
            return cached
        }
        
        let filename: String
        switch state {
        case .idle:
            filename = "kiko_sit_\(frameIndex).png"
        case .walk, .zoomies:
            filename = "kiko_walk_\(frameIndex).png"
        case .sleep:
            filename = "kiko_sleep_\(frameIndex).png"
        case .dragged:
            filename = "kiko_sit_0.png"
        }
        
        let searchPaths = [
            "assets/sprites/processed/\(filename)",
            "../assets/sprites/processed/\(filename)",
            Bundle.main.path(forResource: filename, ofType: nil) ?? ""
        ]
        
        for path in searchPaths where !path.isEmpty && FileManager.default.fileExists(atPath: path) {
            if let img = NSImage(contentsOfFile: path) {
                imageCache[key] = img
                return img
            }
        }
        
        return nil
    }
}
