import 'dart:async';
import 'package:bytebank_06/components/error.dart';
import 'package:bytebank_06/components/progress.dart';
import 'package:bytebank_06/http/webclients/i18nwebclient.dart';
import 'package:bytebank_06/screens/transferencia/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import 'container.dart';

class LocalizationContainer extends BlocContainer {
  final Widget child;

  LocalizationContainer({required Widget this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: CurrentLocaleCubit(),
      child: this.child,
    );
    return BlocProvider<CurrentLocaleCubit>(
      create: (context) => CurrentLocaleCubit(),
      child: this.child,
    );
  }
}

class CurrentLocaleCubit extends Cubit<String> {
  CurrentLocaleCubit() : super("pt-br");
}

class ViewI18N {
  late String _language;

  ViewI18N(BuildContext context) {
    this._language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  String localize(Map<String, String> values) {
    assert(values != null);
    assert(values.containsKey(_language));
    return values[_language]!;
  }
}

@immutable
abstract class I18NMessageState {
  const I18NMessageState();
}

@immutable
class LoadingI18NMessageState extends I18NMessageState {
  const LoadingI18NMessageState();
}

@immutable
class IniI18NMessageState extends I18NMessageState {
  const IniI18NMessageState();
}

@immutable
class LoadedI18NMessageState extends I18NMessageState {
  final I18NMessages _messages;

  const LoadedI18NMessageState(this._messages);
}

class I18NMessages {
  final Map<String, dynamic> _messages;

  I18NMessages(this._messages);

  String get(String key) {
    assert(_messages != null);
    assert(_messages.containsKey(key));
    return _messages[key]!;
  }
}

@immutable
class FatalErrorI18NMessageState extends I18NMessageState {
  final String _message;

  const FatalErrorI18NMessageState(this._message);
}

typedef Widget I18WidgetCreator(I18NMessages messages);

class I18NLoadingContainer extends BlocContainer {
  late String viewKey;
  late I18WidgetCreator creator;

  I18NLoadingContainer({
    required String viewKey,
    required I18WidgetCreator creator,
  }) {
    this.creator = creator;
    this.viewKey = viewKey;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessageCubit>(
      create: (BuildContext context) {
        final cubit = I18NMessageCubit(this.viewKey);
        cubit.reload(I18WebClient(this.viewKey));
        return cubit;
      },
      child: I18NLoadingView(this.creator),
    );
  }
}

class I18NLoadingView extends StatelessWidget {
  final I18WidgetCreator _creator;

  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessageCubit, I18NMessageState>(
        builder: (context, state) {
      if (state is IniI18NMessageState || state is LoadingI18NMessageState) {
        return ProgressView(message: "Loading..");
      }
      if (state is LoadedI18NMessageState) {
        final messages = state._messages;
        return _creator.call(messages);
      }
      return ErrorView("Error loaded language");
    });
  }
}

class I18NMessageCubit extends Cubit<I18NMessageState> {
  // Future.delayed(Duration(seconds: 10));
  final LocalStorage storage = new LocalStorage('local_unsecure_version1.json');
  final String _viewKey;

  I18NMessageCubit(this._viewKey) : super(IniI18NMessageState());

  Future<void> reload(I18WebClient client) async {
    emit(LoadingI18NMessageState());

    await storage.ready; // Esperar store ser carregada.

    final items = storage.getItem(this._viewKey);
    print("Loaded $_viewKey $items");

    if (items != null) {
      print("Loaded item IF $_viewKey $items");
      emit(LoadedI18NMessageState(I18NMessages(items)));
      return;
    }
    client.findAll().then(saveAndRefresh);
  }

  FutureOr<void> saveAndRefresh(messages) {
    print("Saving $_viewKey $messages");
    storage.setItem(_viewKey, messages);
    emit(LoadedI18NMessageState(I18NMessages(messages)));
  }
}
