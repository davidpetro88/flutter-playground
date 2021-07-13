import 'dart:async';

import 'package:bytebank_06/components/localization/i18n_messages.dart';
import 'package:bytebank_06/components/localization/i18n_state.dart';
import 'package:bytebank_06/http/webclients/i18nwebclient.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

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
