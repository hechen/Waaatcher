# Waaatcher
File Watcher Wrapper for macOS


### Demo
![Demo](.assets/Demo.png)


### FileSystemEvent

![FileSystemEvent API](.assets/FileSystemEventAPI.png)


### How to use

``` Swift
watcher = Waaatcher(paths: [path])
watcher.watcherEventCallback = { events in
    print("Events: \(events)")
}
watcher.start()
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

[Using the FSEventsFramework](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html)
[Apple FSEvents](http://nicoleibrahim.com/apple-fsevents-forensics/)
