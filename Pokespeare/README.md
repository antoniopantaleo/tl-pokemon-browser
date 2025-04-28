# Pokespeare
<div align="center">
  <img width="30%" src="Sources/Pokespeare/Documentation.docc/Resources/sdk.png" alt="sdk-logo"/>
</div>

Here you can find the code of `Pokespeare`, the SDK developed for the challenge.
It has been [documented using DocC](Pokespeare.doccarchive).

The SDK is multi-platform; it can be used within iOS and MacOS projects.
The macOS destination allowed faster unit tests without the need for a simulator.
> The SDK was built using [Swift 6.1](Package.swift), but a [Swift 6.0](Package@swift-6.0.swift) compatible version was added in order to support Github Actions

## Dependencies used

No third-party dependencies were used to build the SDK. 
The minimum iOS requirement is set to iOS 16.0, and the minimum macOS requirement to macOS 13, because of the [appending](https://developer.apple.com/documentation/foundation/url/appending(components:directoryhint:)) URL API.

`Pokespeare` uses Swift 6 structured concurrency, which involves `async/await`, `MainActor`, `Sendable`, and `Task`.

## How to integrate the SDK into an existing project (Services and UI Component(s))

`Pokespeare` has been built as a Swift Package. Clients can integrate the SDK as a local package by simply dragging and dropping it into their XCode projects, and adding the dependency to their desired target by going into the *General* tab from project settings, then scrolling down to the *Frameworks, Libraries and Embedded Content* section (this is the approach I followed in the [Pokemon Browser](https://github.com/antoniopantaleo/tl-pokemon-browser/tree/develop/Pokemon%20Browser) demo project).

The SDK has built-in components to perform main tasks such as [retrieving Pokemon descriptions](https://github.com/antoniopantaleo/tl-pokemon-browser/blob/develop/Pokespeare/Sources/Pokespeare/Public/PokemonDescriptor.swift), [retrieving Pokemon sprites](https://github.com/antoniopantaleo/tl-pokemon-browser/blob/develop/Pokespeare/Sources/Pokespeare/Public/PokemonSpriteLoader.swift), and [displaying Pokemon images](https://github.com/antoniopantaleo/tl-pokemon-browser/blob/develop/Pokespeare/Sources/Pokespeare/Public/PokemonView.swift) using SwiftUI, but it can be easily extended through exposed protocols and `View` manipulation.

## Brief description of the SDK architecture

### Services

Both description and sprite services are defined as protocols. This gives clients the ability to create their own implementations (e.g. use different APIs to retrieve sprite data, or read Pokemon descriptions from a DB), in addition to giving them the possibility to create stubs for their tests, without depending on concrete implementations.
A similar approach was used within the SDK with the `HTTPClient` protocol:

### Network μlayer

The default services implementations download information from different APIs, so they need some sort of network capability. An abstraction layer over the HTTP request mechanism was used, so that default services implementation doesn't have to depend on concrete networking technology (e.g. Alamofire, URLSession, or more).

When testing the built-in URLSessionHTTPClient, a custom URLProtocol type was used, to mock real HTTP requests and perform tests without hitting the network.

### UI Component

The built-in `PokemonView` is a SwiftUI View that accepts a Pokemon description and a SwiftUI image representing the sprite.
