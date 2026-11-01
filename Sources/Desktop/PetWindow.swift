// Sources/Desktop/PetWindow.swift
import AppKit

@MainActor
public final class PetWindow: NSPanel {
    private let catImageView: NSImageView
    private let animation = SpriteAnimation()
    private var updateTimer: Timer?
    
    public init() {
        let size = Constants.defaultWindowSize
        let initialRect = NSRect(x: 200, y: 200, width: size, height: size)
        
        catImageView = NSImageView(frame: NSRect(x: 0, y: 0, width: size, height: size))
        catImageView.imageScaling = .scaleProportionallyUpOrDown
        catImageView.wantsLayer = true
        catImageView.layer?.magnificationFilter = .nearest
        
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
        self.contentView = contentView
        
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
        
        let targetAnim = behaviourEngine.currentBehaviour.associatedAnimation
        animation.setState(targetAnim)
        
        let frameChanged = animation.update(deltaTime: dt)
        if frameChanged || catImageView.image == nil {
            if let frameImg = SpriteManager.shared.frameImage(
                for: animation.currentState,
                frameIndex: animation.currentFrameIndex
            ) {
                catImageView.image = frameImg
            }
        }
    }
    
    public override func mouseDown(with event: NSEvent) {
        InteractionManager.shared.handleMouseDown(with: event, window: self)
    }
    
    public override func mouseDragged(with event: NSEvent) {
        InteractionManager.shared.handleMouseDragged(with: event, window: self)
    }
    
    public override func mouseUp(with event: NSEvent) {
        InteractionManager.shared.handleMouseUp(with: event, window: self)
    }
}
