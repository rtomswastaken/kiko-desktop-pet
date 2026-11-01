// Sources/Animation/SpriteAnimation.swift
import Foundation

public final class SpriteAnimation {
    public private(set) var currentState: AnimationState = .idle
    public private(set) var currentFrameIndex: Int = 0
    private var elapsedTime: TimeInterval = 0.0
    private var isReversingPingPong: Bool = false
    
    public init(initialState: AnimationState = .idle) {
        self.currentState = initialState
    }
    
    public func setState(_ newState: AnimationState) {
        guard newState != currentState else { return }
        currentState = newState
        currentFrameIndex = 0
        elapsedTime = 0.0
        isReversingPingPong = false
    }
    
    public func update(deltaTime: TimeInterval) -> Bool {
        elapsedTime += deltaTime
        let duration = currentState.frameDuration
        
        if elapsedTime >= duration {
            elapsedTime -= duration
            advanceFrame()
            return true // Frame changed
        }
        return false
    }
    
    private func advanceFrame() {
        let total = currentState.frameCount
        guard total > 1 else { return }
        
        if currentState.isPingPong {
            if isReversingPingPong {
                if currentFrameIndex > 0 {
                    currentFrameIndex -= 1
                } else {
                    isReversingPingPong = false
                    currentFrameIndex = 1
                }
            } else {
                if currentFrameIndex < total - 1 {
                    currentFrameIndex += 1
                } else {
                    isReversingPingPong = true
                    currentFrameIndex = total - 2
                }
            }
        } else {
            currentFrameIndex = (currentFrameIndex + 1) % total
        }
    }
}
