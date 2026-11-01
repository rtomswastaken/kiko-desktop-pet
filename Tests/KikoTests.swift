// Tests/KikoTests.swift
import XCTest
@testable import Kiko

final class KikoTests: XCTestCase {
    
    func testPersonalityClamping() {
        let p = Personality(name: "Test", hyperactivity: 1.5, curiosity: -0.2, cuddliness: 0.5)
        XCTAssertEqual(p.hyperactivity, 1.0)
        XCTAssertEqual(p.curiosity, 0.0)
        XCTAssertEqual(p.cuddliness, 0.5)
    }
    
    @MainActor
    func testPetStateEnergyAndMood() {
        let state = PetState()
        state.energy = 0.10
        state.drainEnergy(amount: 0.05)
        XCTAssertEqual(state.currentMood, .sleepy)
        
        state.pet()
        XCTAssertGreaterThan(state.affection, 0.70)
    }
    
    func testSpriteAnimationAdvance() {
        let anim = SpriteAnimation(initialState: .walk)
        XCTAssertEqual(anim.currentFrameIndex, 0)
        
        // Advance past frame duration (0.14s)
        let changed = anim.update(deltaTime: 0.15)
        XCTAssertTrue(changed)
        XCTAssertEqual(anim.currentFrameIndex, 1)
        
        // Loop back to 0
        let changedAgain = anim.update(deltaTime: 0.15)
        XCTAssertTrue(changedAgain)
        XCTAssertEqual(anim.currentFrameIndex, 0)
    }
    
    func testActionPlannerCriticalSleep() {
        let next = ActionPlanner.nextBehaviour(
            current: .sitting,
            energy: 0.10,
            boredom: 0.90,
            personality: .standard
        )
        XCTAssertEqual(next, .sleeping)
    }
    
    func testCursorFollowerStepping() {
        let start = CGPoint(x: 100, y: 100)
        let target = CGPoint(x: 200, y: 100)
        let (nextPos, facingLeft) = CursorFollower.stepTowardsCursor(
            currentPos: start,
            cursorPos: target,
            speed: 50.0,
            deltaTime: 1.0
        )
        
        XCTAssertEqual(nextPos.x, 150.0, accuracy: 0.01)
        XCTAssertEqual(nextPos.y, 100.0, accuracy: 0.01)
        XCTAssertFalse(facingLeft) // Moving right
    }
}
