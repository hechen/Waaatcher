//
//  FSEvent.swift
//  FSEventsDemo
//
//  Created by chen he on 2019/4/8.
//  Copyright © 2019 chen he. All rights reserved.
//

import Foundation
import CoreServices

public struct FSEvent {
    let path: String
    let flags: FSEventFlags
    let ID: FSEventStreamEventId
}

extension FSEvent: CustomStringConvertible {
    public var description: String {
        return "File System Event: [\(path)], ID: \(ID), Flags: \(flags)"
    }
}
