//
//  RepeatingTimer.swift
//  Gradgap
//
//  Created by iMac on 10/16/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation


class RepeatingGlobalTimer: NSObject {
    
    let sharedTimer: RepeatingGlobalTimer = RepeatingGlobalTimer()
    var internalTimer: Timer?
    var counter = 0
    
    
    func startTimer() {
        guard self.internalTimer != nil else {
            fatalError("Timer already intialized, how did we get here with a singleton?!")
        }
        self.internalTimer = Timer.scheduledTimer(timeInterval: 1.0 /*seconds*/, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        guard self.internalTimer != nil else {
            fatalError("No timer active, start the timer before you stop it.")
        }
        self.internalTimer?.invalidate()
    }

    @objc func fireTimerAction() {
        counter = +1
        print("--------***\(counter)***-------")
        
    }

    
    
    
    
    
//    let timeInterval: TimeInterval
//
//    init(timeInterval: TimeInterval) {
//        self.timeInterval = timeInterval
//    }
//
//    private lazy var timer: DispatchSourceTimer = {
//        let t = DispatchSource.makeTimerSource()
//        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
//        t.setEventHandler(handler: { [weak self] in
//            self?.eventHandler?()
//        })
//        return t
//    }()
//
//    var eventHandler: (() -> Void)?
//
//    private enum State {
//        case suspended
//        case resumed
//    }
//
//    private var state : State = .suspended
//
//    deinit {
//        timer.setEventHandler {}
//        timer.cancel()
//        /*
//         If the timer is suspended, calling cancel without resuming
//         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
//         */
//        resume()
//        eventHandler = nil
//    }
//
//    func resume() {
//        if state == .resumed {
//            return
//        }
//        state = .resumed
//        timer.resume()
//    }
//
//    func suspend() {
//        if state == .suspended {
//            return
//        }
//        state = .suspended
//        timer.suspend()
//    }
    
    
}
