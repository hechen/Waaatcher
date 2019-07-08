//
//  FSEventFlags.swift
//  FSEventsDemo
//
//  Created by chen he on 2019/4/8.
//  Copyright © 2019 chen he. All rights reserved.
//

import Foundation
import CoreServices

/*
 *  alias of FSEventStreamEventFlags
 */
public struct WaaaEventFlags: OptionSet {
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public init(eventFlags: FSEventStreamEventFlags) {
        self.rawValue = Int(eventFlags)
    }
    
    /*
     * Your application must rescan not just the directory given in the
     * event, but all its children, recursively. This can happen if there
     * was a problem whereby events were coalesced hierarchically. For
     * example, an event in /Users/jsmith/Music and an event in
     * /Users/jsmith/Pictures might be coalesced into an event with this
     * flag set and path=/Users/jsmith. If this flag is set you may be
     * able to get an idea of whether the bottleneck happened in the
     * kernel (less likely) or in your client (more likely) by checking
     * for the presence of the informational flags
     * UserDropped or
     * KernelDropped.
     */
    public static let mustScanSubDirs = WaaaEventFlags(rawValue: kFSEventStreamEventFlagMustScanSubDirs)
    
    /*
     * The UserDropped or
     * KernelDropped flags may be set in addition
     * to the MustScanSubDirs flag to indicate
     * that a problem occurred in buffering the events (the particular
     * flag set indicates where the problem occurred) and that the client
     * must do a full scan of any directories (and their subdirectories,
     * recursively) being monitored by this stream. If you asked to
     * monitor multiple paths with this stream then you will be notified
     * about all of them. Your code need only check for the
     * MustScanSubDirs flag; these flags (if
     * present) only provide information to help you diagnose the problem.
     */
    public static let userDropped = WaaaEventFlags(rawValue: kFSEventStreamEventFlagUserDropped)
    public static let kernelDropped = WaaaEventFlags(rawValue: kFSEventStreamEventFlagKernelDropped)
    
    /*
     * If EventIdsWrapped is set, it means the
     * 64-bit event ID counter wrapped around. As a result,
     * previously-issued event ID's are no longer valid arguments for the
     * sinceWhen parameter of the FSEventStreamCreate...() functions.
     */
    public static let eventIdsWrapped = WaaaEventFlags(rawValue: kFSEventStreamEventFlagEventIdsWrapped)
    
    /*
     * Denotes a sentinel event sent to mark the end of the "historical"
     * events sent as a result of specifying a sinceWhen value in the
     * FSEventStreamCreate...() call that created this event stream. (It
     * will not be sent if kFSEventStreamEventIdSinceNow was passed for
     * sinceWhen.) After invoking the client's callback with all the
     * "historical" events that occurred before now, the client's
     * callback will be invoked with an event where the
     * HistoryDone flag is set. The client should
     * ignore the path supplied in this callback.
     */
    public static let historyDone = WaaaEventFlags(rawValue: kFSEventStreamEventFlagHistoryDone)
    
    /*
     * Denotes a special event sent when there is a change to one of the
     * directories along the path to one of the directories you asked to
     * watch. When this flag is set, the event ID is zero and the path
     * corresponds to one of the paths you asked to watch (specifically,
     * the one that changed). The path may no longer exist because it or
     * one of its parents was deleted or renamed. Events with this flag
     * set will only be sent if you passed the flag
     * kFSEventStreamCreateFlagWatchRoot to FSEventStreamCreate...() when
     * you created the stream.
     */
    public static let rootChanged = WaaaEventFlags(rawValue: kFSEventStreamEventFlagRootChanged)
    
    /*
     * Denotes a special event sent when a volume is mounted underneath
     * one of the paths being monitored. The path in the event is the
     * path to the newly-mounted volume. You will receive one of these
     * notifications for every volume mount event inside the kernel
     * (independent of DiskArbitration). Beware that a newly-mounted
     * volume could contain an arbitrarily large directory hierarchy.
     * Avoid pitfalls like triggering a recursive scan of a non-local
     * filesystem, which you can detect by checking for the absence of
     * the MNT_LOCAL flag in the f_flags returned by statfs(). Also be
     * aware of the MNT_DONTBROWSE flag that is set for volumes which
     * should not be displayed by user interface elements.
     */
    public static let mount = WaaaEventFlags(rawValue: kFSEventStreamEventFlagMount)
    
    /*
     * Denotes a special event sent when a volume is unmounted underneath
     * one of the paths being monitored. The path in the event is the
     * path to the directory from which the volume was unmounted. You
     * will receive one of these notifications for every volume unmount
     * event inside the kernel. This is not a substitute for the
     * notifications provided by the DiskArbitration framework; you only
     * get notified after the unmount has occurred. Beware that
     * unmounting a volume could uncover an arbitrarily large directory
     * hierarchy, although Mac OS X never does that.
     */
    public static let unmount = WaaaEventFlags(rawValue: kFSEventStreamEventFlagUnmount)
    
    /*
     * A file system object was created at the specific path supplied in this event.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemCreated = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemCreated)
    
    /*
     * A file system object was removed at the specific path supplied in this event.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemRemoved = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemRemoved)
    
    /*
     * A file system object at the specific path supplied in this event had its metadata modified.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemInodeMetaMod = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemInodeMetaMod)
    
    /*
     * A file system object was renamed at the specific path supplied in this event.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemRenamed = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemRenamed)
    
    /*
     * A file system object at the specific path supplied in this event had its data modified.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemModified = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemModified)
    
    /*
     * A file system object at the specific path supplied in this event had its FinderInfo data modified.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemFinderInfoMod = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemFinderInfoMod)
    
    /*
     * A file system object at the specific path supplied in this event had its ownership changed.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemChangeOwner = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemChangeOwner)
    
    /*
     * A file system object at the specific path supplied in this event had its extended attributes modified.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemXattrMod = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemXattrMod)
    
    /*
     * The file system object at the specific path supplied in this event is a regular file.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemIsFile = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemIsFile)
    
    /*
     * The file system object at the specific path supplied in this event is a directory.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemIsDir = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemIsDir)
    
    /*
     * The file system object at the specific path supplied in this event is a symbolic link.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.7, *)
    public static let itemIsSymlink = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemIsSymlink)
    
    /*
     * Indicates the event was triggered by the current process.
     * (This flag is only ever set if you specified the MarkSelf flag when creating the stream.)
     */
    @available(OSX 10.9, *)
    public static let ownEvent = WaaaEventFlags(rawValue: kFSEventStreamEventFlagOwnEvent)
    
    
    /*
     * Indicates the object at the specified path supplied in this event is a hard link.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.10, *)
    public static let itemIsHardlink = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemIsHardlink)
  
    /* Indicates the object at the specific path supplied in this event was the last hard link.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.10, *)
    public static let itemIsLastHardlink = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemIsLastHardlink)
    
    /*
     * The file system object at the specific path supplied in this event is a clone or was cloned.
     * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
     */
    @available(OSX 10.13, *)
    public static let itemCloned = WaaaEventFlags(rawValue: kFSEventStreamEventFlagItemCloned)
}

extension WaaaEventFlags: CustomStringConvertible {
    public var description: String {
        var flags: [String] = []
        if self.contains(.mustScanSubDirs) { flags.append("mustScanSubDirs") }
        if self.contains(.userDropped) { flags.append("userDropped") }
        if self.contains(.kernelDropped) { flags.append("kernelDropped") }
        if self.contains(.eventIdsWrapped) { flags.append("eventIdsWrapped") }
        if self.contains(.historyDone) { flags.append("historyDone") }
        if self.contains(.rootChanged) { flags.append("rootChanged") }
        if self.contains(.mount) { flags.append("mount") }
        if self.contains(.unmount) { flags.append("unmount") }
        if self.contains(.itemCreated) { flags.append("itemCreated") }
        if self.contains(.itemRemoved) { flags.append("itemRemoved") }
        
        if self.contains(.itemInodeMetaMod) { flags.append("itemInodeMetaMod") }
        if self.contains(.itemRenamed) { flags.append("itemRenamed") }
        if self.contains(.itemModified) { flags.append("itemModified") }
        if self.contains(.itemFinderInfoMod) { flags.append("itemFinderInfoMod") }
        if self.contains(.itemChangeOwner) { flags.append("itemChangeOwner") }
        
        if self.contains(.itemXattrMod) { flags.append("itemXattrMod") }
        if self.contains(.itemIsFile) { flags.append("itemIsFile") }
        if self.contains(.itemIsDir) { flags.append("itemIsDir") }
        if self.contains(.itemIsSymlink) { flags.append("itemIsSymlink") }
        
        if self.contains(.ownEvent) { flags.append("ownEvent") }
        

        if self.contains(.itemIsHardlink) { flags.append("itemIsHardlink") }
        if self.contains(.itemIsLastHardlink) { flags.append("itemIsLastHardlink") }
        if self.contains(.itemCloned) { flags.append("itemCloned") }
        
        return flags.joined(separator: ", ")
    }
}
