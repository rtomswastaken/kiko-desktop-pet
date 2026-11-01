// Sources/Animation/SpriteManager.swift
import AppKit

@MainActor
public final class SpriteManager {
    public static let shared = SpriteManager()
    
    private var imageCache: [String: NSImage] = [:]
    
    private init() {}
    
    public func frameImage(for avatar: CatAvatar, state: AnimationState, frameIndex: Int) -> NSImage? {
        let prefix = avatar.spritePrefix
        let key = "\(prefix)_\(state.rawValue)_\(frameIndex)"
        if let cached = imageCache[key] {
            return cached
        }
        
        let filename: String
        switch state {
        case .idle:
            filename = "\(prefix)_sit_\(frameIndex).png"
        case .walk, .run:
            filename = "\(prefix)_walk_\(frameIndex).png"
        case .sleep:
            filename = "\(prefix)_sleep_\(frameIndex).png"
        case .stretch:
            filename = "\(prefix)_stretch_\(frameIndex).png"
        case .climb:
            filename = "kiko_climb.png"
        case .box_peeking:
            filename = "cardboard_box_peeking.png"
        case .box_head_out:
            filename = "\(prefix)_box_head_out.png"
        case .dragged, .surprised:
            filename = "\(prefix)_sit_0.png"
        }
        
        if let img = loadImage(named: filename) {
            imageCache[key] = img
            return img
        }
        
        // Fallback to kiko base if variant missing
        let fallbackFilename: String
        switch state {
        case .idle, .dragged, .surprised: fallbackFilename = "kiko_sit_0.png"
        case .walk, .run: fallbackFilename = "kiko_walk_0.png"
        case .sleep: fallbackFilename = "kiko_sleep_0.png"
        case .stretch: fallbackFilename = "kiko_stretch_0.png"
        case .climb: fallbackFilename = "kiko_climb.png"
        case .box_peeking: fallbackFilename = "cardboard_box_peeking.png"
        case .box_head_out: fallbackFilename = "cardboard_box_head_out.png"
        }
        if let fallbackImg = loadImage(named: fallbackFilename) {
            imageCache[key] = fallbackImg
            return fallbackImg
        }
        
        return nil
    }
    
    public func specialImage(named filename: String) -> NSImage? {
        if let cached = imageCache[filename] {
            return cached
        }
        if let img = loadImage(named: filename) {
            imageCache[filename] = img
            return img
        }
        return nil
    }
    
    private func loadImage(named filename: String) -> NSImage? {
        let candidatePaths = [
            "assets/sprites/processed/\(filename)",
            "Assets/sprites/processed/\(filename)",
            "../assets/sprites/processed/\(filename)",
            "../../assets/sprites/processed/\(filename)",
            Bundle.main.path(forResource: filename, ofType: nil) ?? "",
            Bundle.main.resourcePath.map { "\($0)/\(filename)" } ?? ""
        ]
        
        for path in candidatePaths where !path.isEmpty && FileManager.default.fileExists(atPath: path) {
            if let image = NSImage(contentsOfFile: path) {
                return image
            }
        }
        return nil
    }
}
