// Sources/Interaction/MiniGameManager.swift
import AppKit

@MainActor
public final class MiniGameManager {
    public static let shared = MiniGameManager()
    
    // Active toy item window
    private var activeToyWindow: NSPanel?
    public var isMiniGameActive: Bool { activeToyWindow != nil }
    private var toyTimer: Timer?
    private var toyPosition: CGPoint = .zero
    private var toyVelocity: CGVector = .zero
    private var isButterfly: Bool = false
    private var butterflyFrameIndex: Int = 0
    private var butterflyTime: TimeInterval = 0.0
    
    private init() {}
    
    public func startLaserPointer() {
        endCurrentGame()
        
        let win = createItemWindow(imageName: "laser_dot.png", size: 24)
        activeToyWindow = win
        BehaviourEngine.shared.isChasingLaser = true
        BehaviourEngine.shared.transitionTo(.playful)
        
        toyTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self = self, let win = self.activeToyWindow else { return }
                let mouse = NSEvent.mouseLocation
                win.setFrameOrigin(CGPoint(x: mouse.x - 12, y: mouse.y - 12))
                BehaviourEngine.shared.customTargetPoint = mouse
            }
        }
    }
    
    public func startYarnBall() {
        endCurrentGame()
        
        let colorIdx = Int.random(in: 0...7)
        let win = createItemWindow(imageName: "yarn_ball_\(colorIdx).png", size: 36)
        activeToyWindow = win
        
        let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        toyPosition = CGPoint(x: screen.midX, y: screen.midY)
        toyVelocity = CGVector(dx: CGFloat.random(in: -180...180), dy: CGFloat.random(in: 100...220))
        win.setFrameOrigin(toyPosition)
        
        BehaviourEngine.shared.isChasingYarn = true
        BehaviourEngine.shared.transitionTo(.playing)
        
        toyTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.updateYarnPhysics(screen: screen)
            }
        }
    }
    
    private func updateYarnPhysics(screen: NSRect) {
        guard let win = activeToyWindow else { return }
        let dt: CGFloat = 0.03
        
        // Apply friction
        toyVelocity.dx *= 0.985
        toyVelocity.dy -= 350.0 * dt // Gravity
        
        toyPosition.x += toyVelocity.dx * dt
        toyPosition.y += toyVelocity.dy * dt
        
        // Bounce off screen floor
        if toyPosition.y <= screen.minY + 20 {
            toyPosition.y = screen.minY + 20
            toyVelocity.dy = -toyVelocity.dy * 0.75
            if abs(toyVelocity.dy) < 20 { toyVelocity.dy = 0 }
        }
        // Bounce off walls
        if toyPosition.x <= screen.minX + 20 || toyPosition.x >= screen.maxX - 50 {
            toyVelocity.dx = -toyVelocity.dx * 0.8
        }
        
        win.setFrameOrigin(toyPosition)
        BehaviourEngine.shared.customTargetPoint = toyPosition
        
        // Check if cat reached yarn ball
        let petPos = PetState.shared.position
        if hypot(toyPosition.x - petPos.x, toyPosition.y - petPos.y) < 40.0 {
            // Bat the ball!
            let kickDirection: CGFloat = PetState.shared.isFacingLeft ? -1.0 : 1.0
            toyVelocity.dx = kickDirection * CGFloat.random(in: 180...320)
            toyVelocity.dy = CGFloat.random(in: 150...280)
            SoundManager.shared.play(.pounce)
            PetState.shared.playWithToy()
        }
    }
    
    public func startButterfly() {
        endCurrentGame()
        
        let win = createItemWindow(imageName: "butterfly_0.png", size: 32)
        activeToyWindow = win
        isButterfly = true
        
        let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        toyPosition = CGPoint(x: screen.minX + 50, y: screen.midY)
        win.setFrameOrigin(toyPosition)
        
        BehaviourEngine.shared.transitionTo(.curious)
        
        toyTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.updateButterfly()
            }
        }
    }
    
    private func updateButterfly() {
        guard let win = activeToyWindow, let imgView = win.contentView?.subviews.first as? NSImageView else { return }
        butterflyTime += 0.04
        
        // Wing flap animation
        if Int(butterflyTime * 15) % 2 == 0 {
            imgView.image = SpriteManager.shared.specialImage(named: "butterfly_0.png")
        } else {
            imgView.image = SpriteManager.shared.specialImage(named: "butterfly_1.png")
        }
        
        // Gentle undulating flight
        toyPosition.x += 2.8
        toyPosition.y += sin(butterflyTime * 3.5) * 4.0
        
        let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        if toyPosition.x > screen.maxX + 40 {
            endCurrentGame()
            return
        }
        
        win.setFrameOrigin(toyPosition)
        BehaviourEngine.shared.customTargetPoint = toyPosition
    }
    
    public func dropFishTreat() {
        endCurrentGame()
        
        let win = createItemWindow(imageName: "fish_treat.png", size: 36)
        activeToyWindow = win
        
        // Drop treat 80px in front of cat
        let petPos = PetState.shared.position
        let dir: CGFloat = PetState.shared.isFacingLeft ? -1.0 : 1.0
        toyPosition = CGPoint(x: petPos.x + dir * 120, y: petPos.y)
        win.setFrameOrigin(toyPosition)
        
        BehaviourEngine.shared.customTargetPoint = toyPosition
        BehaviourEngine.shared.transitionTo(.walking)
        
        // Wait until cat reaches treat
        toyTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            MainActor.assumeIsolated {
                guard let self = self else { return }
                let currentPetPos = PetState.shared.position
                if hypot(self.toyPosition.x - currentPetPos.x, self.toyPosition.y - currentPetPos.y) < 35.0 {
                    // Cat ate treat!
                    SoundManager.shared.play(.purr)
                    PetState.shared.feedTreat()
                    self.endCurrentGame()
                }
            }
        }
    }
    
    public func endCurrentGame() {
        toyTimer?.invalidate()
        toyTimer = nil
        activeToyWindow?.orderOut(nil)
        activeToyWindow = nil
        isButterfly = false
        butterflyTime = 0.0
        BehaviourEngine.shared.customTargetPoint = nil
        BehaviourEngine.shared.isChasingLaser = false
        BehaviourEngine.shared.isChasingYarn = false
    }
    
    private func createItemWindow(imageName: String, size: CGFloat) -> NSPanel {
        let win = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: size, height: size),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        win.isOpaque = false
        win.backgroundColor = .clear
        win.hasShadow = false
        win.level = .floating
        win.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        
        let iv = NSImageView(frame: NSRect(x: 0, y: 0, width: size, height: size))
        iv.imageScaling = .scaleProportionallyUpOrDown
        iv.wantsLayer = true
        iv.layer?.magnificationFilter = .nearest
        iv.image = SpriteManager.shared.specialImage(named: imageName)
        
        let cv = NSView(frame: NSRect(x: 0, y: 0, width: size, height: size))
        cv.addSubview(iv)
        win.contentView = cv
        win.makeKeyAndOrderFront(nil)
        return win
    }
}
