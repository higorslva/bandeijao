import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_screen.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_screen.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(), // Define a LoginScreen como a tela inicial
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController matriculaController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: matriculaController,
              decoration:
                  const InputDecoration(labelText: 'Número de Matrícula'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String matricula = matriculaController.text;
                String senha = senhaController.text;

                if (matricula == '123456' && senha == '1234') {
                  // Navega para a HomeScreen após login bem-sucedido
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Número de matrícula ou senha inválidos')),
                  );
                }
              },
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> compras = [];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_isLoggedIn ? 'Olá doidão' : 'Visitante'),
              accountEmail:
                  _isLoggedIn ? null : Text('Faça login para acessar'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                if (!_isLoggedIn) {
                  Navigator.of(context)
                      .pop(); // Fecha o drawer antes de mostrar o diálogo de login
                  _showLoginDialog();
                }
              },
            ),
            // Outros itens do menu podem ser adicionados aqui
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculatorScreen()),
                );
              },
              child: const Text('Comprar Refeição'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                const url =
                    'https://www2.unifap.br/dace/restaurante-universitario/cardapio-do-mes';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Não foi possível abrir o link $url';
                }
              },
              child: const Text('Consultar Refeição'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HistoricoComprasScreen(compras: compras)),
                );
              },
              child: const Text('Histórico de Compras'),
            )
          ],
        ),
      ),
    );
  }

  void _showLoginDialog() {
    final TextEditingController matriculaController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: matriculaController,
                decoration:
                    const InputDecoration(labelText: 'Número de Matrícula'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                String matricula = matriculaController.text;
                String senha = senhaController.text;

                if (matricula == '123456' && senha == '1234') {
                  setState(() {
                    _isLoggedIn = true;
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Número de matrícula ou senha inválidos')),
                  );
                }
              },
              child: const Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
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
            RefeicaoCard("Almoço (1,50 unidade)", almocoQuantidade,
                (int count) {
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  compras.add(
                      'Café: $cafeQuantidade, Almoço: $almocoQuantidade, Janta: $jantaQuantidade, Total: R\$ ${totalCusto.toStringAsFixed(2)}');
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaymentScreen(totalAmount: totalCusto)),
                );
              },
              child: const Text('Ir para Pagamento'),
            )
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

  const RefeicaoCard(
      this.refeicaoNome, this.refeicaoQuantidade, this.onCountChanged,
      {super.key});

  @override
  _RefeicaoCardState createState() => _RefeicaoCardState();
}

class HistoricoComprasScreen extends StatelessWidget {
  final List<String> compras;

  HistoricoComprasScreen({required this.compras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Compras'),
        backgroundColor: Colors.blue,
      ),
      body: compras.isEmpty
          ? const Center(
              child: Text('Nenhuma compra feita nesta sessão'),
            )
          : ListView.builder(
              itemCount: compras.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(compras[index]),
                );
              },
            ),
    );
  }
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
