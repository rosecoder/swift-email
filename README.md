# SwiftEmail

SwiftEmail is an experimental Swift Package Manager library designed to simplify the creation of HTML emails by utilizing a SwiftUI-inspired interface with result builders, environments, and more. This library is currently in the early stages of development as a proof of concept.

## Features

- **SwiftUI-like Syntax**: Use a declarative syntax familiar to SwiftUI developers.
- **Result Builders**: Easily construct complex HTML emails.
- **Environment Support**: Pass down environment values seamlessly.

## Usage

Here's a simple example of creating an HTML email:

```swift
let email = Email {
    Text("Hello, world!")

    Divider()

    HStack {
        Text("This is an example of an HTML email built with swift-email.")
            .font(.headline)

        Image(.logo)
    }
}

let render = email.render()
let html = render.html
let plainText = render.text
```

## Contributing

As this is an early proof of concept, contributions, ideas, and feedback are highly welcomed. Please feel free to fork the repository, make your changes, and submit a pull request.
