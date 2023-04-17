//
//  ACNetworkMonitorListener.swift
//  ACNetworkObserver
//
//  Created by Damian on 14.04.2023.
//  Copyright © 2023 AppCraft. All rights reserved.

import Foundation

public protocol ACNetworkMonitorListener: AnyObject {
    func networkMonitor(didChangeExpensiveStatus isExpensive: Bool)
    func networkMonitor(didChangeConnectionStatus isConnected: Bool)
    func networkMonitor(didChangeInterfaceType interfaceType: ACNetworkInterfaceType)
}
