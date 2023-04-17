//
//  ACNetworkMonitor.swift
//  ACNetworkObserver
//
//  Created by Damian on 14.04.2023.
//

import Foundation

/// An observer that you use to monitor and react to network changes.
public protocol ACNetworkMonitor {
    
    /// A Boolean indicating whether the path uses an interface that is considered expensive, such as Cellular or a Personal Hotspot.
    var isExpensive: Bool { get }
    
    /// A boolean value indicated of connection status.
    var isConnected: Bool { get }
    
    /// Type of network interface
    var interfaceType: ACNetworkInterfaceType { get }

    func stop()
    func start()
    func subscribe(_ listener: ACNetworkMonitorListener)
    func unsubscribe(_ listener: ACNetworkMonitorListener)
}
