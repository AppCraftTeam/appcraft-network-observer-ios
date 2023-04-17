//
//  ListenerGroup.swift
//  ACNetworkObserver
//
//  Created by Damian on 14.04.2023.
//  Copyright © 2023 AppCraft. All rights reserved.

import Foundation

open class ListenerGroup<T> {
    
    open var outputQueue: DispatchQueue
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    public init(outputQueue: DispatchQueue = .main) {
        self.outputQueue = outputQueue
    }
    
    open func add(_ delegate: T) {
        self.delegates.add(delegate as AnyObject)
    }
    
    open func remove(_ target: T) {
        for delegate in delegates.allObjects.reversed() where delegate === target as AnyObject {
            self.delegates.remove(delegate)
        }
    }
    
    open func removeAll() {
        self.delegates.removeAllObjects()
    }
    
    open func invoke(_ invocation: @escaping (T) -> Void) {
        for delegate in delegates.allObjects.reversed() {
            if let rec = delegate as? T {
                self.outputQueue.async { invocation(rec) }
            }
        }
    }
    
    open func invoke(_ invocation: @escaping (T) -> Void, queue: DispatchQueue) {
        for delegate in delegates.allObjects.reversed() {
            if let rec = delegate as? T {
                queue.async { invocation(rec) }
            }
        }
    }
}
