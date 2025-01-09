import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@riverpod
Future<String> asyncGreet(AsyncGreetRef ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Hello World';
}

// クラスベースのProvider
@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  Future<int> build() async {
    await Future.delayed(const Duration(seconds: 1));
    return 0;
  }

  void increment() async {
    final currentValue = state.valueOrNull;
    if (currentValue == null) {
      return;
    }

    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(seconds: 1));
    state = AsyncValue.data(currentValue + 1);
  }
}

@riverpod
Raw<Future<int>> fakeFirstApi(FakeFirstApiRef ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return 1;
}

@riverpod
Raw<Future<int>> fakeSecondApi(FakeSecondApiRef ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return 2;
}

@override
Raw<Future<int>> fakeSumApi(FakeSumApiRef ref) async {
  final int firstApiResult = ref.watch(fakeFirstApiProvider);
  final int secondApiResult = ref.watch(fakeSecondApiProvider);
  return firstApiResult + secondApiResult;
}
//
void main() {
  runApp(
    const ProviderScope(
        child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<int> counter = ref.watch(counterNorifierProvider);
    final AsyncValue<String> greet = ref.watch(asyncGreetProvider);
    final AsyncValue<int> sumApiResult = ref.watch(fakeSumApiProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            greet.when(
              loading: () => const Text('Loading'),
              data: (greet) => Text(greet),
              error: (e, st) => Text(e.toString())
            ),
            sumApiResult.when(
              loading: () => const Text('Loading'),
              data: (sum) => Text('$sum'),
              error: (e, st) => Text(e.toString())
            ),
            counter.when(
              loading: () => const Text('Loading'),
              data: (count) => Text('$count'),
              error: (e, st) => Text(e.toString())
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(counterNorifierProvider.notifier).increment();
          },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          ref.read(counterNotifierProvider.notifier).increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
