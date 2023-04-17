//
//  ACNetworkObserver.swift
//  ACNetworkObserver
//
//  Created by Damian on 14.04.2023.
//  Copyright © 2023 AppCraft. All rights reserved.

import Combine
import Foundation

/// API represented access to reactive properties
public protocol ACRXNetworkObservable {
    
    /// isExansive publisher
    var isExansivePublisher: AnyPublisher<Bool, Never> { get }
    
    /// isConnected publisher
    var isConntectedPublisher: AnyPublisher<Bool, Never> { get }
    
    /// interfaceType publisher
    var interfaceTypePublisher: AnyPublisher<ACNetworkInterfaceType, Never> { get }
}

public protocol ACNetworkObserverInterface: AnyObject, ACNetworkMonitor, ACRXNetworkObservable { }

/// An observer that you use to monitor and react to network changes.
open class ACNetworkObserver: NSObject, ACNetworkObserverInterface {

    private let monitor: ACNetworkMonitor
    
    private var outputQueue = DispatchQueue.main

    public var isConnected: Bool { monitor.isConnected }
    public var isExpensive: Bool { monitor.isExpensive }
    public var interfaceType: ACNetworkInterfaceType { monitor.interfaceType }

    private let _isExansiveSubject = PassthroughSubject<Bool, Never>()
    private let _isConnectedSubject = PassthroughSubject<Bool, Never>()
    private let _interfaceTypeSubject = PassthroughSubject<ACNetworkInterfaceType, Never>()
    
    public var isExansivePublisher: AnyPublisher<Bool, Never> {
        self._isExansiveSubject.receive(on: outputQueue).eraseToAnyPublisher()
    }
    
    public var isConntectedPublisher: AnyPublisher<Bool, Never> {
        self._isConnectedSubject.receive(on: outputQueue).eraseToAnyPublisher()
    }
    
    public var interfaceTypePublisher: AnyPublisher<ACNetworkInterfaceType, Never> {
        self._interfaceTypeSubject.receive(on: outputQueue).eraseToAnyPublisher()
    }
    
    private lazy var listeners = NetworkMonitorListenerGroup(outputQueue: outputQueue)
    
    public init(
        monitor: ACNetworkMonitor = NWNetworkMonitor(),
        outputQueue: DispatchQueue = DispatchQueue.main
    ) {
        self.monitor = monitor
        self.outputQueue = outputQueue
        
        super.init()
        self.monitor.subscribe(self)
    }
    
    open func start() {
        self.monitor.start()
    }
    
    open func stop() {
        self.monitor.stop()
    }
    
    open func subscribe(_ listener: ACNetworkMonitorListener) {
        self.listeners.add(listener)
    }
    
    open func unsubscribe(_ listener: ACNetworkMonitorListener) {
        self.listeners.remove(listener)
    }
}

// MARK: - NetworkMonitorListener Proxy
extension ACNetworkObserver: ACNetworkMonitorListener {
    
    public func networkMonitor(didChangeExpensiveStatus isExpensive: Bool) {
        self._isExansiveSubject.send(isExpensive)
        self.listeners.networkMonitor(didChangeExpensiveStatus: isExpensive)
    }
    
    public func networkMonitor(didChangeConnectionStatus isConnected: Bool) {
        self._isConnectedSubject.send(isConnected)
        self.listeners.networkMonitor(didChangeConnectionStatus: isConnected)
    }
    
    public func networkMonitor(didChangeInterfaceType interfaceType: ACNetworkInterfaceType) {
        self._interfaceTypeSubject.send(interfaceType)
        self.listeners.networkMonitor(didChangeInterfaceType: interfaceType)
    }
}
