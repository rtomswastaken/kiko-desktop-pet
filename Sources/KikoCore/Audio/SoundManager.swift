// Sources/Audio/SoundManager.swift
import AppKit

@MainActor
public final class SoundManager {
    public static let shared = SoundManager()
    
    private var soundCache: [String: NSSound] = [:]
    
    private init() {}
    
    public func play(_ effect: SoundEffect) {
        guard Preferences.shared.soundEnabled else { return }
        
        let filename = effect.rawValue
        let sound: NSSound?
        
        if let cached = soundCache[filename] {
            sound = cached
        } else {
            sound = loadSound(named: filename)
            if let s = sound {
                soundCache[filename] = s
            }
        }
        
        if let s = sound {
            s.volume = effect.defaultVolume * Preferences.shared.soundVolume
            s.stop()
            s.play()
        }
    }
    
    private func loadSound(named filename: String) -> NSSound? {
        let candidates = [
            "assets/audio/\(filename)",
            "Assets/audio/\(filename)",
            "../assets/audio/\(filename)",
            Bundle.main.path(forResource: filename, ofType: nil) ?? "",
            Bundle.main.resourcePath.map { "\($0)/\(filename)" } ?? ""
        ]
        
        for path in candidates where !path.isEmpty && FileManager.default.fileExists(atPath: path) {
            if let s = NSSound(contentsOfFile: path, byReference: true) {
                return s
            }
        }
        return nil
    }
}
