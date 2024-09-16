<h1 align="center">Easy Isolate Mixin</h1>
<p align="center"><img src="https://github.com/aagarwal1012/Animated-Text-Kit/assets/75591730/f9d03a37-c830-45d7-9adb-20bb096f942b"/></p>
<p align="center">The Easy Isolate Mixin is a powerful mixin package designed to streamline the usage of isolates in your Flutter applications. With this Package, you can easily leverage isolates to perform concurrent and computationally intensive tasks without blocking the main thread.</p><br>

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter"
      alt="Platform" />
  </a>
  <a href="">
    <img src="https://img.shields.io/pub/v/easy_isolate_mixin"
      alt="Pub Package"/>
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/github/license/aagarwal1012/animated-text-kit?color=red"
      alt="License: MIT" />
  </a>


</p><br>




# Key Features


*   🔑  Extremely easy to use
*   👨‍👦‍👦  Efficient Isolate Management
*   🔥  Enhanced Performance
*   🥶  Prevents your UI from freezing
*   🛠  Scalability enabled by mixins



# Installing

To use the Easy Isolate Mixin package in your Flutter project, follow these steps:

1. Depend on it

Add the following line to your project's `pubspec.yaml` file under the `dependencies` section:

```yaml
dependencies:
  easy_isolate_mixin: ^1.0.0
```

2. Install it

Run the following command in your terminal or command prompt:

```
$ flutter pub get
```

3. Import it

Add the following import statement to your Dart code:

```dart
import 'package:easy_isolate_mixin/easy_isolate_mixin.dart';
```

# Usage

1. Import the package:

```dart
import 'package:easy_isolate_mixin/easy_isolate_mixin.dart';
```


2. Create a class and mixin the `IsolateHelperMixin`:

```dart
class Service with IsolateHelperMixin {
  // Your methods and logic here
}
```

3. Use the `loadWithIsolate()` method to perform expensive work:

```dart
class Service with IsolateHelperMixin {
  Future<void> performExpensiveWork() async {
    final result = await loadWithIsolate(() async{
      // Perform your expensive work here
      // Return the result
    });
    
  }
}
```

In the `performExpensiveWork()` method, you can use the `loadWithIsolate()` method from the `IsolateHelperMixin` to perform your expensive work in a separate isolate. Simply pass a function to `loadWithIsolate()` that contains your expensive computation. The result of the computation will be returned as a `Future`.

## Handling Big Data
Here's an example of using `loadWithIsolate()` to fetch a list of `SomeData` objects:

```dart
class DataSource with IsolateHelperMixin {
  Future<List<SomeData>> fetchAmountOfData() => 
  loadWithIsolate(() => _api.getAmountOfData());
}
```

The `_api.getAmountOfData()` function represents your data fetching logic. It will be executed in a separate isolate, allowing your UI to remain responsive while the data is being fetched. The result will be returned as a `Future<List<SomeData>>`.

Note: Make sure the function you pass to `loadWithIsolate()` returns a value or a `Future` that resolves to the desired result type.

That's it! You can now leverage the power of isolates to perform concurrent and computationally intensive tasks without blocking the main thread.


