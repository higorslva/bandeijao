import 'package:flutter/material.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  final List<Purchase> purchases;

  const PurchaseHistoryScreen({super.key, required this.purchases});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Compras'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          final purchase = purchases[index];
          return ListTile(
            title: Text('Valor: R\$ ${purchase.totalAmount.toStringAsFixed(2)}'),
            subtitle: Text('Método: ${purchase.paymentMethod}\n'
                'Últimos 4 Dígitos: ${purchase.lastFourDigits}\n'
                'Código de Compra: ${purchase.transactionId}'),
            contentPadding: const EdgeInsets.all(16.0),
            onTap: () {
              // Ação ao clicar na compra (se necessário)
            },
          );
        },
      ),
    );
  }
}

class Purchase {
  final double totalAmount;
  final String paymentMethod;
  final String lastFourDigits;
  final String transactionId;

  Purchase({
    required this.totalAmount,
    required this.paymentMethod,
    required this.lastFourDigits,
    required this.transactionId,
  });
}
