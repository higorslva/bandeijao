// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double cafeValor = 0.75;
  double almocoValor = 1.50;
  double jantaValor = 1.50;
  double totalCusto = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Refeições'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            RefeicaoCard("Café (0,75 unidade)", cafeValor, (int count) {
              setState(() {
                cafeValor = 0.75 * count;
                updateTotal();
              });
            }),
            RefeicaoCard("Almoço (1,50 unidade)", almocoValor, (int count) {
              setState(() {
                almocoValor = 1.50 * count;
                updateTotal();
              });
            }),
            RefeicaoCard("Janta (1,50 unidade)", jantaValor, (int count) {
              setState(() {
                jantaValor = 1.50 * count;
                updateTotal();
              });
            }),
            Text(
              'Total: R\$ ${totalCusto.toStringAsFixed(2)}',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void updateTotal() {
    setState(() {
      totalCusto = cafeValor + almocoValor + jantaValor;
    });
  }
}

class RefeicaoCard extends StatefulWidget {
  final String refeicaoNome;
  final double refeicaoValor;
  final Function(int) onCountChanged;

  const RefeicaoCard(this.refeicaoNome, this.refeicaoValor, this.onCountChanged,
      {super.key});

  @override
  _RefeicaoCardState createState() => _RefeicaoCardState();
}

class _RefeicaoCardState extends State<RefeicaoCard> {
  int refeicaoCount = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.refeicaoNome,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Quantidade: ',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  refeicaoCount.toString(),
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      refeicaoCount++;
                      widget.onCountChanged(refeicaoCount);
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (refeicaoCount > 0) {
                      setState(() {
                        refeicaoCount--;
                        widget.onCountChanged(refeicaoCount);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
