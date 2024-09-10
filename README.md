# ChromaKit

ChromaKit lets you easily create colors in the Lch, Lab, Oklch, and Oklab color spaces, convert them, and display them in native color types.

The color transformations are based on [CSS Color Module Level 4](https://www.w3.org/TR/css-color-4/) sample code, and so should closely match what you see in most browsers.

## Usage

Initialize `Color`, `UIColor`, or `NSColor` using ChromaKit color types:

```swift
import ChromaKit

// Create
let lch = Lch(l: 80, c: 80, h: 80)
let lab = Lab(l: 80, a: 13.89, b: 78.78)
let oklch = Oklch(l: 0.833, c: 0.168, h: 80.115)
let oklab = Oklab(l: 0.833, a: 0.029, b: 0.165)

// Convert
let xyz = lch.xyz
let p3 = lab.p3

// Display
let color = Color(lch)
let uiColor = UIColor(lab)
let nsColor = NSColor(oklch) 
```

## Installation

### SPM

To use ChromaKit in your SPM package, add it as a dependency to your `Package.swift`:

```
.package(url: "https://github.com/HarshilShah/ChromaKit")
```

And include ChromaKit as a dependency for your target:

```
.product(name: "ChromaKit", package: "ChromaKit")
```

### Xcode Project

To use ChromaKit in your Xcode project, select `File > Add Packages` in Xcode, and enter the URL for this repository in the search field:

```
https://github.com/HarshilShah/ChromaKit
```
