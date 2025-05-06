import 'package:NIDE/service/remote/plan/crud.dart';
import 'package:NIDE/view/home/dashboard/screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String paymentId;
  final String authorizationCode;
  final double amount;
  final String description;
  final String idProfile;
  final String idPlan;
  final String token;

  const PaymentSuccessScreen({
    Key? key,
    required this.paymentId,
    required this.authorizationCode,
    required this.amount,
    required this.description,
    required this.idProfile,
    required this.idPlan,
    required this.token,
  }) : super(key: key);

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isProcessing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _handlePaymentSuccess());
  }

  Future<void> _handlePaymentSuccess() async {
    try {
      print('Pagamento aprovado.');
      print(widget.idProfile);

      // Chama o serviço para adicionar o plano ao perfil
      await PlanService().addProfilePlan(
        idProfile: int.parse(widget.idProfile),
        idPlan: widget.idPlan,
        token: widget.token,
      );

      // Navega para o dashboard após o processamento
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Erro ao ativar o plano: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento Aprovado'),
        automaticallyImplyLeading: false,
      ),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text(
                    'Ativando seu plano...',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  // Text(
                  //   'Aguarde enquanto configuramos seu acesso',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Theme.of(context).textTheme.caption?.color,
                  //   ),
                  // ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage ?? 'Erro desconhecido',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    ),
                    child: const Text('Voltar ao Dashboard'),
                  ),
                ],
              ),
            ),
    );
  }
}
