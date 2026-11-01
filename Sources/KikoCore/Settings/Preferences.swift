// Sources/KikoCore/Settings/Preferences.swift
import Foundation

@MainActor
public final class Preferences: ObservableObject {
    public static let shared = Preferences()
    
    private let defaults = UserDefaults.standard
    
    @Published public var selectedAvatar: CatAvatar {
        didSet {
            defaults.set(selectedAvatar.rawValue, forKey: "kiko.selectedAvatar")
            PetState.shared.selectAvatar(selectedAvatar)
        }
    }
    
    @Published public var customCatName: String {
        didSet { defaults.set(customCatName, forKey: "kiko.customCatName") }
    }
    
    @Published public var petScale: Double {
        didSet { defaults.set(petScale, forKey: "kiko.petScale") }
    }
    
    @Published public var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: "kiko.soundEnabled") }
    }
    
    @Published public var soundVolume: Float {
        didSet { defaults.set(soundVolume, forKey: "kiko.soundVolume") }
    }
    
    @Published public var cursorTrackingEnabled: Bool {
        didSet { defaults.set(cursorTrackingEnabled, forKey: "kiko.cursorTrackingEnabled") }
    }
    
    @Published public var randomEventsEnabled: Bool {
        didSet { defaults.set(randomEventsEnabled, forKey: "kiko.randomEventsEnabled") }
    }
    
    @Published public var windowInteractionsEnabled: Bool {
        didSet { defaults.set(windowInteractionsEnabled, forKey: "kiko.windowInteractionsEnabled") }
    }
    
    @Published public var isPetVisible: Bool {
        didSet { defaults.set(isPetVisible, forKey: "kiko.isPetVisible") }
    }
    
    @Published public var boxVisible: Bool {
        didSet {
            defaults.set(boxVisible, forKey: "kiko.boxVisible")
            BoxInteractionController.shared.setVisible(boxVisible)
        }
    }
    
    @Published public var bedColor: String {
        didSet {
            defaults.set(bedColor, forKey: "kiko.bedColor")
            BoxInteractionController.shared.boxWindow?.updateVisualState()
        }
    }
    
    @Published public var useCatBed: Bool {
        didSet {
            defaults.set(useCatBed, forKey: "kiko.useCatBed")
            BoxInteractionController.shared.boxWindow?.updateVisualState()
        }
    }
    
    private init() {
        let avatarRaw = UserDefaults.standard.string(forKey: "kiko.selectedAvatar") ?? "ginger"
        self.selectedAvatar = CatAvatar(rawValue: avatarRaw) ?? .ginger
        self.customCatName = UserDefaults.standard.string(forKey: "kiko.customCatName") ?? "Kiko"
        self.petScale = UserDefaults.standard.object(forKey: "kiko.petScale") as? Double ?? 3.0
        self.soundEnabled = UserDefaults.standard.object(forKey: "kiko.soundEnabled") as? Bool ?? true
        self.soundVolume = UserDefaults.standard.object(forKey: "kiko.soundVolume") as? Float ?? 0.8
        self.cursorTrackingEnabled = UserDefaults.standard.object(forKey: "kiko.cursorTrackingEnabled") as? Bool ?? true
        self.randomEventsEnabled = UserDefaults.standard.object(forKey: "kiko.randomEventsEnabled") as? Bool ?? true
        self.windowInteractionsEnabled = UserDefaults.standard.object(forKey: "kiko.windowInteractionsEnabled") as? Bool ?? true
        self.isPetVisible = UserDefaults.standard.object(forKey: "kiko.isPetVisible") as? Bool ?? true
        self.boxVisible = UserDefaults.standard.object(forKey: "kiko.boxVisible") as? Bool ?? true
        self.bedColor = UserDefaults.standard.string(forKey: "kiko.bedColor") ?? "blue"
        self.useCatBed = UserDefaults.standard.object(forKey: "kiko.useCatBed") as? Bool ?? true
    }
}
