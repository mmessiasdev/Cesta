import 'package:Cesta/component/buttons.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/env.dart';
import 'package:Cesta/view/students/addbaskets.dart';
import 'package:flutter/material.dart';
import 'package:Cesta/model/students.dart';
import 'package:Cesta/component/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;
  final String token;
  final int profileId;

  const StudentDetailScreen({
    Key? key,
    required this.student,
    required this.token,
    required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        title: Text(student.name ?? 'Detalhes do Aluno'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPersonalInfoSection(),
                const SizedBox(height: 24),
                GestureDetector(
                  child: DefaultButton(
                    text: "Adicionar Cesta básica",
                    padding: defaultPadding,
                    color: PrimaryColor,
                    colorText: lightColor,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBasketScreen(
                          token: token,
                          studentId:
                              student.id ?? 0, // Adicionado fallback para id
                          profileId: profileId,
                        ),
                      ),
                    ).then((success) {
                      if (success == true) {
                        // Atualizar lógica se necessário
                      }
                    });
                  },
                ),
                const SizedBox(height: 24),
                _buildBasketsSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  (student.name?.isNotEmpty ?? false) ? student.name![0] : '?',
                  style: const TextStyle(fontSize: 40, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailItem('Nome completo', student.name ?? 'Não informado'),
            _buildDetailItem(
                'Nome do pai',
                (student.father?.isNotEmpty ?? false)
                    ? student.father!
                    : 'Não informado'),
            _buildDetailItem(
                'Nome da mãe',
                (student.mother?.isNotEmpty ?? false)
                    ? student.mother!
                    : 'Não informado'),
            _buildDetailItem('CPF', _formatCPF(student.cpf)),
            _buildDetailItem('Telefone', _formatPhone(student.phonenumber)),
            _buildDetailItem('Bairro', _formatPhone(student.neighborhood)),
            _buildDetailItem('Endereço', _formatPhone(student.address)),
            _buildDetailItem(
                'Data de nascimento', _formatBirthDate(student.birth)),
            const Divider(height: 30),
            _buildDetailItem(
                'Data de cadastro', _formatDateTime(student.createdAt),
                secondary: true),
            _buildDetailItem(
                'Última atualização', _formatDateTime(student.updatedAt),
                secondary: true),
          ],
        ),
      ),
    );
  }

  String _formatCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty || cpf.length != 11)
      return cpf ?? 'Não informado';
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  String _formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return 'Não informado';
    if (phone.length == 11) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 7)}-${phone.substring(7)}';
    } else if (phone.length == 10) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 6)}-${phone.substring(6)}';
    }
    return phone;
  }

  String _formatBirthDate(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return 'Não informado';
    try {
      final date = DateTime.parse(birthDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return birthDate;
    }
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty)
      return 'Não informado';
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  Widget _buildBasketsSection(BuildContext context) {
    final sortedBaskets = (student.baskets ?? []).toList()
      ..sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));

    if (sortedBaskets.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text('Nenhuma cesta registrada',
                style: TextStyle(color: Colors.grey.shade600)),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cestas Básicas',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800)),
        const SizedBox(height: 8),
        ...sortedBaskets
            .map((basket) => _buildBasketCard(basket, context))
            .toList(),
      ],
    );
  }

  Widget _buildBasketCard(Basket basket, BuildContext context) {
    final isMostRecent = (student.baskets ?? [])
            .map((b) => b.createdAt)
            .reduce((a, b) => (a ?? '').compareTo(b ?? '') > 0 ? a : b) ==
        basket.createdAt;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isMostRecent ? 4 : 1,
      shape: RoundedRectangleBorder(
        side: isMostRecent
            ? BorderSide(color: Colors.blue.shade200, width: 1)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shopping_basket,
                size: 20, color: isMostRecent ? Colors.blue : Colors.grey),
            const SizedBox(height: 8),
            Text(
              _formatDate(basket.createdAt),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isMostRecent ? FontWeight.bold : FontWeight.w500,
                  color: isMostRecent ? Colors.blue : Colors.grey.shade700),
            ),
            if (isMostRecent)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('MAIS RECENTE',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                      const SizedBox(width: 4),
                      Text(_getTimeAgo(basket.createdAt),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.blue)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (basket.comprovants?.isNotEmpty ?? false) ...[
              Text('Comprovantes',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (basket.comprovants ?? [])
                    .map((c) => _buildComprovantThumbnail(c, context))
                    .toList(),
              ),
            ]
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty)
      return 'Não informado';
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  String _getTimeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      if (difference.inDays == 0) return '· Hoje';
      if (difference.inDays == 1) return '· Há 1 dia';
      if (difference.inDays < 30) return '· Há ${difference.inDays} dias';
      if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '· Há $months ${months == 1 ? 'mês' : 'meses'}';
      }
      final years = (difference.inDays / 365).floor();
      return '· Há $years ${years == 1 ? 'ano' : 'anos'}';
    } catch (_) {
      return '';
    }
  }

  Widget _buildComprovantThumbnail(
      Comprovant comprovant, BuildContext context) {
    final mediumUrl = comprovant.mediumUrl?.toString() ?? '';
    final url = comprovant.smallUrl ?? '';

    return GestureDetector(
      onTap: () => _showFullScreenImage(comprovant, context),
      child: Hero(
        tag: url,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: EnvSecret().BASEURL + url,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(Comprovant comprovant, BuildContext context) {
    final url = comprovant.url ?? '';
    if (url.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Hero(
                tag: url,
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: CachedNetworkImage(
                    imageUrl: EnvSecret().BASEURL + url,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => const Icon(Icons.error),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value,
      {bool secondary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: secondary ? Colors.grey[600] : Colors.grey[800])),
        ],
      ),
    );
  }
}
