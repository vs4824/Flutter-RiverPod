# Riverpod Food App

A state-management library that:

1. catches programming errors at compile time rather than at runtime

2. removes nesting for listening/combining objects

3. ensures that the code is testable


Declare your providers as global variables:

```
final counterProvider = StateNotifierProvider((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter(): super(0);

  void increment() => state++;
}
```

Use them inside your widgets in a compile time safe way. No runtime exceptions!

```
class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text(count.toString());
  }
}
```
