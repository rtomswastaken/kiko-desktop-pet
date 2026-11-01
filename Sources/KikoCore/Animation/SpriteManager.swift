// Sources/KikoCore/Animation/SpriteManager.swift
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
        
        // Match action to filename
        let filename: String
        switch state {
        case .sitting:
            filename = "\(prefix)_sitting_\(frameIndex).png"
        case .idle:
            filename = "\(prefix)_idle_\(frameIndex).png"
        case .idle2:
            filename = "\(prefix)_idle2_\(frameIndex).png"
        case .run:
            filename = "\(prefix)_run_\(frameIndex).png"
        case .jump:
            filename = "\(prefix)_jump_\(frameIndex).png"
        case .attack:
            filename = "\(prefix)_attack_\(frameIndex).png"
        case .hurt, .dragged:
            filename = "\(prefix)_hurt_\(frameIndex).png"
        case .sleep:
            filename = "\(prefix)_sleep_\(frameIndex).png"
        case .die:
            filename = "\(prefix)_die_\(frameIndex).png"
        case .box_peeking:
            filename = "cardboard_box_peeking.png"
        case .box_head_out:
            filename = "\(prefix)_sitting_0.png"
        }
        
        if let img = loadImage(named: filename) {
            imageCache[key] = img
            return img
        }
        
        // Avatar-specific fallbacks if avatar lacks idle2 or die
        if state == .idle2 {
            let fallbackIdle = "\(prefix)_idle_\(frameIndex % 7).png"
            if let idleImg = loadImage(named: fallbackIdle) {
                imageCache[key] = idleImg
                return idleImg
            }
        }
        
        if state == .die {
            let fallbackHurt = "\(prefix)_hurt_\(frameIndex % 7).png"
            if let hurtImg = loadImage(named: fallbackHurt) {
                imageCache[key] = hurtImg
                return hurtImg
            }
        }
        
        // Fallback to ginger (default avatar) if variant file missing
        let fallbackGinger = "ginger_\(state.rawValue)_\(frameIndex).png"
        if let fallbackImg = loadImage(named: fallbackGinger) {
            imageCache[key] = fallbackImg
            return fallbackImg
        }
        
        // Guaranteed fallback to any valid standing/sitting frame so cat NEVER vanishes
        if let fallbackAny = loadImage(named: "\(prefix)_idle_0.png") ??
                             loadImage(named: "\(prefix)_sitting_0.png") ??
                             loadImage(named: "ginger_idle_0.png") ??
                             loadImage(named: "ginger_sitting_0.png") {
            imageCache[key] = fallbackAny
            return fallbackAny
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
            "assets/kiko_cat_sprites/\(filename)",
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
