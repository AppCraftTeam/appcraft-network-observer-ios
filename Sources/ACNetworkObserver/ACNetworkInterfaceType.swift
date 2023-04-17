//
//  ACNetworkInterfaceType.swift
//  ACNetworkObserver
//
//  Created by Damian on 14.04.2023.
//  Copyright © 2023 AppCraft. All rights reserved.

import Network
import Foundation

public enum ACNetworkInterfaceType: CustomStringConvertible {
    
    case wifi, cellular, other, undefined
    
    init(interface: NWInterface.InterfaceType?) {
        switch interface {
        case .wifi:
             self = .wifi
        case .cellular:
            self = .cellular
        case .none:
            self = .undefined
        default:
            self = .other
        }
    }
    
    public var description: String {
        switch self {
        case .wifi:
            return "wifi"
        case .cellular:
            return "cellular"
        case .other:
            return "other"
        case .undefined:
            return "undefined"
        }
    }
}
