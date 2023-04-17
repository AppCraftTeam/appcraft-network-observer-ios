//
//  NetworkMonitorListenerGroup.swift
//  ACNetworkObserver
//
//  Created by Damian on 14.04.2023.
//  Copyright © 2023 AppCraft. All rights reserved.

import Foundation

final class NetworkMonitorListenerGroup: ListenerGroup<ACNetworkMonitorListener>, ACNetworkMonitorListener {
    func networkMonitor(didChangeExpensiveStatus isExpensive: Bool) {
        super.invoke({ $0.networkMonitor(didChangeExpensiveStatus: isExpensive) })
    }
    
    func networkMonitor(didChangeConnectionStatus isConnected: Bool) {
        super.invoke({ $0.networkMonitor(didChangeConnectionStatus: isConnected) })
    }
    
    func networkMonitor(didChangeInterfaceType interfaceType: ACNetworkInterfaceType) {
        super.invoke({ $0.networkMonitor(didChangeInterfaceType: interfaceType )})
    }
}
