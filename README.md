# CustomSegmentedView

A custom segmented view that supports
- Adding any view (UIView, UIImageView or UIButton, etc.)
- Spacing between views. The default value is 20.
- Setting selected index. The first view will be selected by default, but you can change it.
- A indicator view for the selected view that can be any view.
- Custom animation for the selected view.
- Work well on portrait and landscape mode.

# Usage
## Creating views
You can add any view to the custom segmented view. I will add three buttons to it as an example.

```swift
let button1 = UIButton()
button1.setTitle("Button 1", for: .normal)
button1.backgroundColor = .red

let button2 = UIButton()
button2.setTitle("Button 2", for: .normal)
button2.backgroundColor = .green

let button3 = UIButton()
button3.setTitle("Button 3", for: .normal)
button3.backgroundColor = .yellow
```

## Adding indicator
An indicator can be any view. You can add a plain view or an UIImageView as the indicator. For demo purpose, I will add an empty view with black color.

```swift
// Indicator view
let indicatorView = UIView()
indicatorView.backgroundColor = .black
```

## Adding segmented view as a subview
You can change the default spacing to any number. To disable the indicator view, just set it to `nil`.

```swift
let segmentedView = CustomSegmentedView(segmentedViews: [button1, button2, button3], spacing: 20, selectedIndex: 0, indicatorView: indicatorView)
segmentedView.translatesAutoresizingMaskIntoConstraints = false

view.addSubview(segmentedView)
NSLayoutConstraint.activate([
    segmentedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    segmentedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
    segmentedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
])
```
## Combine publisher to emit the selected index
Combine publisher supported. When a selected index changed, it will emit a new value.
```swift
cancelable = segmentedView.selectedIndexSubject.sink(receiveValue: { selectedIndex in
    print("Selected index \(selectedIndex)")
})
```

## Custom selected animation
By default, the alpha of selected view is 1.0, and 0.4 for the other views. You can create your own animation and pass it to the init function.

```swift
public static let alphaAnimator: AnimatingClosure = { index, selectedIndex, view in
    view.alpha = selectedIndex == index ? 1.0 : 0.4
}
```
