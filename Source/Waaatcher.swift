//
//  Waaatcher.swift
//  Pods-Waaatcher
//
//  Created by chen he on 2019/4/8.
//

import Foundation
import CoreFoundation
import CoreServices

public enum WaaatcherError: Error {
    case invalidPath(path: ValidWatchPath)
}

public protocol ValidWatchPath {
    func asWatchedPath() throws -> String
}

extension String: ValidWatchPath {
    public func asWatchedPath() throws -> String {
        if !FileManager.default.fileExists(atPath: self) {
            throw WaaatcherError.invalidPath(path: self)
        }
        return self
    }
}

extension URL: ValidWatchPath {
    public func asWatchedPath() throws -> String {
        return try self.path.asWatchedPath()
    }
}


public typealias WaaatcherEventCallback = ([FSEvent]) -> Void


/*
 Waaatcher is a wrapper of FSEventsSystem APIs
 */
public class Waaatcher {
    private var stream: FSEventStreamRef?
    
    /*
     Define variables and create a CFArray object containing
     CFString objects containing paths to watch.
     */
    private var pathsToWatch: [ValidWatchPath]
    
    private let latency: CFTimeInterval
    
    private let sinceWhen: FSEventStreamEventId
    
    private let eventFlags: FSEventStreamEventFlags
    
    private let scheduledRunloop: RunLoop
    
    private(set) var isWatching: Bool = false
    
    public var watcherEventCallback: WaaatcherEventCallback?
    
    deinit {
        stop()
    }

    public init(paths: [ValidWatchPath],
         latency: Double = 3.0,
         sinceWhen: FSEventStreamEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
         eventFlags: FSEventStreamEventFlags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents),
         scheduledRunloop: RunLoop = RunLoop.main) {
        
        self.pathsToWatch = paths
        self.latency = latency
        self.sinceWhen = sinceWhen
        self.eventFlags = eventFlags
        self.scheduledRunloop = scheduledRunloop
    }
    
    /*
     func FSEventStreamCreate(_ allocator: CFAllocator?,
     _ callback: @escaping FSEventStreamCallback,
     _ context: UnsafeMutablePointer<FSEventStreamContext>?,
     _ pathsToWatch: CFArray,
     _ sinceWhen: FSEventStreamEventId,
     _ latency: CFTimeInterval,
     _ flags: FSEventStreamCreateFlags) -> FSEventStreamRef?
     */
    public func start() -> Bool {
        
        /* Step 1   Create FSEventStream */
        
        
        /* 1.1 Prepare Context */
        var context = FSEventStreamContext(version: 0,
                                           info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
                                           retain: nil,
                                           release: nil,
                                           copyDescription: nil)
        
        
        /* 1.2 Prepare callback function */
        guard let stream = FSEventStreamCreate(nil, streamCallback, &context,
                                               pathsToWatch as CFArray,
                                               sinceWhen,
                                               latency,
                                               eventFlags) else {
                                                return false
        }
        
        
        /* Step 2  Schedules the stream on the run loop */
        FSEventStreamScheduleWithRunLoop(stream, scheduledRunloop.getCFRunLoop(), CFRunLoopMode.defaultMode.rawValue)
        
        /* Step 3  Tells the file system events daemon to start sending events */
        FSEventStreamStart(stream)
        
        isWatching = true
        
        return true
    }
    
    public func stop() {
        guard let stream = stream else { return }
        
        /* The application tells the daemon to stop sending events by calling FSEventStreamStop. */
        FSEventStreamStop(stream)
        
        /* The application unschedules the event from its run loop by calling FSEventStreamUnscheduleFromRunLoop. */
        FSEventStreamUnscheduleFromRunLoop(stream, scheduledRunloop.getCFRunLoop(), CFRunLoopMode.defaultMode.rawValue)
        
        /* The application invalidates the stream by calling FSEventStreamInvalidate. */
        FSEventStreamInvalidate(stream)
        
        /* The application releases its reference to the stream by calling FSEventStreamRelease. */
        FSEventStreamRelease(stream)
        self.stream = nil
        
        isWatching = false
    }
}

/*
 @convention(c) (OpaquePointer, Optional<UnsafeMutableRawPointer>, Int, UnsafeMutableRawPointer, UnsafePointer<UInt32>, UnsafePointer<UInt64>) -> ()
 
 The application services events as they arrive.
 The API posts events by calling the callback function specified in step 1.
 */
fileprivate func streamCallback(streamRef: OpaquePointer,
                                clientCallBackInfo: UnsafeMutableRawPointer?,
                                numEvents: Int,
                                eventPaths: UnsafeMutableRawPointer,
                                eventFlags: UnsafePointer<FSEventStreamEventFlags>,
                                eventIds: UnsafePointer<FSEventStreamEventId>) {
    
    guard numEvents > 0 else { return }
    
    guard let info = clientCallBackInfo else {
        return
    }
    let watcher = unsafeBitCast(info, to: Waaatcher.self)
    guard let eventPaths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] else {
        return
    }
    
    // Each event contain path, flag and Id
    var events = [FSEvent]()
    for i in 0..<numEvents {
        let path = eventPaths[i]
        let flags = FSEventFlags(eventFlags: eventFlags[i])
        let id = eventIds[i]
        events.append(FSEvent(path: path, flags: flags, ID: id))
    }
    watcher.watcherEventCallback?(events)
}
