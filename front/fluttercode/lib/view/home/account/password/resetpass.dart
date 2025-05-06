import 'package:NIDE/component/colors.dart';
import 'package:NIDE/service/remote/account/password/crud.dart';
import 'package:NIDE/view/home/account/password/newpass.dart';
import 'package:flutter/material.dart';

class ResetCodeScreen extends StatefulWidget {
  final String email;

  const ResetCodeScreen({super.key, required this.email});

  @override
  State<ResetCodeScreen> createState() => _ResetCodeScreenState();
}

class _ResetCodeScreenState extends State<ResetCodeScreen> {
  final List<TextEditingController> _codeControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;

  void _onCodeChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  String _getFullCode() {
    return _codeControllers.map((c) => c.text).join();
  }

  Future<void> _verifyCode() async {
    final code = _getFullCode();
    if (code.length != 6) {
      setState(() => _errorMessage = 'Digite o código completo de 6 dígitos');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final passwordService = PasswordService();

// 2. Use a instância para chamar o método
      final validationResult = await passwordService.validateResetCode(
        email: widget.email,
        code: code,
      );

      // Correção da condição aqui
      if (validationResult['valid'] == true) {
        // Verificação explícita do bool
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPasswordScreen(
              email: widget.email,
              code: code,
            ),
          ),
        );
      } else {
        setState(() =>
            _errorMessage = validationResult['message'] ?? 'Código inválido');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Erro na validação: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificação de Código'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.verified_user,
              size: 80,
              color: PrimaryColor,
            ),
            const SizedBox(height: 24),
            const Text(
              'Verificação de Código',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Enviamos um código de 6 dígitos para ${widget.email}',
              textAlign: TextAlign.center,
              style: TextStyle(color: OffColor),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 45,
                  child: TextFormField(
                    controller: _codeControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _onCodeChanged(index, value),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: OffColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: lightColor)
                  : const Text('Verificar Código'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Reenviar código
              },
              child: const Text('Não recebeu o código? Reenviar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
