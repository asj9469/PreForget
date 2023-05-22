//
//  EventMonitor.swift
//  PreForget
//
//  Created by Anson Goo on 4/19/23.
//

import Cocoa

import Cocoa

class EventMonitor {
    enum MonitorType {
        case global
        case local
    }
    
    typealias GlobalEventHandler = (NSEvent?) -> Void
    typealias LocalEventHandler = (NSEvent?) -> NSEvent?

    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let monitorType: MonitorType
    private let globalHandler: GlobalEventHandler?
    private let localHandler: LocalEventHandler?

    init(monitorType: MonitorType, mask: NSEvent.EventTypeMask, globalHandler: GlobalEventHandler?, localHandler: LocalEventHandler?) {
        self.mask = mask
        self.monitorType = monitorType
        self.globalHandler = globalHandler
        self.localHandler = localHandler
    }

    deinit {
        stop()
    }

    func start() {
        switch monitorType {
        case .global:
            startGlobalMonitor()
        case .local:
            startLocalMonitor()
        }
    }

    func stop() {
        guard let monitor = self.monitor else { return }

        NSEvent.removeMonitor(monitor)
        self.monitor = nil
    }

    public func startGlobalMonitor() {
        guard let handler = globalHandler else {
            assertionFailure("Global event handler is not set.")
            return
        }
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    public func startLocalMonitor() {
        guard let handler = localHandler else {
            assertionFailure("Local event handler is not set.")
            return
        }
        monitor = NSEvent.addLocalMonitorForEvents(matching: mask, handler: handler)
    }
}
