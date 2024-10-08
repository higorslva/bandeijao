import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';


class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'credit';
  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela de Pagamento'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Valor Total: R\$ ${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Forma de Pagamento:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              ListTile(
                title: const Text('Crédito'),
                leading: Radio<String>(
                  value: 'credit',
                  groupValue: _paymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Débito'),
                leading: Radio<String>(
                  value: 'debit',
                  groupValue: _paymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Pix'),
                leading: Radio<String>(
                  value: 'pix',
                  groupValue: _paymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (_paymentMethod == 'pix') ...[
                Center(
                  child: Image.asset(
                    'assets/qrcode.jpg',
                    width: 200,
                    height: 200,
                  ),
                ),
              ] else ...[
                Form(
                  key: _formKey,
                  child: _buildCardInfoForm(),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _processPayment();
                  }
                },
                child: const Text('Confirmar Pagamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _processPayment() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Processando Pagamento'),
        content: Row(
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            const Text('Por favor, aguarde...'),
          ],
        ),
      );
    },
  );

  Future.delayed(const Duration(seconds: 2), () {
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(totalPaid: widget.totalAmount),
      ),
    );
  });
}


  Widget _buildCardInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Informações do Cartão:',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Número do Cartão'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _cardNumber = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o número do cartão';
            } else if (value.length != 16) {
              return 'O número do cartão deve ter 16 dígitos';
            }
            return null;
          },
        ),
        TextFormField(
          decoration:
              const InputDecoration(labelText: 'Data de Validade (MM/AA)'),
          keyboardType: TextInputType.datetime,
          onChanged: (value) {
            _expiryDate = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira a data de validade';
            } else if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$')
                .hasMatch(value)) {
              return 'A data de validade deve estar no formato MM/AA';
            }
            return null;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'CVV'),
          keyboardType: TextInputType.number,
          obscureText: true,
          onChanged: (value) {
            _cvv = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o CVV';
            } else if (value.length != 3) {
              return 'O CVV deve ter 3 dígitos';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class PaymentConfirmationScreen extends StatelessWidget {
  final double totalPaid;
  final int codigoVerificacao;

  PaymentConfirmationScreen({super.key, required this.totalPaid})
      : codigoVerificacao = _gerarCodigoVerificacao(); // Gera o código aqui

  static int _gerarCodigoVerificacao() {
    final random = Random();
    return 100000 + random.nextInt(900000); // Gera um número entre 100000 e 999999
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento Concluído'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,
              ),
              const SizedBox(height: 20),
              const Text(
                'Pagamento realizado com sucesso!',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Comprovante',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Valor Pago: R\$ ${totalPaid.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Código de verificação: #$codigoVerificacao',
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Text('Voltar ao Menu Inicial'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
