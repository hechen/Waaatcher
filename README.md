# Waaatcher
File Watcher Wrapper for macOS


### Demo
![Demo](.assets/Demo.png)


### FileSystemEvent

![FileSystemEvent API](.assets/FileSystemEventAPI.png)


### How to use

#### Start

``` Swift
let watcher = Waaatcher(paths: [path])

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
struct FSEvent {
    let path: String
    let flags: FSEventFlags
    let ID: FSEventStreamEventId
}
```

Also, `FSEventFlags` is defined for wrap default unreadable `FSEventStreamEventFlags`.



### References

1. [Using the FSEventsFramework](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html)
2. [Apple FSEvents](http://nicoleibrahim.com/apple-fsevents-forensics/)
