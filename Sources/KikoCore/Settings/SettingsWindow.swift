// Sources/Settings/SettingsWindow.swift
import AppKit
import SwiftUI

public struct SettingsView: View {
    @ObservedObject var prefs = Preferences.shared
    @ObservedObject var petState = PetState.shared
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Header
            HStack(spacing: 12) {
                Text(petState.currentMood.emoji)
                    .font(.system(size: 36))
                VStack(alignment: .leading, spacing: 2) {
                    Text(prefs.customCatName)
                        .font(.headline)
                    Text("Mood: \(petState.currentMood.rawValue) • \(petState.currentMood.description)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom, 4)
            
            Divider()
            
            // Cat Avatar Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Cat Avatar")
                    .font(.subheadline).bold()
                
                Picker("Avatar", selection: $prefs.selectedAvatar) {
                    ForEach(CatAvatar.allCases) { av in
                        Text(av.displayName).tag(av)
                    }
                }
                .pickerStyle(.segmented)
                
                Text(prefs.selectedAvatar.breedDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Cat Name
            HStack {
                Text("Name:")
                    .frame(width: 80, alignment: .leading)
                TextField("Cat Name", text: $prefs.customCatName)
                    .textFieldStyle(.roundedBorder)
            }
            
            Divider()
            
            // Meters
            VStack(alignment: .leading, spacing: 6) {
                Text("Current Status")
                    .font(.subheadline).bold()
                
                HStack {
                    Text("Energy:")
                        .font(.caption).frame(width: 70, alignment: .leading)
                    ProgressView(value: petState.energy)
                        .tint(.orange)
                    Text("\(Int(petState.energy * 100))%")
                        .font(.caption).monospacedDigit()
                }
                
                HStack {
                    Text("Boredom:")
                        .font(.caption).frame(width: 70, alignment: .leading)
                    ProgressView(value: petState.boredom)
                        .tint(.blue)
                    Text("\(Int(petState.boredom * 100))%")
                        .font(.caption).monospacedDigit()
                }
                
                HStack {
                    Text("Affection:")
                        .font(.caption).frame(width: 70, alignment: .leading)
                    ProgressView(value: petState.affection)
                        .tint(.pink)
                    Text("\(Int(petState.affection * 100))%")
                        .font(.caption).monospacedDigit()
                }
            }
            
            Divider()
            
            // Toggles
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Sound Effects", isOn: $prefs.soundEnabled)
                if prefs.soundEnabled {
                    HStack {
                        Text("Volume:")
                            .font(.caption)
                        Slider(value: $prefs.soundVolume, in: 0.0...1.0)
                    }
                }
                Toggle("Follow & React to Mouse Cursor", isOn: $prefs.cursorTrackingEnabled)
                Toggle("Interact with Window Edges & Title Bars", isOn: $prefs.windowInteractionsEnabled)
                Toggle("Enable Random Desktop Events", isOn: $prefs.randomEventsEnabled)
                Toggle("Show Cardboard Box on Desktop", isOn: $prefs.boxVisible)
            }
            
            Divider()
            
            // Mini-Games & Actions
            VStack(alignment: .leading, spacing: 8) {
                Text("Mini-Games & Play")
                    .font(.subheadline).bold()
                
                HStack(spacing: 8) {
                    Button("🔴 Laser Dot") {
                        MiniGameManager.shared.startLaserPointer()
                    }
                    Button("🧶 Yarn Ball") {
                        MiniGameManager.shared.startYarnBall()
                    }
                    Button("🦋 Butterfly") {
                        MiniGameManager.shared.startButterfly()
                    }
                    Button("🐟 Fish Treat") {
                        MiniGameManager.shared.dropFishTreat()
                    }
                }
                
                HStack(spacing: 8) {
                    Button("⚡ Zoomies!") {
                        BehaviourEngine.shared.triggerZoomies()
                    }
                    Button("😴 Put to Sleep") {
                        BehaviourEngine.shared.forceSleep()
                    }
                    Button("📍 Reset Position") {
                        if let screen = NSScreen.main {
                            PetState.shared.position = CGPoint(x: screen.visibleFrame.midX, y: screen.visibleFrame.midY)
                        }
                    }
                }
            }
        }
        .padding(20)
        .frame(width: 440)
    }
}

@MainActor
public final class SettingsWindowManager {
    public static let shared = SettingsWindowManager()
    private var window: NSWindow?
    
    private init() {}
    
    public func showSettings() {
        if let win = window {
            win.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        let hosting = NSHostingController(rootView: SettingsView())
        let win = NSWindow(contentViewController: hosting)
        win.title = "Desktop Cat Preferences"
        win.styleMask = [.titled, .closable]
        win.isReleasedWhenClosed = false
        win.center()
        self.window = win
        
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
