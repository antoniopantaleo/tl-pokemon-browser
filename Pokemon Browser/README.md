# Pokemon Browser

<div align="center">
  <img width="30%" src="Pokemon Browser/Assets.xcassets/AppIcon.appiconset/Icon-1024.png" alt="app logo"/>
</div>

Here you can find the code of `Pokemon Browser`, a demo iOS application built with the `Pokespeare` SDK using SwiftUI.

## How to run it

The project is already linked with the SDK as it is loaded as a local Swift Package. You just need to open *Pokemon Browser.xcodeproj* to build and run the application.

## Brief description of the App architecture

### MVVM 

The app was built following the MVVM architecture. Specifically:
- The `ViewModel` is a platform-independent obcjet containing the business logic and the state that the View will update to accordingly,
- The `ContentView` listens for changes in the `ViewModel` to draw itself with the latest data.

The minimum iOS target is 17.0 because of the `@Observable` macro used for the `ViewModel`.

### Dependency Inversion
Although the only dependency is the `Pokespeare` SDK, a `PokemonBrowser` protocol was introduced to apply Dependency Inversion principle. `ViewModel` actually doesn't depend on the SDK (neither its tests), ensuring its core behavior to be encapaulated.
Changing the SDK won't break tests or how the ViewModel works.
The dependencies are composed at the root level of the Application.
Dependency inversion is useful with SwiftUI previews too, as different preview-only implementations can be created.

