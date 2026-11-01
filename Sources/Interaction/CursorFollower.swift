// Sources/Interaction/CursorFollower.swift
import Foundation

public struct CursorFollower: Sendable {
    public static func stepTowardsCursor(
        currentPos: CGPoint,
        cursorPos: CGPoint,
        speed: CGFloat,
        deltaTime: TimeInterval
    ) -> (newPos: CGPoint, facingLeft: Bool) {
        let dx = cursorPos.x - currentPos.x
        let dy = cursorPos.y - currentPos.y
        let distance = hypot(dx, dy)
        
        // Stop if within comfortable distance
        if distance < 50.0 {
            return (currentPos, dx < 0)
        }
        
        let step = min(distance, speed * CGFloat(deltaTime))
        let nx = currentPos.x + (dx / distance) * step
        let ny = currentPos.y + (dy / distance) * step
        
        return (CGPoint(x: nx, y: ny), dx < 0)
    }
}
