protocol RunLoopInterface {
    func add(_ timer: Timer, forMode mode: RunLoop.Mode)
}

extension RunLoop: RunLoopInterface {}
