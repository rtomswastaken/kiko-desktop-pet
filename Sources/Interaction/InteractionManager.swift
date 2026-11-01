// Sources/Interaction/InteractionManager.swift
import AppKit

@MainActor
public final class InteractionManager {
    public static let shared = InteractionManager()
    
    public private(set) var isDragging: Bool = false
    private var dragStartMouseLocation: NSPoint = .zero
    private var dragStartWindowOrigin: NSPoint = .zero
    
    private init() {}
    
    public func handleMouseDown(with event: NSEvent, window: NSWindow) {
        isDragging = true
        dragStartMouseLocation = NSEvent.mouseLocation
        dragStartWindowOrigin = window.frame.origin
        BehaviourEngine.shared.transitionTo(.dragged)
    }
    
    public func handleMouseDragged(with event: NSEvent, window: NSWindow) {
        guard isDragging else { return }
        let currentMouse = NSEvent.mouseLocation
        let dx = currentMouse.x - dragStartMouseLocation.x
        let dy = currentMouse.y - dragStartMouseLocation.y
        
        var newOrigin = NSPoint(x: dragStartWindowOrigin.x + dx, y: dragStartWindowOrigin.y + dy)
        if let screen = window.screen {
            let visibleFrame = screen.visibleFrame
            newOrigin.x = max(visibleFrame.minX, min(newOrigin.x, visibleFrame.maxX - window.frame.width))
            newOrigin.y = max(visibleFrame.minY, min(newOrigin.y, visibleFrame.maxY - window.frame.height))
        }
        window.setFrameOrigin(newOrigin)
    }
    
    public func handleMouseUp(with event: NSEvent, window: NSWindow) {
        if isDragging {
            isDragging = false
            BehaviourEngine.shared.transitionTo(.sitting)
            PetState.shared.pet()
        }
    }
}
