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

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final double cafeValorUnitario = 0.75;
  final double almocoValorUnitario = 1.50;
  final double jantaValorUnitario = 1.50;

  int cafeQuantidade = 0;
  int almocoQuantidade = 0;
  int jantaQuantidade = 0;

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
            RefeicaoCard("Café (0,75 unidade)", cafeQuantidade, (int count) {
              setState(() {
                cafeQuantidade = count;
                updateTotal();
              });
            }),
            RefeicaoCard("Almoço (1,50 unidade)", almocoQuantidade, (int count) {
              setState(() {
                almocoQuantidade = count;
                updateTotal();
              });
            }),
            RefeicaoCard("Janta (1,50 unidade)", jantaQuantidade, (int count) {
              setState(() {
                jantaQuantidade = count;
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
      totalCusto = (cafeQuantidade * cafeValorUnitario) +
          (almocoQuantidade * almocoValorUnitario) +
          (jantaQuantidade * jantaValorUnitario);
    });
  }
}

class RefeicaoCard extends StatefulWidget {
  final String refeicaoNome;
  final int refeicaoQuantidade;
  final Function(int) onCountChanged;

  const RefeicaoCard(this.refeicaoNome, this.refeicaoQuantidade, this.onCountChanged,
      {super.key});

  @override
  _RefeicaoCardState createState() => _RefeicaoCardState();
}

class _RefeicaoCardState extends State<RefeicaoCard> {
  late int refeicaoCount;

  @override
  void initState() {
    super.initState();
    refeicaoCount = widget.refeicaoQuantidade;
  }

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
  
