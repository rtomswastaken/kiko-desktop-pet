// Sources/Audio/SoundManager.swift
import AppKit

@MainActor
public final class SoundManager {
    public static let shared = SoundManager()
    
    public var isMuted: Bool = false
    public var masterVolume: Float = 0.8
    
    private init() {}
    
    public func play(_ effect: SoundEffect) {
        guard !isMuted else { return }
        // Uses macOS system sound notification or bundled audio
        if effect == .purr || effect == .meow {
            NSSound.beep()
        }
    }
}
