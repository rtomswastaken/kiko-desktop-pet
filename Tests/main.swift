// Tests/main.swift
import Foundation
import CoreGraphics
import KikoCore

var passedCount = 0
var failedCount = 0

func assertEqual<T: Equatable>(_ a: T, _ b: T, _ message: String = "", file: String = #file, line: Int = #line) {
    if a == b {
        passedCount += 1
    } else {
        failedCount += 1
        print("❌ FAIL [\(line)]: \(a) != \(b) | \(message)")
    }
}

func assertTrue(_ condition: Bool, _ message: String = "", file: String = #file, line: Int = #line) {
    if condition {
        passedCount += 1
    } else {
        failedCount += 1
        print("❌ FAIL [\(line)]: condition is false | \(message)")
    }
}

func testPersonalityPresets() {
    print("Testing Personality presets & clamping...")
    let custom = Personality(name: "Test", playful: 1.5, lazy: -0.2, curious: 0.5)
    assertEqual(custom.playful, 1.0, "Playful clamped to 1.0")
    assertEqual(custom.lazy, 0.0, "Lazy clamped to 0.0")
    assertEqual(custom.curious, 0.5, "Curious preserved")
    
    // Presets
    assertTrue(Personality.kiko.energetic > 0.7, "Kiko is energetic")
    assertTrue(Personality.smokey.lazy > 0.8, "Smokey is lazy")
    assertTrue(Personality.kuro.mischievous > 0.9, "Kuro is mischievous")
    assertTrue(Personality.mochi.shy > 0.6, "Mochi is shy")
}

@MainActor
func testPetStateMeters() {
    print("Testing PetState meters and mood transitions...")
    let state = PetState()
    state.energy = 0.12
    state.drainEnergy(amount: 0.02)
    assertEqual(state.currentMood, .sleepy, "Low energy shifts mood to sleepy")
    
    state.restoreEnergy(amount: 0.60)
    assertEqual(state.currentMood, .relaxed, "Waking up restores relaxed mood")
    
    state.pet()
    assertTrue(state.affection > 0.70, "Petting raises affection")
    
    state.startle()
    assertEqual(state.currentMood, .scared, "Startle shifts mood to scared")
}

func testSpriteAnimationAdvance() {
    print("Testing SpriteAnimation frame advancement and ping-pong loop...")
    let anim = SpriteAnimation(initialState: .run)
    assertEqual(anim.currentFrameIndex, 0)
    
    // Advance past run frame duration (0.085s)
    let changed = anim.update(deltaTime: 0.10)
    assertTrue(changed, "Frame advanced")
    assertEqual(anim.currentFrameIndex, 1, "Moved to frame 1")
    
    // Run has 7 frames -> after advancing 6 more times, loops back to 0
    for _ in 0..<6 {
        _ = anim.update(deltaTime: 0.10)
    }
    assertEqual(anim.currentFrameIndex, 0, "Looped back to 0")
    
    // Sleep is ping-pong (3 frames: 0, 1, 2, 1, 0...)
    let sleepAnim = SpriteAnimation(initialState: .sleep)
    assertEqual(sleepAnim.currentFrameIndex, 0)
    _ = sleepAnim.update(deltaTime: 0.40)
    assertEqual(sleepAnim.currentFrameIndex, 1)
    _ = sleepAnim.update(deltaTime: 0.40)
    assertEqual(sleepAnim.currentFrameIndex, 2)
    _ = sleepAnim.update(deltaTime: 0.40)
    assertEqual(sleepAnim.currentFrameIndex, 1, "Ping-pong reversed from 2 to 1")
}

func testActionPlanner() {
    print("Testing ActionPlanner logic...")
    // Critical sleep
    let sleepNext = ActionPlanner.nextBehaviour(
        current: .idle,
        energy: 0.10,
        boredom: 0.90,
        inactivityDuration: 0,
        mood: .happy,
        personality: .standard
    )
    assertEqual(sleepNext, .sleeping, "Low energy triggers sleep")
    
    // Inactivity box trigger
    let boxNext = ActionPlanner.nextBehaviour(
        current: .idle,
        energy: 0.80,
        boredom: 0.90,
        inactivityDuration: 300.0, // 5 min idle
        mood: .relaxed,
        personality: .standard,
        nearBox: true
    )
    assertEqual(boxNext, .boxIdle, "Long inactivity near box retreats into box")
    
    // Scared retreat
    let scaredNext = ActionPlanner.nextBehaviour(
        current: .idle,
        energy: 0.80,
        boredom: 0.10,
        inactivityDuration: 0,
        mood: .scared,
        personality: .standard
    )
    assertEqual(scaredNext, .hiding, "Scared mood retreats to hiding")
}

func testCursorFollower() {
    print("Testing CursorFollower stepping...")
    let start = CGPoint(x: 100, y: 100)
    let target = CGPoint(x: 200, y: 100)
    let (nextPos, facingLeft) = CursorFollower.stepTowardsCursor(
        currentPos: start,
        cursorPos: target,
        speed: 50.0,
        deltaTime: 1.0
    )
    
    assertTrue(abs(nextPos.x - 150.0) < 0.01, "Stepped 50px towards target on X")
    assertTrue(abs(nextPos.y - 100.0) < 0.01, "Y position stayed 100")
    assertTrue(!facingLeft, "Moving right means facingLeft is false")
    
    // Close distance -> stops
    let closeTarget = CGPoint(x: 120, y: 100)
    let (stopPos, _) = CursorFollower.stepTowardsCursor(
        currentPos: start,
        cursorPos: closeTarget,
        speed: 50.0,
        deltaTime: 1.0
    )
    assertEqual(stopPos, start, "Within stop distance does not move")
}

func testAvatarsAndMoods() {
    print("Testing CatAvatar and Mood mappings...")
    assertEqual(CatAvatar.allCases.count, 13, "13 distinct avatars & costumes supported")
    assertEqual(CatAvatar.ginger.spritePrefix, "ginger")
    assertEqual(CatAvatar.blackCat.spritePrefix, "blackcat")
    assertEqual(CatAvatar.calico.spritePrefix, "calico")
    assertEqual(CatAvatar.whiteCat.spritePrefix, "whitecat")
    assertEqual(CatAvatar.astronaut.spritePrefix, "astronaut")
    assertEqual(CatAvatar.batman.spritePrefix, "batman")
    
    // Mood speed multipliers
    assertTrue(Mood.excited.movementSpeedMultiplier > 2.0, "Excited mood has high speed")
    assertTrue(Mood.sleepy.movementSpeedMultiplier < 0.7, "Sleepy mood has slow speed")
}

func testBehaviourTypes() {
    print("Testing BehaviourType animation bindings...")
    assertEqual(BehaviourType.idle.associatedAnimation, .idle)
    assertEqual(BehaviourType.walking.associatedAnimation, .run)
    assertEqual(BehaviourType.excited.associatedAnimation, .run)
    assertEqual(BehaviourType.jumping.associatedAnimation, .jump)
    assertEqual(BehaviourType.playful.associatedAnimation, .attack)
    assertEqual(BehaviourType.sleeping.associatedAnimation, .sleep)
    assertEqual(BehaviourType.dramaticFlop.associatedAnimation, .die)
    assertEqual(BehaviourType.hiding.associatedAnimation, .box_peeking)
    assertEqual(BehaviourType.boxIdle.associatedAnimation, .box_head_out)
}

func testWindowDetectionMath() {
    print("Testing Window detection bounds & topEdge...")
    let win = DetectedWindow(
        windowID: 101,
        appName: "Safari",
        bounds: NSRect(x: 100, y: 200, width: 800, height: 600)
    )
    assertEqual(win.topEdgeY, 800.0, "Top edge equals bounds.maxY (200 + 600)")
}

@MainActor
func runAllTests() {
    print("\n===============================")
    print("🐾 RUNNING KIKO DESKTOP PET TEST SUITE")
    print("===============================\n")
    
    testPersonalityPresets()
    testPetStateMeters()
    testSpriteAnimationAdvance()
    testActionPlanner()
    testCursorFollower()
    testAvatarsAndMoods()
    testBehaviourTypes()
    testWindowDetectionMath()
    
    print("\n===============================")
    print("Test Summary: \(passedCount) PASSED, \(failedCount) FAILED")
    print("===============================\n")
    
    if failedCount > 0 {
        exit(1)
    }
}

@main
struct TestRunner {
    @MainActor
    static func main() {
        runAllTests()
    }
}
