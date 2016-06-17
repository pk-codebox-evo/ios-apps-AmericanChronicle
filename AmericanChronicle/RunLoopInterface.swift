protocol RunLoopInterface {
    func addTimer(timer: NSTimer, forMode mode: String)
}

extension NSRunLoop: RunLoopInterface {}
