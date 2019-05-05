# Waaatcher

[![Build Status](https://travis-ci.com/hechen/Waaatcher.svg?branch=master)](https://travis-ci.com/hechen/Waaatcher)  ![Cocoapods](https://img.shields.io/cocoapods/v/Waaatcher.svg)   ![Cocoapods platforms](https://img.shields.io/cocoapods/p/Waaatcher.svg)   ![Swift Version](https://img.shields.io/badge/Swift-4.2-F16D39.svg?style=flat)

File Watcher Wrapper for macOS


### Demo
![Demo](.assets/Demo.png)


### FileSystemEvent

![FileSystemEvent API](.assets/FileSystemEventAPI.png)


### How to use

#### Start

``` Swift
let watcher = Waaatcher(paths: [path1, path2, path3])

// ...
watcher.watcherEventCallback = { events in
    print("Events: \(events)")
}

watcher.start()
```

#### Stop

``` Swift
watcher.stop()
// or watcher = nil
```


Each event is a structure which contains three parts as below

``` Swift
struct WaaaFSEvent {
    let path: String
    let flags: WaaaFSEventFlags
    let ID: FSEventStreamEventId
}
```

Also, `WaaaFSEventFlags` is defined as the wrapper of unreadable `FSEventStreamEventFlags`.


#### Reactive Extension

v1.0 extend Waaatcher with Reactive extension. Dead-simple API as below,
Not like the Waaatcher native callback with event array parameter, rx extension emit each single event.


``` Swift
fileprivate let bag = DisposeBag()
// ...
let watcher = Waaatcher(paths: [path])
watcher?.rx.FSEventObservable.subscribe(onNext: { [weak self] in
    self?.output("Event: \($0)")
}).disposed(by: bag)
```


### References

1. [Using the FSEventsFramework](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html)
2. [Apple FSEvents](http://nicoleibrahim.com/apple-fsevents-forensics/)
