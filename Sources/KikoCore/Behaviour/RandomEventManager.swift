// Sources/Behaviour/RandomEventManager.swift
import AppKit

@MainActor
public final class RandomEventManager {
    public static let shared = RandomEventManager()
    
    private var eventTimer: Timer?
    private var lastEventTime: TimeInterval = 0.0
    public var minCooldownSeconds: TimeInterval = 45.0
    
    private init() {}
    
    public func start() {
        eventTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.evaluateRandomEvent()
            }
        }
    }
    
    public func stop() {
        eventTimer?.invalidate()
        eventTimer = nil
    }
    
    public func evaluateRandomEvent() {
        guard Preferences.shared.randomEventsEnabled else { return }
        let now = Date().timeIntervalSince1970
        guard now - lastEventTime >= minCooldownSeconds else { return }
        
        // Don't interrupt dragging or active mini-games
        if InteractionManager.shared.isDragging || MiniGameManager.shared.isMiniGameActive {
            return
        }
        
        // Probability check (approx 35% chance every check)
        guard Double.random(in: 0...1) < 0.35 else { return }
        
        lastEventTime = now
        triggerRandomEvent()
    }
    
    public func triggerRandomEvent() {
        let events: [() -> Void] = [
            { [weak self] in self?.triggerZoomiesEvent() },
            { [weak self] in self?.triggerBoxObsessionEvent() },
            { [weak self] in self?.triggerWindowWatchingEvent() },
            { [weak self] in self?.triggerDramaticFlopEvent() },
            { [weak self] in self?.triggerTailChasingEvent() },
            { [weak self] in self?.triggerStretchBreakEvent() },
            { [weak self] in self?.triggerRandomMeowEvent() }
        ]
        
        if let pick = events.randomElement() {
            pick()
        }
    }
    
    private func triggerZoomiesEvent() {
        BehaviourEngine.shared.triggerZoomies()
    }
    
    private func triggerBoxObsessionEvent() {
        if let boxPos = BoxInteractionController.shared.boxPosition {
            PetState.shared.position = boxPos
            PetState.shared.isInBox = true
            BehaviourEngine.shared.transitionTo(.boxIdle)
        }
    }
    
    private func triggerWindowWatchingEvent() {
        if Preferences.shared.windowInteractionsEnabled {
            let windows = WindowDetector.shared.getVisibleAppWindows()
            if let targetWin = windows.randomElement() {
                PetState.shared.position = CGPoint(x: targetWin.bounds.midX, y: targetWin.topEdgeY)
                PetState.shared.isPerchedOnWindow = true
                BehaviourEngine.shared.transitionTo(.windowWatching)
            }
        }
    }
    
    private func triggerDramaticFlopEvent() {
        PetState.shared.currentMood = .sleepy
        BehaviourEngine.shared.transitionTo(.sleeping)
    }
    
    private func triggerTailChasingEvent() {
        // Rapid flip facing direction
        var flips = 0
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            MainActor.assumeIsolated {
                PetState.shared.isFacingLeft.toggle()
                flips += 1
                if flips >= 6 {
                    timer.invalidate()
                    BehaviourEngine.shared.transitionTo(.curious)
                }
            }
        }
    }
    
    private func triggerStretchBreakEvent() {
        BehaviourEngine.shared.transitionTo(.stretching)
    }
    
    private func triggerRandomMeowEvent() {
        SoundManager.shared.play(.meow)
    }
}
