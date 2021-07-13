import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _tituloAppBar = 'Criando transferencia';
const _rotuloCampoValor = 'Valor';
const _rotuloCampoValorNumeroConta = 'Número da conta';
const _dicaCampoValor = '0.00';
const _dicaCampoValorNumeroConta = '0000';
const _textoBotaoConfirmar = 'Confirmar';

class FormularioTransferencia extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorCampoNumeroConta =
  TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tituloAppBar,
          textDirection: TextDirection.rtl,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Editor(
              controlador: _controladorCampoNumeroConta,
              rotulo: _rotuloCampoValorNumeroConta,
              dica: _dicaCampoValorNumeroConta,
            ),
            Editor(
              controlador: _controladorCampoValor,
              rotulo: _rotuloCampoValor,
              dica: _dicaCampoValor,
              icone: Icons.monetization_on,
            ),
            ElevatedButton(
                child: Text(_textoBotaoConfirmar),
                onPressed: () => _criarTransferencia(context))
          ],
        ),
      ),
    );
  }

  void _criarTransferencia(BuildContext context) {
    debugPrint(_controladorCampoNumeroConta.text);
    final int? numeroConta = int.tryParse(_controladorCampoNumeroConta.text);
    final double? valor = double.tryParse(_controladorCampoValor.text);
    if (valor != null && numeroConta != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      // console.
      debugPrint('clicou no evento');
      debugPrint('$transferenciaCriada');
      // mensagem na tela
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$transferenciaCriada'),
        ),
      );
      Navigator.pop(context, transferenciaCriada);
    }
  }
}
