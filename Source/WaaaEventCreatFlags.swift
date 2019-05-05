//
//  EventCreateFlags.swift
//  Pods-WaaatcherDemo
//
//  Created by chen he on 2019/4/9.
//

import Foundation
import CoreServices

/*
 *  Readable FSEventStreamCreateFlags
 *
 *  Discussion:
 *    Flags that can be passed to the FSEventStreamCreate...()
 *    functions to modify the behavior of the stream being created.
 */
public struct WaaaEventCreatFlags: OptionSet {
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public init(eventFlags: FSEventStreamCreateFlags) {
        self.rawValue = Int(eventFlags)
    }

    /*
     * The default.
     */
    public static let none = WaaaEventCreatFlags(rawValue: kFSEventStreamCreateFlagNone)
    
    /*
     * The framework will invoke your callback function with CF types
     * rather than raw C types (i.e., a CFArrayRef of CFStringRefs,
     * rather than a raw C array of raw C string pointers). See
     * FSEventStreamCallback.
     */
    public static let useCFTypes = WaaaEventCreatFlags(rawValue: kFSEventStreamCreateFlagUseCFTypes)
    
    /*
     * Affects the meaning of the latency parameter. If you specify this
     * flag and more than latency seconds have elapsed since the last
     * event, your app will receive the event immediately. The delivery
     * of the event resets the latency timer and any further events will
     * be delivered after latency seconds have elapsed. This flag is
     * useful for apps that are interactive and want to react immediately
     * to changes but avoid getting swamped by notifications when changes
     * are occurringin rapid succession. If you do not specify this flag,
     * then when an event occurs after a period of no events, the latency
     * timer is started. Any events that occur during the next latency
     * seconds will be delivered as one group (including that first
     * event). The delivery of the group of events resets the latency
     * timer and any further events will be delivered after latency
     * seconds. This is the default behavior and is more appropriate for
     * background, daemon or batch processing apps.
     */
    public static let noDefer = WaaaEventCreatFlags(rawValue: kFSEventStreamCreateFlagNoDefer)
    
    /*
     * Request notifications of changes along the path to the path(s)
     * you're watching. For example, with this flag, if you watch
     * "/foo/bar" and it is renamed to "/foo/bar.old", you would receive
     * a RootChanged event. The same is true if the directory "/foo" were
     * renamed. The event you receive is a special event: the path for
     * the event is the original path you specified, the flag
     * kFSEventStreamEventFlagRootChanged is set and event ID is zero.
     * RootChanged events are useful to indicate that you should rescan a
     * particular hierarchy because it changed completely (as opposed to
     * the things inside of it changing). If you want to track the
     * current location of a directory, it is best to open the directory
     * before creating the stream so that you have a file descriptor for
     * it and can issue an F_GETPATH fcntl() to find the current path.
     */
    public static let watchRoot = WaaaEventCreatFlags(rawValue: kFSEventStreamCreateFlagWatchRoot)
    
    /*
     * Don't send events that were triggered by the current process. This
     * is useful for reducing the volume of events that are sent. It is
     * only useful if your process might modify the file system hierarchy
     * beneath the path(s) being monitored. Note: this has no effect on
     * historical events, i.e., those delivered before the HistoryDone
     * sentinel event.  Also, this does not apply to RootChanged events
     * because the WatchRoot feature uses a separate mechanism that is
     * unable to provide information about the responsible process.
     */
    @available(OSX 10.6, *)
    public static let ignoreSelf = WaaaEventCreatFlags(rawValue: kFSEventStreamCreateFlagIgnoreSelf)
    
    /*
     * Request file-level notifications.  Your stream will receive events
     * about individual files in the hierarchy you're watching instead of
     * only receiving directory level notifications.  Use this flag with
     * care as it will generate significantly more events than without it.
     */
    @available(OSX 10.7, *)
    public static let fileEvents = WaaaEventCreatFlags(rawValue: kFSEventStreamCreateFlagFileEvents)
    
    /*
     * Tag events that were triggered by the current process with the "OwnEvent" flag.
     * This is only useful if your process might modify the file system hierarchy
     * beneath the path(s) being monitored and you wish to know which events were
     * triggered by your process. Note: this has no effect on historical events, i.e.,
     * those delivered before the HistoryDone sentinel event.
     */
    @available(OSX 10.9, *)
    public static let markSelf = WaaaEventCreatFlags(rawValue: kFSEventStreamCreateFlagMarkSelf)
    
    /*
     * Requires kFSEventStreamCreateFlagUseCFTypes and instructs the
     * framework to invoke your callback function with CF types but,
     * instead of passing it a CFArrayRef of CFStringRefs, a CFArrayRef of
     * CFDictionaryRefs is passed.  Each dictionary will contain the event
     * path and possibly other "extended data" about the event.  See the
     * kFSEventStreamEventExtendedData*Key definitions for the set of keys
     * that may be set in the dictionary.  (See also FSEventStreamCallback.)
     */
    @available(OSX 10.13, *)
    public static let useExtendedData = WaaaEventCreatFlags(rawValue: kFSEventStreamCreateFlagUseExtendedData)
}



extension WaaaEventCreatFlags: CustomStringConvertible {
    public var description: String {
        var flags: [String] = []
        if self.contains(.none) { flags.append("none") }
        if self.contains(.useCFTypes) { flags.append("useCFTypes") }
        if self.contains(.noDefer) { flags.append("noDefer") }
        if self.contains(.watchRoot) { flags.append("watchRoot") }
        if self.contains(.ignoreSelf) { flags.append("ignoreSelf") }
        if self.contains(.fileEvents) { flags.append("fileEvents") }
        if self.contains(.markSelf) { flags.append("markSelf") }
        if self.contains(.useExtendedData) { flags.append("useExtendedData") }
        
        return flags.joined(separator: ", ")
    }
}
