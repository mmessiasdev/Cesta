import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentPendingScreen extends StatelessWidget {
  final String statusDetail;
  final String paymentId;
  final double amount;
  final String description;

  const PaymentPendingScreen({
    Key? key,
    required this.statusDetail,
    required this.paymentId,
    required this.amount,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento em Processamento'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, color: Colors.orange, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Seu pagamento está em processamento',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Descrição:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(description),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Valor:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(currencyFormat.format(amount)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ID do pagamento:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(paymentId),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _getPendingReason(statusDetail),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Verificar status'),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => Navigator.popUntil(
                      context, ModalRoute.withName('/')),
                  child: const Text('Voltar ao início'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPendingReason(String statusDetail) {
    switch (statusDetail) {
      case 'pending_contingency':
        return 'Seu pagamento está em análise e pode levar até 2 dias úteis para ser processado. Você receberá um e-mail quando o status for atualizado.';
      case 'pending_review_manual':
        return 'Seu pagamento está em revisão manual por medidas de segurança. Este processo pode levar até 2 dias úteis.';
      case 'pending_waiting_payment':
        return 'Aguardando confirmação do pagamento. Se você optou por pagar com boleto ou outro método offline, o prazo para confirmação é de 1 a 3 dias úteis.';
      case 'pending_waiting_transfer':
        return 'Aguardando confirmação da transferência. O prazo normal é de 1 a 2 dias úteis.';
      default:
        return 'Seu pagamento está em processamento. Status atual: $statusDetail';
    }
  }
}