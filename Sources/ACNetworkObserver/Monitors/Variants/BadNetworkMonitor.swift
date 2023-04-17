//
//  BadNetworkMonitor.swift
//  ACNetworkObserver
//
//  Created by Damian on 14.04.2023.
//

import Foundation

public final class BadNetworkMonitor: ACNetworkMonitor {
 
    private var timer: Timer?
    private var isRunning = false
    private var _isConnected = true
    private let delayTimeInSeconds: TimeInterval
    
    public var isExpensive: Bool { false }
    public var isConnected: Bool { _isConnected }
    public var interfaceType: ACNetworkInterfaceType { .other }
    
    private weak var delegate: ACNetworkMonitorListener?
    private let queue = DispatchQueue(label: "bad.network.monitor", qos: .utility, attributes: .concurrent)
    
    public init(delayTimeInSeconds: TimeInterval = 10) {
        self.delayTimeInSeconds = delayTimeInSeconds
    }
    
    public func start() {
        self.queue.async(execute: {
            self.isRunning = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { [weak self] timer in
                guard let self else { return }
                if !self.isRunning {
                    timer.invalidate()
                }
                self._isConnected.toggle()
                self.delegate?.networkMonitor(didChangeConnectionStatus: self._isConnected)
            })
            
            if let timer = self.timer {
                RunLoop.current.add(timer, forMode: .common)
            }
        })
    }
    
    public func stop() {
        self.queue.async(execute: {
            self.isRunning = false
        })
    }
    
    public func subscribe(_ listener: ACNetworkMonitorListener) {
        self.delegate = listener
    }
    
    public func unsubscribe(_ listener: ACNetworkMonitorListener) { }
}
