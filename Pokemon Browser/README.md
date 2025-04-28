# Pokemon Browser

Here you can find the code of `Pokemon Browser`, a demo iOS application built with the `Pokespeare` SDK using SwiftUI.

## How to run it

The project is already linked with the SDK since it's loaded as a local Swift Package. You just need to open *Pokemon Browser.xcodeproj* to build and run the application.

## Brief description of the App architecture

### MVVM 

The app was built following the MVVM architecture. In particular:
- The `ViewModel` contains the business logic and the state that the View will update to accordingly,
- The `ContentView` listen for changes in the `ViewModel` to draw itself with the latest data.
The minimum iOS target is 17.0, due to the fact that I used `@Observable` macro for the `ViewModel`.

### Dependency Inversion
Although I only have my `Pokespeare` SDK as a dependency, I introduced the `PokemonBrowser` protocol to invert the dependency. `ViewModel` actually doesn't depend on the SDK, but the business logic is ensured... Neither the unit tests depend on the SDK. The dependency are composed in the  app... Ideally I could change SDK without affecting my app or my unit tests.
Dependency inversion is useful with SwiftUI previews too, since I can create my preview-only implementation, regarding the SDK I am using
