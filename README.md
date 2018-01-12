# Movie Time (iOS)

This app allows viewing a list of movies.

## Getting Started 

### Requirements
The current version requires:

- Xcode 9 or later.

- Swift 4.0 or later.

- iOS 10 or later.

### Installing

Just CMD + R to run the project. There is no thirdy library or pre configuration to do.


## Coding style

We are using the **MVVM - Model View View Model** pattern, where each View on the screen will be backed by a View Model that represents the data for the view.

#### View Controllers:
It is used only to display data.
Each view controller need to inherit from MTViewController class and override some properties:

```swift
// The storyboard name that the ViewController is embedded
override class var storyboardName: String {
    return {storyboard_name}
}

// The ViewController's ViewModel
fileprivate var viewModel: {view_model}? {
    return baseViewModel as? {view_model}
}
```

For exemple, for the MNOrderInvoiceViewController, we have the follow implementation:

```swift
// MARK: Properties
override class var storyboardName: String {
   return MNIdentifiers.Storyboard.OrderDetail.name
}

fileprivate var viewModel: MNOrderInvoiceViewModel? {
   return baseViewModel as? MNOrderInvoiceViewModel
}
```

> IMPORTANT NOTE: The **Storyboard ID** should be the same name of the View Controller.

#### View Models
It is used to provide data to the view and should be able to accomodate the complete view.
It should not contain networking code or data access code, directity.

##### Binding:
Refers to the flow of information between the views and the view models.
We are dispatch events using blocks:

```swift
// Inside ViewModel
var onInformationChanged: (() -> Void)?
var onInformationFailed: ((Error?) -> Void)?

// Inside ViewController
viewModel.onInformationChanged = {
   ...
}
viewModel.onInformationFailed = { error in
   ...
}
```


## Authors

* **Enrique Melgarejo**

## License

// This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details