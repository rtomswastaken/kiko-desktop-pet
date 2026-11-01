// Sources/App/AppDelegate.swift
import AppKit

@MainActor
public final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var petWindow: PetWindow?
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        petWindow = PetWindow()
        petWindow?.makeKeyAndOrderFront(nil)
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.title = "🐈"
            button.toolTip = "Kiko Desktop Pet"
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Kiko (macOS Desktop Pet)", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        let zoomiesItem = NSMenuItem(title: "Trigger Zoomies", action: #selector(triggerZoomies), keyEquivalent: "z")
        zoomiesItem.target = self
        menu.addItem(zoomiesItem)
        
        let sleepItem = NSMenuItem(title: "Put to Sleep", action: #selector(forceSleep), keyEquivalent: "s")
        sleepItem.target = self
        menu.addItem(sleepItem)
        
        menu.addItem(NSMenuItem.separator())
        let quitItem = NSMenuItem(title: "Quit Kiko", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    @objc private func triggerZoomies() {
        BehaviourEngine.shared.triggerZoomies()
    }
    
    @objc private func forceSleep() {
        BehaviourEngine.shared.forceSleep()
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
