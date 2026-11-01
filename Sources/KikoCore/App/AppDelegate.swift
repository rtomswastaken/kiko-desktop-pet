// Sources/App/AppDelegate.swift
import AppKit

@MainActor
public final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var petWindow: PetWindow?
    private var boxWindow: BoxWindow?
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        // Setup Cardboard Box desktop window
        boxWindow = BoxWindow()
        if let box = boxWindow {
            BoxInteractionController.shared.setup(boxWindow: box)
            if Preferences.shared.boxVisible {
                box.makeKeyAndOrderFront(nil)
            }
        }
        
        // Setup Main Desktop Pet Window
        petWindow = PetWindow()
        petWindow?.makeKeyAndOrderFront(nil)
        
        // Start random events scheduler
        RandomEventManager.shared.start()
        
        // Setup Status Bar Menu
        setupStatusItem()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.title = "🐈"
            button.toolTip = "Desktop Cat Companion"
        }
        
        updateMenu()
    }
    
    public func updateMenu() {
        let menu = NSMenu()
        
        let prefs = Preferences.shared
        let petState = PetState.shared
        
        // Title & status header
        let statusTitle = "\(prefs.customCatName) (\(prefs.selectedAvatar.shortName)) • \(petState.currentMood.emoji) \(petState.currentMood.rawValue)"
        let titleItem = NSMenuItem(title: statusTitle, action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        menu.addItem(titleItem)
        menu.addItem(NSMenuItem.separator())
        
        // Mini-Games Submenu
        let playMenu = NSMenu()
        let laserItem = NSMenuItem(title: "🔴 Laser Pointer", action: #selector(startLaser), keyEquivalent: "l")
        laserItem.target = self
        playMenu.addItem(laserItem)
        
        let yarnItem = NSMenuItem(title: "🧶 Yarn Ball", action: #selector(startYarnBall), keyEquivalent: "y")
        yarnItem.target = self
        playMenu.addItem(yarnItem)
        
        let treatItem = NSMenuItem(title: "🐟 Give Fish Treat", action: #selector(giveTreat), keyEquivalent: "t")
        treatItem.target = self
        playMenu.addItem(treatItem)
        
        let playParentItem = NSMenuItem(title: "Play & Toys", action: nil, keyEquivalent: "")
        playParentItem.submenu = playMenu
        menu.addItem(playParentItem)
        
        // Quick Actions
        let zoomiesItem = NSMenuItem(title: "Trigger Zoomies", action: #selector(triggerZoomies), keyEquivalent: "z")
        zoomiesItem.target = self
        menu.addItem(zoomiesItem)
        
        let sleepToggleTitle = petState.currentMood == .sleepy ? "Wake Up" : "Put to Sleep"
        let sleepItem = NSMenuItem(title: sleepToggleTitle, action: #selector(toggleSleep), keyEquivalent: "s")
        sleepItem.target = self
        menu.addItem(sleepItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Avatar Switcher Submenu
        let avatarMenu = NSMenu()
        for avatar in CatAvatar.allCases {
            let isSelected = prefs.selectedAvatar == avatar
            let item = NSMenuItem(
                title: "\(isSelected ? "✓ " : "")\(avatar.displayName)",
                action: #selector(selectAvatarFromMenu(_:)),
                keyEquivalent: ""
            )
            item.target = self
            item.representedObject = avatar
            avatarMenu.addItem(item)
        }
        let avatarParentItem = NSMenuItem(title: "Cat Avatar", action: nil, keyEquivalent: "")
        avatarParentItem.submenu = avatarMenu
        menu.addItem(avatarParentItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Resting Spot Submenu
        let restMenu = NSMenu()
        let toggleBoxVisible = NSMenuItem(
            title: prefs.boxVisible ? "Hide Resting Spot" : "Show Resting Spot",
            action: #selector(toggleBox),
            keyEquivalent: ""
        )
        toggleBoxVisible.target = self
        restMenu.addItem(toggleBoxVisible)
        
        let switchStyleItem = NSMenuItem(
            title: prefs.useCatBed ? "Switch to Cardboard Box" : "Switch to Cat Bed",
            action: #selector(toggleBedStyle),
            keyEquivalent: ""
        )
        switchStyleItem.target = self
        restMenu.addItem(switchStyleItem)
        
        let restParentItem = NSMenuItem(title: "Cozy Resting Spot", action: nil, keyEquivalent: "")
        restParentItem.submenu = restMenu
        menu.addItem(restParentItem)
        
        // Reset Position
        let resetItem = NSMenuItem(title: "Reset Cat Position", action: #selector(resetPosition), keyEquivalent: "r")
        resetItem.target = self
        menu.addItem(resetItem)
        
        // Hide / Show Cat
        let hideTitle = prefs.isPetVisible ? "Hide Cat" : "Show Cat"
        let hideItem = NSMenuItem(title: hideTitle, action: #selector(toggleVisibility), keyEquivalent: "h")
        hideItem.target = self
        menu.addItem(hideItem)
        
        // Preferences
        let prefsItem = NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: ",")
        prefsItem.target = self
        menu.addItem(prefsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    @objc private func startLaser() {
        MiniGameManager.shared.startLaserPointer()
    }
    
    @objc private func startYarnBall() {
        MiniGameManager.shared.startYarnBall()
    }
    
    @objc private func giveTreat() {
        MiniGameManager.shared.dropFishTreat()
    }
    
    @objc private func triggerZoomies() {
        BehaviourEngine.shared.triggerZoomies()
    }
    
    @objc private func toggleSleep() {
        if PetState.shared.currentMood == .sleepy {
            BehaviourEngine.shared.wakeUp()
        } else {
            BehaviourEngine.shared.forceSleep()
        }
    }
    
    @objc private func selectAvatarFromMenu(_ sender: NSMenuItem) {
        if let avatar = sender.representedObject as? CatAvatar {
            Preferences.shared.selectedAvatar = avatar
            updateMenu()
        }
    }
    
    @objc private func toggleBox() {
        Preferences.shared.boxVisible.toggle()
        updateMenu()
    }
    
    @objc private func toggleBedStyle() {
        Preferences.shared.useCatBed.toggle()
        updateMenu()
    }
    
    @objc private func resetPosition() {
        if let screen = NSScreen.main {
            let pos = CGPoint(x: screen.visibleFrame.midX, y: screen.visibleFrame.midY)
            PetState.shared.position = pos
            petWindow?.setFrameOrigin(pos)
        }
    }
    
    @objc private func toggleVisibility() {
        Preferences.shared.isPetVisible.toggle()
        petWindow?.setIsVisible(Preferences.shared.isPetVisible)
        updateMenu()
    }
    
    @objc private func openPreferences() {
        SettingsWindowManager.shared.showSettings()
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
