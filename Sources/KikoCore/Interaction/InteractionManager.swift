// Sources/Interaction/InteractionManager.swift
import AppKit

@MainActor
public final class InteractionManager {
    public static let shared = InteractionManager()
    
    public private(set) var isDragging: Bool = false
    private var dragStartMouseLocation: NSPoint = .zero
    private var dragStartWindowOrigin: NSPoint = .zero
    private var petStrokeCounter: Int = 0
    private var lastStrokeTime: TimeInterval = 0.0
    
    private init() {}
    
    public func handleMouseDown(with event: NSEvent, window: NSWindow) {
        isDragging = true
        dragStartMouseLocation = NSEvent.mouseLocation
        dragStartWindowOrigin = window.frame.origin
        
        BehaviourEngine.shared.transitionTo(.dragged)
        
        // Click sound & reaction
        SoundManager.shared.play(.meow)
        if let petWin = window as? PetWindow {
            petWin.showFloatingEffect("fx_heart.png")
        }
    }
    
    public func handleMouseDragged(with event: NSEvent, window: NSWindow) {
        guard isDragging else { return }
        let currentMouse = NSEvent.mouseLocation
        let dx = currentMouse.x - dragStartMouseLocation.x
        let dy = currentMouse.y - dragStartMouseLocation.y
        
        var newOrigin = NSPoint(x: dragStartWindowOrigin.x + dx, y: dragStartWindowOrigin.y + dy)
        if let screen = window.screen ?? NSScreen.main {
            let vf = screen.visibleFrame
            newOrigin.x = max(vf.minX, min(newOrigin.x, vf.maxX - window.frame.width))
            newOrigin.y = max(vf.minY, min(newOrigin.y, vf.maxY - window.frame.height))
        }
        window.setFrameOrigin(newOrigin)
        PetState.shared.position = newOrigin
        
        // Petting detection: small gentle strokes back and forth
        let strokeSpeed = hypot(dx, dy)
        let now = Date().timeIntervalSince1970
        if strokeSpeed < 60.0 && now - lastStrokeTime > 0.4 {
            petStrokeCounter += 1
            lastStrokeTime = now
            if petStrokeCounter >= 3 {
                petStrokeCounter = 0
                PetState.shared.pet()
                SoundManager.shared.play(.purr)
                if let petWin = window as? PetWindow {
                    petWin.showFloatingEffect("fx_heart.png")
                }
            }
        }
    }
    
    public func handleMouseUp(with event: NSEvent, window: NSWindow) {
        if isDragging {
            isDragging = false
            BehaviourEngine.shared.transitionTo(.stretching)
            PetState.shared.pet()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if BehaviourEngine.shared.currentBehaviour == .stretching {
                    BehaviourEngine.shared.transitionTo(.idle)
                }
            }
        }
    }
}
