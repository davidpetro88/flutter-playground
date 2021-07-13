import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_concepts/presentation/screens/home_screen.dart';
import '/logic/cubit/counter_cubit.dart';
import '/logic/cubit/counter_state.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen({Key? key, required this.title, required this.color})
      : super(key: key);

  final String title;
  final Color color;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: widget.color,
      ),
      body: Container(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  BlocConsumer<CounterCubit, CounterState>(
                      listener: (context, state) {
                    if (state.wasIncremented == true) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Incremented!'),
                        duration: const Duration(seconds: 2),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Decremented!'),
                        duration: const Duration(seconds: 2),
                      ));
                    }
                  }, builder: (context, state) {
                    return Text(
                      state.counterValue.toString(),
                      style: Theme.of(context).textTheme.headline4,
                    );
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'remove',
                    child: const Icon(Icons.remove),
                    backgroundColor: widget.color,
                    onPressed: () =>
                        BlocProvider.of<CounterCubit>(context).decrement(),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: 'add',
                    child: const Icon(Icons.add),
                    backgroundColor: widget.color,
                    onPressed: () => context.read<CounterCubit>().increment(),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              MaterialButton(
                color: widget.color,
                child: Text(
                  'Go To Home Page',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<CounterCubit>(context),
                              child: HomeScreen(
                                title: 'Home Screen',
                                color: Colors.blueAccent,
                              ),
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
