import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Valor Total: R\$ ${widget.totalAmount.toStringAsFixed(2)}',
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Forma de Pagamento:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                  // Processar o pagamento
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pagamento processado com sucesso!'),
                    ),
                  );
                }
              },
              child: const Text('Confirmar Pagamento'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Informações do Cartão:',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
