protocol RunLoopInterface {
    func add(_ timer: Timer, forMode mode: RunLoopMode)
}

extension RunLoop: RunLoopInterface {}
