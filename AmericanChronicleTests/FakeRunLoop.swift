@testable import AmericanChronicle

class FakeRunLoop: RunLoopInterface {
    var addTimer_wasCalled_withTimer: Timer?
    func add(_ timer: Timer, forMode mode: RunLoop.Mode) {
        addTimer_wasCalled_withTimer = timer
    }
}
