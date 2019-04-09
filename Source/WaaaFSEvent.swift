//
//  FSEvent.swift
//  FSEventsDemo
//
//  Created by chen he on 2019/4/8.
//  Copyright © 2019 chen he. All rights reserved.
//

import Foundation
import CoreServices

public struct WaaaFSEvent {
    let path: String
    let flags: WaaaEventFlags
    let ID: FSEventStreamEventId
}

extension WaaaFSEvent: CustomStringConvertible {
    public var description: String {
        return "File System Event: [\(path)], ID: \(ID), Flags: \(flags)"
    }
}
