<h1 align="center">Bounce Tapper</h1>
<p align="center"><img src="https://velog.velcdn.com/images/ximya_hf/post/0ed0f079-52a8-4998-a36c-9c7d5ed979b2/image.png"/></p><p align="center"> BounceTapper allows you to effortlessly apply smooth Bounce (Shrink/Grow) touch animations to your widgets. Beyond the basic Shrink/Grow animations, the package is infused with carefully optimized interaction behaviors. Major apps like the App Store, GitHub, and Slack have adopted similar touch interactions, and BounceTapper brings you refined interaction logic inspired by a thorough analysis of these leading applications.</p><br> <p align="center"> <a href="https://flutter.dev"> <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter" alt="Platform" /> </a> <a href=""> <img src="https://img.shields.io/pub/v/bounce_tapper" alt="Pub Package"/> </a> <a href="https://opensource.org/licenses/MIT"> <img src="https://img.shields.io/github/license/aagarwal1012/animated-text-kit?color=red" alt="License: MIT" /> </a> </p><br>

# Demo

<p align="center"><img src="https://velog.velcdn.com/images/ximya_hf/post/5e5aa87f-4d09-474a-b27a-c756a63cccc7/image.gif"/></p>
<p align="center">Can apply exactly the same touch interactions as in the demo apps.</p>

<br>

# Key Features

- 🔑 Extremely easy to use
- 💻 Easily integrates with your existing widgets
- 🛠 Highly customizable
- 🔥 Various touch interaction logic carefully considered

<br>

# Installing

To use the Easy BounceTapper package in your Flutter project, follow these steps:

1. Depend on it

Add the following line to your project's `pubspec.yaml` file under the `dependencies` section:  

```yaml
dependencies:
  bounce_tapper: ^1.0.7
```

2. Install it

Run the following command in your terminal or command prompt:

```
$ flutter pub get
```

3. Import it

Add the following import statement to your Dart code:

```dart
import 'package:bounce_tapper/bounce_tapper.dart';
```


<br>

# Usage

1. It's incredibly simple. Just wrap the widget you want to apply the Shrink/Grow touch interaction to with BounceTapper.

```dart
BounceTapper(  
  onTap: () {},  
  child: Card(),  
)
BounceTapper(  
  child: YourCustomWidget()  
)
```

2. Pass the necessary touch events to the `onTap` method. If you have an existing custom widget that handles touch events, you can skip passing an `onTap` event directly.

```dart
/// 1. Executes the touch event inside BounceTapper
BounceTapper(  
  onTap: () {
      /// Touch Event!
  },  
  child: CustomWidget(),  
)

/// 2. Listens to the child widget's touch event and executes it
BounceTapper(  
  child: CustomButton(), 
)
```

The `onTap` property is optional, so if your child widget handles touch events on its own, the Shrink/Grow animation will still be triggered even without passing a touch event to BounceTapper.

<br>

# Features

BounceTapper not only offers Shrink/Grow touch animations but also provides various finely-tuned features.

## 1. Cancel ongoing interaction when scrolling

If you carefully observe the App Store's main page, you’ll notice that when a card view is touched and shrinks, scrolling will cancel the shrink and return the card to its original state without triggering the touch event.

<p align="center"><img src="https://velog.velcdn.com/images/ximya_hf/post/126f3e68-ef62-4fe7-a2d6-eade5578ae5f/image.png"/></p>

BounceTapper works similarly by detecting scroll events from parent widgets and canceling the ongoing shrink animation, restoring the widget without triggering a touch event. If you prefer to keep the animation and event active even when scrolling, you can set the `disableGrowOnScroll` property to `false`.

> Both vertical and horizontal scroll events are detected.

|Parameter|Default|Description|
|---|---|---|
|disableBounceOnScroll|true|Whether to cancel ongoing animation during scroll|

<br>

## 2. Customize Shrink/Grow animation

You can customize several aspects of the Shrink/Grow animation, such as the animation duration and the shrink size.

<p align="center"><img src="https://velog.velcdn.com/images/ximya_hf/post/668b828e-7771-4bac-845c-c432a406da20/image.png"/></p>

Although the default property values are set to feel quite natural, you can customize them if necessary.

|Parameter|Default|Description|
|---|---|---|
|shrinkScaleFactor|0.965|The scale to which the widget shrinks|
|shrinkDuration|Duration(milliseconds: 160)|Duration of the shrinking animation|
|growDuration|Duration(milliseconds: 120)|Duration of the growing animation|
|delayedDurationBeforeGrow|Duration(milliseconds: 60)|Delay before growing to ensure a smooth animation|
|shrinkCurve|Curves.easeInSine|Curve used for the shrinking animation|
|growCurve|Curves.easeOutSine|Curve used for the growing animation|
|enable|true|Whether to enable touch animation and events|

<br>

## 3. Highlight effect on touch

Just like `InkWell` or `MaterialButton`, BounceTapper also provides a highlight effect when the widget is touched, overlaying a color on the widget. You can customize the highlight color using the `highlightColor` property. If you don’t want any highlight effect, simply set it to `Colors.transparent`.

In some cases, using a widget like InkWell on a child widget with a `borderRadius` might cause the highlight to not clip properly, requiring you to wrap it in a `ClipRRect` widget.

<p align="center"><img src="https://velog.velcdn.com/images/ximya_hf/post/a840551b-9b94-4056-a89f-6937a211c89a/image.png"/></p>

However, BounceTapper automatically detects the nearest `borderRadius` from the child widget’s `renderObject` and clips the corners accordingly.

There are a few widgets for which `renderObject` cannot detect the `borderRadius`. In these cases, you can manually set the `highlightBorderRadius` to clip the highlight box with the correct radius.

> BounceTapper does not interfere with the highlight touch effects of wrapped widgets like FilledButton or InkWell.

| Parameter             | Default           | Description                           |
| --------------------- | ----------------- | ------------------------------------- |
| highlightColor        | Color(0x1F939BAC) | The color overlayed on touch          |
| highlightBorderRadius | null              | The borderRadius of the highlight box |

<br>

## 4. Interaction with parent/child BounceTapper widgets

There may be cases where you need to apply another BounceTapper to a child widget within a parent BounceTapper. In such scenarios, separate touch events are triggered when the child widget is touched and when the parent widget (excluding the child) is touched. Shrink/Grow animations are applied only to the child when it is touched, while the entire parent (including the child) will shrink/grow when the parent is touched.

<p align="center"><img src="https://velog.velcdn.com/images/ximya_hf/post/ca879456-5a73-47ad-b1d1-a16d0d6d1c81/image.png"/></p>

<br>

## 5. Support for various touch gestures

In addition to the `onTap` method, BounceTapper supports gestures like `onLongPress` and `onLongPressUp`. If you assign the `onLongPressUp` event, it prevents the `onTap` event from being executed by default. To allow both `onLongPressUp` and `onTap` to execute, set the `blockTapOnLongPressEvent` property to `false`.

Additionally, if you want to disable touch events and animations entirely, simply set the `enable` property to `false`.

|Parameter|Default|Description|
|---|---|---|
|onTap|null|Method to be executed on tap|
|onLongPress|null|Method to be executed on long press|
|onLongPressUp|null|Method to be executed when long press is released|
|blockTapOnLongPressEvent|true|Whether to block `onTap` when `onLongPressUp` is executed|
|enable|true|Whether to enable touch animations and events|

<br>

## 6. Prevent multiple and rapid touches

By default, the BounceTapper package prevents multiple rapid touches and simultaneous touches, ensuring that touch events aren’t triggered multiple times. If multiple BounceTapper widgets are touched at the same time, only the one that was touched first will trigger its animation and event.

<p align="center"><img src="https://velog.velcdn.com/images/ximya_hf/post/47678de9-a75d-4c6e-b3e8-57a65142bd9a/image.png"/></p>

<br>

## 7. Interaction when touch moves outside the touch area

If the widget is touched and shrinks, but the touch point moves outside the widget’s touch area, the ongoing animation will be canceled and the widget will grow back to its original size. And the touch event will not be triggered.

<p align="center"><img src="https://velog.velcdn.com/images/ximya_hf/post/2b9267a5-a8e6-42aa-8b2b-27116adb7968/image.png"/></p>