# Pokespeare

Here you can find the code of `Pokespeare`, the SDK I created for the challenge.
It has been documented with DocC, [here](Pokespeare.doccarchive)
The SDK is multi-platform, since it can be used within iOS and MacOS projects.
MacOS destination faster unit tests no need for simulator
Double version of Package

## Dependencies used

No third-party dependencies were involved. 
I setted minimum iOS requirement to iOS 16.0, and the minimum MacOS reqirement to MacOS 13, because I used the [appending](https://developer.apple.com/documentation/foundation/url/appending(components:directoryhint:)) URL API.

`Pokespeare` uses Swift 6 structured concurrency, which involves `async/await`, `MainActor`, `Sendable` and `Task`.

## How to integrate the SDK into an existing project (Services and UI Component(s))

`Pokespeare` has been built as a Swift Package. Clients can integrate the SDK as a local package simply by a drag-and-drop action into their XCode projects, and adding the dependency to their desired target by going into *General* tab from project settings, then scrolling down to the *Frameworks, Libraries and Embedded Content* section (this is the approach I followed in the [Pokemon Browser]() demo project).

The SDK has built-in components to perform main tasks such retrieving Pokemon description, retrieving Pokemon sprites and displaying Pokemon images using SwiftUI, but it can be easily extended through exposed protocols and `View` manipulation.

## Brief description of the SDK architecture

### Services

Both description and sprite services are defined as protocols. This gives clients the ability to create their own implementations (e.g. different API to retrieve sprite data, or reading Pokemon description from a DB), in addition to giving them the possibility to create stubs for their tests, without depending on concrete implementations.
A similar approach was used within the SDK with the `HTTPClient` protocol. The default services implementations download informations from different APIs, so they needed some sort of network capability. An abstraction layer over HTTP request mechanism was used, so that default services implementation don't have to depend on concrete networking technology (e.g. Alamofire, URLSession or more).

When testing the built-in URLSessionHTTPClient, a custom URLProtocol type was used, in order to mock real HTTP requests and perform tests without hitting the network.

### UI Component

The built-in `PokemonView` is a SwiftUI View that accepts a Pokemon description and a SwiftUI image representing the sprite.
