//
//  NWNetworkMonitor.swift
//  ACNetworkObserver
//
//  Created by Damian on 14.04.2023.
//

import Network
import Foundation

public final class NWNetworkMonitor: ACNetworkMonitor {
    
    private let monitor: NWPathMonitor
    private let workQueue: DispatchQueue
    private weak var delegate: ACNetworkMonitorListener?
    
    var _isConnected: Bool? {
        didSet {
            guard oldValue != _isConnected else { return }
            self.delegate?.networkMonitor(didChangeConnectionStatus: _isConnected ?? false)
        }
    }
    
    var _isExpensive: Bool? {
        didSet {
            guard oldValue != _isExpensive else { return }
            self.delegate?.networkMonitor(didChangeExpensiveStatus: _isExpensive ?? false)
        }
    }
    
    var _interfaceType: ACNetworkInterfaceType = .undefined {
        didSet {
            guard oldValue != _interfaceType else { return }
            self.delegate?.networkMonitor(didChangeInterfaceType: _interfaceType)
        }
    }
    
    public var isConnected: Bool { _isConnected ?? false }
    public var isExpensive: Bool { _isExpensive ?? false }
    public var interfaceType: ACNetworkInterfaceType { _interfaceType }
    
    public init(workQueue: DispatchQueue = DispatchQueue(label: "network.monitor.queue")) {
        self.monitor = NWPathMonitor()
        self.workQueue = workQueue
    }
    
    public func start() {
        self.monitor.pathUpdateHandler = handlePath(_:)
        self.monitor.start(queue: workQueue)
    }
    
    public func stop() {
        self.monitor.cancel()
        self.monitor.pathUpdateHandler = nil
    }
    
    public func subscribe(_ delegate: ACNetworkMonitorListener) {
        self.delegate = delegate
    }
    
    public func unsubscribe(_ listener: ACNetworkMonitorListener) {
        self.delegate = nil
    }
    
    private func handlePath(_ path: NWPath) {
        self._isExpensive = path.isExpensive
        self._isConnected = path.status != .unsatisfied
        self._interfaceType = ACNetworkInterfaceType(
            interface: NWInterface
                .InterfaceType
                .allCases
                .first(where: { path.usesInterfaceType($0) })
        )
    }
}

// MARK: - NWInterface.InterfaceType + CaseIterable
extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}
