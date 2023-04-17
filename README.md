# ACNetworkObserver

ACNetworkObserver is a wrapper for Apple's [NWPathMonitor] that providing monitor and react to network changes.

## Requirements
* iOS >=13, watchOS >=5
* Xcode 14 or above

## Installation
#### Swift Package Manager
To include ACNetworkObserver into a SPM package, add it to the `dependencies` attribute defined in your `Package.swift` file. You can select the version using the `version`  parameter. For example:
```ruby
dependencies: [
  .package(url: "https://github.com/AppCraftTeam/appcraft-network-observer-ios.git", from: <version>)
]
```
## Usage
### Demo
[ACNetworkObserverDemo](/Demo) - example of how to use "ACNetwokObserver" in your application.

### Simple usage
```swift
class Client: NSObject {
    let networkObserver: ACNetworkObserverInterface
    
    init(networkObserver: ACNetworkObserverInterface = ACNetworkObserver()) {
        self.networkObserver = networkObserver
        
        super.init()
         // A MultiCastDelegate is used as the standard notification method. 
        self.networkObserver.subscribe(self)
    }
    
    // Start listening for changes
    func run() {
        self.networkObserver.start()
    }
}

extension Client: ACNetworkMonitorListener {
    func networkMonitor(didChangeExpensiveStatus isExpansive: Bool) { }
    
    func networkMonitor(didChangeConnectionStatus isConnected: Bool) { }
    
    func networkMonitor(didChangeInterfaceType interfaceType: ACNetworkInterfaceType) { }
}
```

### Combine
```swift
class Client: NSObject {
    private var cancelations = Set<AnyCancellable>()
    private let networkObserver: ACNetworkObserverInterface

    init(networkObserver: ACNetworkObserverInterface = ACNetworkObserver()) {
        self.networkObserver = networkObserver
        
        super.init()
        // Attaches a subscriber with closure-based behavior to a publisher
        self.networkObserver
            .isConnectedPublisher
            .sink { [weak self] isConnected in
                // Do some
            }
            .store(in: &self.cancelations)
    }
    
    deinit {
        self.cancelations.cancelAll()
    }
    
    // Start listening for changes
    func run() {
        self.networkObserver.start()
    }
}
```
### Custom monitors
You can create a mock monitor object with the behavior you need.

**For example:**

[BadNetworkMonitor] - a monitor that switches the isConnected bool value every n-seconds.
```swift
class Client: NSObject {
    let networkObserver: ACNetworkObserverInterface
    
    init() {
        let monitor = BadNetworkMonitor(delayTimeInSeconds: 10)
        self.networkObserver = ACNetworkObserver(monitor: monitor)
        
        super.init()
    }
    
    // Start listening for changes
    func run() {
        self.networkObserver.start()
    }
}
```
## License
Distributed under the MIT License.

## Author
Damian Bazhenov | [Github][CreatorGithub]

[//]: # (Links)
   [CreatorGithub]: <https://github.com/uxn0w>
   [BadNetworkMonitor]: </Sources/ACNetworkObserver/Monitors/Variants/BadNetworkMonitor.swift>   
   [NWPathMonitor]: <https://developer.apple.com/documentation/network/nwpathmonitor>
