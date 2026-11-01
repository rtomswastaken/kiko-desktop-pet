// Sources/Desktop/PetWindow.swift
import AppKit

@MainActor
public final class PetWindow: NSPanel {
    private let catImageView: NSImageView
    private let animation = SpriteAnimation()
    private var updateTimer: Timer?
    
    // Drag elastic squash-and-stretch state
    private var dragVelocity: CGPoint = .zero
    private var lastDragPosition: CGPoint = .zero
    private var lastDragTimestamp: TimeInterval = 0.0
    private var wigglePhase: CGFloat = 0.0
    
    // Floating particle layer
    private let fxImageView: NSImageView
    private var fxTimer: TimeInterval = 0.0
    
    public init() {
        let size = Constants.defaultWindowSize
        let savedX = UserDefaults.standard.object(forKey: "kiko.lastPosX") as? CGFloat ?? 220.0
        let savedY = UserDefaults.standard.object(forKey: "kiko.lastPosY") as? CGFloat ?? 160.0
        let initialRect = NSRect(x: savedX, y: savedY, width: size, height: size)
        
        catImageView = NSImageView(frame: NSRect(x: 0, y: 0, width: size, height: size))
        catImageView.imageScaling = .scaleProportionallyUpOrDown
        catImageView.wantsLayer = true
        catImageView.layer?.magnificationFilter = .nearest
        
        fxImageView = NSImageView(frame: NSRect(x: size * 0.35, y: size * 0.7, width: 24, height: 24))
        fxImageView.imageScaling = .scaleProportionallyUpOrDown
        fxImageView.wantsLayer = true
        fxImageView.isHidden = true
        
        super.init(
            contentRect: initialRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = false
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        self.isMovableByWindowBackground = false
        
        let contentView = NSView(frame: NSRect(x: 0, y: 0, width: size, height: size))
        contentView.addSubview(catImageView)
        contentView.addSubview(fxImageView)
        self.contentView = contentView
        
        PetState.shared.position = initialRect.origin
        
        startLoop()
    }
    
    private func startLoop() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: Constants.tickInterval, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.tick()
            }
        }
    }
    
    private func tick() {
        let dt = Constants.tickInterval
        let behaviourEngine = BehaviourEngine.shared
        behaviourEngine.update(deltaTime: dt)
        
        let petState = PetState.shared
        
        // If cat is inside cardboard box, hide pet window (cat is visible in BoxWindow)
        if petState.isInBox {
            if !self.alphaValue.isZero {
                self.alphaValue = 0.0
            }
            BoxInteractionController.shared.boxWindow?.updateVisualState()
            return
        } else if self.alphaValue != 1.0 && Preferences.shared.isPetVisible {
            self.alphaValue = 1.0
        }
        
        // Window title bar perching detection
        if Preferences.shared.windowInteractionsEnabled &&
            (behaviourEngine.currentBehaviour == .walking || behaviourEngine.currentBehaviour == .idle) {
            if let titleBar = WindowDetector.shared.findNearestTitleBar(to: petState.position, maxDistance: 40.0) {
                // If cat is very close to title bar, it can rest on top of it!
                if !petState.isPerchedOnWindow && Double.random(in: 0...1) < 0.05 {
                    petState.isPerchedOnWindow = true
                    petState.position.y = titleBar.topEdgeY
                    behaviourEngine.transitionTo(.windowWatching)
                }
            } else {
                petState.isPerchedOnWindow = false
            }
        }
        
        // Update window position from PetState unless dragging
        if !InteractionManager.shared.isDragging {
            var pos = petState.position
            // Boundary enforcement
            if let screen = self.screen ?? NSScreen.main {
                let vf = screen.visibleFrame
                pos.x = max(vf.minX, min(pos.x, vf.maxX - self.frame.width))
                pos.y = max(vf.minY, min(pos.y, vf.maxY - self.frame.height))
                petState.position = pos
            }
            self.setFrameOrigin(pos)
        }
        
        // Animation update
        let targetAnim = behaviourEngine.currentBehaviour.associatedAnimation
        animation.setState(targetAnim)
        let _ = animation.update(deltaTime: dt)
        
        // Frame rendering with Retina backing scale
        if let frameImg = SpriteManager.shared.frameImage(
            for: petState.currentAvatar,
            state: animation.currentState,
            frameIndex: animation.currentFrameIndex
        ) {
            catImageView.image = frameImg
        }
        
        // Horizontal orientation (flip facing right)
        updateTransform()
        
        // Floating particle decay
        if fxTimer > 0 {
            fxTimer -= dt
            fxImageView.frame.origin.y += 15.0 * CGFloat(dt)
            if fxTimer <= 0 {
                fxImageView.isHidden = true
            }
        }
    }
    
    private func updateTransform() {
        guard let layer = catImageView.layer else { return }
        
        var transform = CATransform3DIdentity
        
        // Horizontal flip: default sprite faces left
        if !PetState.shared.isFacingLeft {
            transform = CATransform3DScale(transform, -1.0, 1.0, 1.0)
        }
        
        // Elastic squash & stretch during dragging
        if InteractionManager.shared.isDragging {
            let speed = hypot(dragVelocity.x, dragVelocity.y)
            if speed > 400.0 {
                // Fast drag wiggle flail
                wigglePhase += 0.4
                let angle = sin(wigglePhase) * 0.18
                transform = CATransform3DRotate(transform, angle, 0, 0, 1)
                transform = CATransform3DScale(transform, 0.85, 1.25, 1.0)
            } else {
                // Gentle stretch upward
                transform = CATransform3DScale(transform, 0.90, 1.15, 1.0)
            }
        }
        
        layer.transform = transform
    }
    
    public func showFloatingEffect(_ effectName: String, duration: TimeInterval = 1.2) {
        if let img = SpriteManager.shared.specialImage(named: effectName) {
            fxImageView.image = img
            fxImageView.frame.origin = CGPoint(x: self.frame.width * 0.35, y: self.frame.height * 0.65)
            fxImageView.isHidden = false
            fxTimer = duration
        }
    }
    
    public override func mouseDown(with event: NSEvent) {
        InteractionManager.shared.handleMouseDown(with: event, window: self)
        lastDragPosition = NSEvent.mouseLocation
        lastDragTimestamp = Date().timeIntervalSince1970
        dragVelocity = .zero
    }
    
    public override func mouseDragged(with event: NSEvent) {
        let currentMouse = NSEvent.mouseLocation
        let now = Date().timeIntervalSince1970
        let dt = max(0.001, now - lastDragTimestamp)
        
        dragVelocity = CGPoint(
            x: (currentMouse.x - lastDragPosition.x) / CGFloat(dt),
            y: (currentMouse.y - lastDragPosition.y) / CGFloat(dt)
        )
        lastDragPosition = currentMouse
        lastDragTimestamp = now
        
        InteractionManager.shared.handleMouseDragged(with: event, window: self)
    }
    
    public override func mouseUp(with event: NSEvent) {
        InteractionManager.shared.handleMouseUp(with: event, window: self)
        dragVelocity = .zero
        
        // Soft landing bounce back to normal scale
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        catImageView.layer?.transform = CATransform3DIdentity
        CATransaction.commit()
        
        // Persist position
        UserDefaults.standard.set(self.frame.origin.x, forKey: "kiko.lastPosX")
        UserDefaults.standard.set(self.frame.origin.y, forKey: "kiko.lastPosY")
    }
}
