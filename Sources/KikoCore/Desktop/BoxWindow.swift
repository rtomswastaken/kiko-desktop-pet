// Sources/KikoCore/Desktop/BoxWindow.swift
import AppKit

@MainActor
public final class BoxWindow: NSPanel {
    private let boxImageView: NSImageView
    private var isDragging: Bool = false
    private var dragStartMouseLocation: NSPoint = .zero
    private var dragStartWindowOrigin: NSPoint = .zero
    
    public init() {
        let size: CGFloat = 96.0
        let savedX = UserDefaults.standard.object(forKey: "kiko.boxOriginX") as? CGFloat ?? 350.0
        let savedY = UserDefaults.standard.object(forKey: "kiko.boxOriginY") as? CGFloat ?? 180.0
        let rect = NSRect(x: savedX, y: savedY, width: size, height: size)
        
        boxImageView = NSImageView(frame: NSRect(x: 0, y: 0, width: size, height: size))
        boxImageView.imageScaling = .scaleProportionallyUpOrDown
        boxImageView.wantsLayer = true
        boxImageView.layer?.magnificationFilter = .nearest
        
        super.init(
            contentRect: rect,
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
        contentView.addSubview(boxImageView)
        self.contentView = contentView
        
        updateVisualState()
    }
    
    public func updateVisualState() {
        let petState = PetState.shared
        let prefs = Preferences.shared
        let imgName: String
        
        if prefs.useCatBed {
            imgName = "cat_bed_\(prefs.bedColor).png"
        } else {
            if petState.isInBox {
                switch BehaviourEngine.shared.currentBehaviour {
                case .hiding, .sleeping:
                    imgName = "cardboard_box_peeking.png"
                case .boxIdle, .watchingCursor:
                    imgName = "\(petState.currentAvatar.spritePrefix)_sitting_0.png"
                default:
                    imgName = "cardboard_box_empty.png"
                }
            } else {
                imgName = "cardboard_box_empty.png"
            }
        }
        
        if let img = SpriteManager.shared.specialImage(named: imgName) {
            boxImageView.image = img
        }
    }
    
    public override func mouseDown(with event: NSEvent) {
        isDragging = true
        dragStartMouseLocation = NSEvent.mouseLocation
        dragStartWindowOrigin = self.frame.origin
        
        if PetState.shared.isInBox {
            SoundManager.shared.play(.purr)
            BehaviourEngine.shared.transitionTo(.boxIdle)
            updateVisualState()
        }
    }
    
    public override func mouseDragged(with event: NSEvent) {
        guard isDragging else { return }
        let currentMouse = NSEvent.mouseLocation
        let dx = currentMouse.x - dragStartMouseLocation.x
        let dy = currentMouse.y - dragStartMouseLocation.y
        
        var newOrigin = NSPoint(x: dragStartWindowOrigin.x + dx, y: dragStartWindowOrigin.y + dy)
        if let screen = self.screen {
            let vf = screen.visibleFrame
            newOrigin.x = max(vf.minX, min(newOrigin.x, vf.maxX - self.frame.width))
            newOrigin.y = max(vf.minY, min(newOrigin.y, vf.maxY - self.frame.height))
        }
        self.setFrameOrigin(newOrigin)
        
        UserDefaults.standard.set(newOrigin.x, forKey: "kiko.boxOriginX")
        UserDefaults.standard.set(newOrigin.y, forKey: "kiko.boxOriginY")
    }
    
    public override func mouseUp(with event: NSEvent) {
        isDragging = false
    }
}

@MainActor
public final class BoxInteractionController {
    public static let shared = BoxInteractionController()
    
    public var boxWindow: BoxWindow?
    
    public var boxPosition: CGPoint? {
        guard let frame = boxWindow?.frame else { return nil }
        return CGPoint(x: frame.midX, y: frame.minY + 20)
    }
    
    private init() {}
    
    public func setup(boxWindow: BoxWindow) {
        self.boxWindow = boxWindow
    }
    
    public func setVisible(_ visible: Bool) {
        if visible {
            boxWindow?.makeKeyAndOrderFront(nil)
        } else {
            boxWindow?.orderOut(nil)
        }
    }
}
