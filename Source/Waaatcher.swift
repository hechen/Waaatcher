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


public typealias WaaatcherEventCallback = ([WaaaFSEvent]) -> Void


/*
 Waaatcher is a wrapper of FSEventsSystem APIs
 */
public class Waaatcher {
    private var stream: FSEventStreamRef?
    
    /*
     Define variables and create a CFArray object containing
     CFString objects containing paths to watch.
     */
    public private(set) var pathsToWatch: [ValidWatchPath]
    
    public private(set) var latency: CFTimeInterval
    
    public private(set) var sinceWhen: FSEventStreamEventId
    
    public private(set) var eventCreateFlags: WaaaEventCreatFlags
    
    public private(set) var scheduledRunloop: RunLoop
    
    public private(set) var isWatching: Bool = false
    
    var watcherEventCallback: WaaatcherEventCallback?
    
    deinit {
        stop()
    }
    
    
    /// Initialize a Waaatcher Object
    ///
    /// - Parameters:
    ///   - paths: File paths to be watched
    ///   - latency: Event delay after occur
    ///   - sinceWhen: Events callback after which event. Default is sineNow.
    ///   - eventCreateFlags: FSEventStream create flags. Details at EventCreatFlags.swift
    ///   - scheduledRunloop: Which runloop FSEventStream will be scheduled on
    public init(paths: [ValidWatchPath],
                latency: Double = 3.0,
                sinceWhen: FSEventStreamEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
                eventCreateFlags: WaaaEventCreatFlags = [WaaaEventCreatFlags.useCFTypes, WaaaEventCreatFlags.fileEvents],
                scheduledRunloop: RunLoop = RunLoop.main,
                eventsCallback: WaaatcherEventCallback? = nil) {
        
        self.pathsToWatch = paths
        self.latency = latency
        self.sinceWhen = sinceWhen
        self.eventCreateFlags = eventCreateFlags
        self.scheduledRunloop = scheduledRunloop
        self.watcherEventCallback = eventsCallback
    }
    
    
    /// Start working.
    ///
    /// - Returns: start successfully or not
    /// - Throws: When waaatcher's paths check fails, invalid error will be thrown
    public func start() throws -> Bool {
        
        /* Step 1   Create FSEventStream */
        
        
        /* 1.1 Prepare Context */
        var context = FSEventStreamContext(version: 0,
                                           info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
                                           retain: nil,
                                           release: nil,
                                           copyDescription: nil)
        
        var validFilePaths = [String]()
        for path in pathsToWatch {
            do {
                let checkedPath = try path.asWatchedPath()
                validFilePaths.append(checkedPath)
            } catch {
                throw WaaatcherError.invalidPath(path: path)
            }
        }
        
        /* 1.2 Prepare callback function */
        /*
         The application services events as they arrive.
         The API posts events by calling the callback function specified in step 1.
         */
        let streamCallback: FSEventStreamCallback = { ( _ streamRef: ConstFSEventStreamRef, _ clientCallBackInfo: UnsafeMutableRawPointer?, _ numEvents: Int, _ eventPaths: UnsafeMutableRawPointer, _ eventFlags: UnsafePointer<FSEventStreamEventFlags>, _ eventIds: UnsafePointer<FSEventStreamEventId>) -> Void in
            
            guard numEvents > 0 else { return }
            
            guard let info = clientCallBackInfo else {
                return
            }
            
            let unmanagedPtr: Unmanaged<Waaatcher> = Unmanaged.fromOpaque(info)
            let watcher = unmanagedPtr.takeUnretainedValue()
            guard let eventPaths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] else {
                return
            }
            
            // Each event contain path, flag and Id
            var events = [WaaaFSEvent]()
            for i in 0..<numEvents {
                let path = eventPaths[i]
                let flags = WaaaEventFlags(eventFlags: eventFlags[i])
                let id = eventIds[i]
                events.append(WaaaFSEvent(path: path, flags: flags, ID: id))
            }
            watcher.watcherEventCallback?(events)
            
        }
        guard let stream = FSEventStreamCreate(nil, streamCallback, &context,
                                               pathsToWatch as CFArray,
                                               sinceWhen,
                                               latency,
                                               UInt32(eventCreateFlags.rawValue)) else {
                                                return false
        }
        
        self.stream = stream
        
        
        /* Step 2  Schedules the stream on the run loop */
        FSEventStreamScheduleWithRunLoop(stream, scheduledRunloop.getCFRunLoop(), CFRunLoopMode.defaultMode.rawValue)
        
        /* Step 3  Tells the file system events daemon to start sending events */
        FSEventStreamStart(stream)
        
        isWatching = true
        
        return true
    }
    
    public func stop() {
        guard isWatching else { return }
        
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
