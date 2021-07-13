import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_concepts/logic/cubit/internet_cubit.dart';
import 'package:flutter_bloc_concepts/logic/cubit/internet_state.dart';

import '/logic/cubit/counter_cubit.dart';
import '/logic/cubit/counter_state.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title, required this.color})
      : super(key: key);

  final String title;
  final Color color;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext homeScreenContext) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetConnected &&
            state.connectionType == ConnectionType.Wifi) {
          context.watch()<CounterCubit>().increment();
        } else if (state is InternetConnected &&
            state.connectionType == ConnectionType.Mobile) {
          context.watch()<CounterCubit>().decrement();
        }
      },
      child: Scaffold(
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
                BlocBuilder<InternetCubit, InternetState>(
                  builder: (internetCubitContext, state) {
                    if (state is InternetConnected &&
                        state.connectionType == ConnectionType.Wifi) {
                      return Text(
                        'Wi-Fi',
                        style: Theme.of(internetCubitContext)
                            .textTheme
                            .headline3!
                            .copyWith(
                              color: Colors.green,
                            ),
                      );
                    } else if (state is InternetConnected &&
                        state.connectionType == ConnectionType.Mobile) {
                      return Text(
                        'Mobile',
                        style: Theme.of(internetCubitContext)
                            .textTheme
                            .headline3!
                            .copyWith(
                              color: Colors.red,
                            ),
                      );
                    } else if (state is InternetDisconnected) {
                      return Text(
                        'Disconnected',
                        style: Theme.of(internetCubitContext)
                            .textTheme
                            .headline3!
                            .copyWith(
                              color: Colors.grey,
                            ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                Divider(
                  height: 5,
                ),
                BlocConsumer<CounterCubit, CounterState>(
                  listener: (counterCubitListenerContext, state) {
                    if (state.wasIncremented == true) {
                      ScaffoldMessenger.of(counterCubitListenerContext)
                          .showSnackBar(SnackBar(
                        content: const Text('Incremented!'),
                        duration: const Duration(seconds: 2),
                      ));
                    } else if (state.wasIncremented == false) {
                      ScaffoldMessenger.of(counterCubitListenerContext)
                          .showSnackBar(SnackBar(
                        content: const Text('Decremented!'),
                        duration: const Duration(seconds: 2),
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state.counterValue < 0) {
                      return Text(
                        'BRR, NEGATIVE ' + state.counterValue.toString(),
                        style: Theme.of(context).textTheme.headline4,
                      );
                    } else if (state.counterValue % 2 == 0) {
                      return Text(
                        'YAAAY ' + state.counterValue.toString(),
                        style: Theme.of(context).textTheme.headline4,
                      );
                    } else if (state.counterValue == 5) {
                      return Text(
                        'HMM, NUMBER 5',
                        style: Theme.of(context).textTheme.headline4,
                      );
                    } else
                      return Text(
                        state.counterValue.toString(),
                        style: Theme.of(context).textTheme.headline4,
                      );
                  },
                ),

                SizedBox(
                  height: 24,
                ),
                Builder(
                  builder: (context) {
                    final counterValue = context
                        .select((CounterCubit cubit) => cubit.state.counterValue);
                    return Text(
                      'Counter: ' + counterValue.toString(),
                      style: Theme.of(context).textTheme.headline6,
                    );
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                ///
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
                          BlocProvider.of<CounterCubit>(homeScreenContext)
                              .decrement(),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'add',
                      child: const Icon(Icons.add),
                      backgroundColor: widget.color,
                      onPressed: () =>
                          homeScreenContext.read<CounterCubit>().increment(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: widget.color,
                      child: Text(
                        'Go To Second Page',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(homeScreenContext).pushNamed('/second');
                      },
                    ),
                    MaterialButton(
                      color: widget.color,
                      child: Text(
                        'Go To Third Page',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(homeScreenContext).pushNamed('/third');
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                MaterialButton(
                  color: widget.color,
                  child: Text(
                    'Go To Settings',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(homeScreenContext).pushNamed('/settings');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
