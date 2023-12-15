import 'package:flutter/material.dart';

String step1Text = 'Original step 1 text';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: MyRouterDelegate(),
      routeInformationParser: MyRouteInformationParser(),
    );
  }
}

class MyRouterDelegate extends RouterDelegate<RouteInformation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteInformation> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  int _currentStep = 0;

  int get currentStep => _currentStep;

  set currentStep(int value) {
    if (_currentStep != value) {
      _currentStep = value;
      notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('HomePage'),
          child: HomePage(goToStep: (step) => currentStep = step),
        ),
        if (currentStep > 0)
          MaterialPage(
            key: const ValueKey('Step1Page'),
            child: Step1Page(goToStep: (step) => currentStep = step),
          ),
        if (currentStep > 1)
          MaterialPage(
            key: const ValueKey('Step2Page'),
            child: Step2Page(goToStep: (step) => currentStep = step),
          ),
        if (currentStep > 2)
          MaterialPage(
            key: const ValueKey('Step3Page'),
            child: Step3Page(goToStep: (step) => currentStep = step),
          ),
      ],
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
  const HomePage({super.key, required this.goToStep});
  final Function(int) goToStep;

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
              onPressed: () => goToStep(1),
              child: const Text('Go to Step 1'),
            ),
            ElevatedButton(
              onPressed: () => goToStep(2),
              child: const Text('Go to Step 2'),
            ),
            ElevatedButton(
              onPressed: () => goToStep(3),
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
    required this.goToStep,
  });
  final Function(int) goToStep;

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
            Text(step1Text),
            ElevatedButton(
              onPressed: () => goToStep(2),
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
    required this.goToStep,
  });
  final Function(int) goToStep;
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
              onPressed: () => goToStep(3),
              child: const Text('Go to Step 3'),
            ),
          ],
        ),
      ),
    );
  }
}

class Step3Page extends StatelessWidget {
  const Step3Page({super.key, required this.goToStep});
  final Function(int) goToStep;

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
              onPressed: () => step1Text = 'Modified step 1 text',
              child: const Text('Modify step 1 text'),
            ),
            ElevatedButton(
              onPressed: () => goToStep(0),
              child: const Text('Back to Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}
