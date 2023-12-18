import 'package:flutter/material.dart';

final step1Text = ValueNotifier('Original step 1 text');
final delegate = MyRouterDelegate();

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: delegate,
      routeInformationParser: MyRouteInformationParser(),
    );
  }
}

class MyRouterDelegate extends RouterDelegate<RouteInformation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteInformation> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  List<Page> _pages = [
    const MaterialPage(
      key: ValueKey('HomePage'),
      child: HomePage(),
    ),
  ];

  int _currentStep = 0;

  int get currentStep => _currentStep;

  set currentStep(int value) {
    if (_currentStep != value) {
      _currentStep = value;
      _pages = _generate(value);
      notifyListeners();
    }
  }

  List<Page> _generate(int step) => [
        const MaterialPage(
          key: ValueKey('HomePage'),
          child: HomePage(),
        ),
        if (currentStep > 0)
          const MaterialPage(
            key: ValueKey('Step1Page'),
            child: Step1Page(),
          ),
        if (currentStep > 1)
          const MaterialPage(
            key: ValueKey('Step2Page'),
            child: Step2Page(),
          ),
        if (currentStep > 2)
          const MaterialPage(
            key: ValueKey('Step3Page'),
            child: Step3Page(),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        currentStep--;
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteInformation configuration) async {}
}

class MyRouteInformationParser
    extends RouteInformationParser<RouteInformation> {
  @override
  Future<RouteInformation> parseRouteInformation(
      RouteInformation routeInformation) async {
    return routeInformation;
  }

  @override
  RouteInformation restoreRouteInformation(RouteInformation configuration) {
    return configuration;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => delegate.currentStep = 1,
              child: const Text('Go to Step 1'),
            ),
            ElevatedButton(
              onPressed: () => delegate.currentStep = 2,
              child: const Text('Go to Step 2'),
            ),
            ElevatedButton(
              onPressed: () => delegate.currentStep = 3,
              child: const Text('Go to Step 3'),
            ),
          ],
        ),
      ),
    );
  }
}

class Step1Page extends StatelessWidget {
  const Step1Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ValueListenableBuilder(
                valueListenable: step1Text,
                builder: (_, text, __) {
                  return Text(text);
                }),
            ElevatedButton(
              onPressed: () => delegate.currentStep = 2,
              child: const Text('Go to Step 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class Step2Page extends StatelessWidget {
  const Step2Page({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => delegate.currentStep = 3,
              child: const Text('Go to Step 3'),
            ),
          ],
        ),
      ),
    );
  }
}

class Step3Page extends StatelessWidget {
  const Step3Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 3'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => step1Text.value = 'modified',
              child: const Text('Modify step 1 text'),
            ),
            ElevatedButton(
              onPressed: () => delegate.currentStep = 0,
              child: const Text('Back to Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}
