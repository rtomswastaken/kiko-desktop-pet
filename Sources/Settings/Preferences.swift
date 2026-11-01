// Sources/Settings/Preferences.swift
import Foundation

@MainActor
public final class Preferences: ObservableObject {
    public static let shared = Preferences()
    
    private let defaults = UserDefaults.standard
    
    @Published public var petScale: Double {
        didSet { defaults.set(petScale, forKey: "kiko.petScale") }
    }
    
    @Published public var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: "kiko.soundEnabled") }
    }
    
    @Published public var allowZoomies: Bool {
        didSet { defaults.set(allowZoomies, forKey: "kiko.allowZoomies") }
    }
    
    private init() {
        self.petScale = UserDefaults.standard.object(forKey: "kiko.petScale") as? Double ?? 2.0
        self.soundEnabled = UserDefaults.standard.object(forKey: "kiko.soundEnabled") as? Bool ?? true
        self.allowZoomies = UserDefaults.standard.object(forKey: "kiko.allowZoomies") as? Bool ?? true
    }
}
