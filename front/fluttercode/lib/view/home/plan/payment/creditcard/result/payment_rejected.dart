import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentRejectedScreen extends StatelessWidget {
  final String statusDetail;
  final String paymentId;
  final double amount;
  final String description;

  const PaymentRejectedScreen({
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
        title: const Text('Pagamento Rejeitado'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Seu pagamento foi rejeitado',
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
                _getRejectionReason(statusDetail),
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
                  child: const Text('Tentar novamente'),
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

  String _getRejectionReason(String statusDetail) {
    switch (statusDetail) {
      case 'cc_rejected_call_for_authorize':
        return 'O pagamento precisa ser autorizado pelo emissor do cartão. Entre em contato com seu banco.';
      case 'cc_rejected_insufficient_amount':
        return 'Saldo insuficiente no cartão. Verifique seu limite disponível.';
      case 'cc_rejected_bad_filled_card_number':
        return 'Número do cartão incorreto. Verifique os dígitos do seu cartão.';
      case 'cc_rejected_bad_filled_date':
        return 'Data de expiração incorreta. Verifique a validade do seu cartão.';
      case 'cc_rejected_bad_filled_security_code':
        return 'Código de segurança incorreto. Verifique o CVV do seu cartão.';
      case 'cc_rejected_blacklist':
        return 'Cartão bloqueado. Entre em contato com seu banco.';
      case 'cc_rejected_high_risk':
        return 'Pagamento recusado por políticas de segurança.';
      case 'cc_rejected_duplicated_payment':
        return 'Pagamento duplicado. Verifique se esta compra já foi processada.';
      case 'cc_rejected_max_attempts':
        return 'Número máximo de tentativas excedido. Tente novamente mais tarde.';
      default:
        return 'Seu pagamento foi rejeitado pelo emissor do cartão. Motivo: $statusDetail';
    }
  }
}