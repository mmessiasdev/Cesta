import 'package:NIDE/component/buttons.dart';
import 'package:NIDE/component/padding.dart';
import 'package:NIDE/component/texts.dart';
import 'package:NIDE/env.dart';
import 'package:NIDE/view/students/addbaskets.dart';
import 'package:flutter/material.dart';
import 'package:NIDE/model/students.dart';
import 'package:NIDE/component/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;
  final String token;
  final int profileId;

  const StudentDetailScreen(
      {Key? key,
      required this.student,
      required this.token,
      required this.profileId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        title: Text(student.name),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de informações pessoais
                _buildPersonalInfoSection(),
                const SizedBox(height: 24),
                GestureDetector(
                  child: DefaultButton(
                    text: "Adicionar Cestá básica",
                    padding: defaultPadding,
                    color: PrimaryColor,
                    colorText: lightColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBasketScreen(
                          token: token,
                          studentId: student.id, // ID do aluno
                          profileId: profileId,
                        ),
                      ),
                    ).then((success) {
                      if (success == true) {
                        // Atualize a lista de cestas se necessário
                      }
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Seção de cestas
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
                  student.name[0],
                  style: const TextStyle(fontSize: 40, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailItem('Nome completo', student.name),
            _buildDetailItem('Nome do pai', student.father ?? 'Não informado'),
            _buildDetailItem('CPF', _formatCPF(student.cpf)),
            _buildDetailItem('Telefone', _formatPhone(student.phonenumber)),
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

  // Adicione estas funções na sua classe _AddBasketScreenState

// Formata CPF (000.000.000-00)
  String _formatCPF(String cpf) {
    if (cpf.length != 11) return cpf;
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

// Formata telefone ((00) 00000-0000)
  String _formatPhone(String phone) {
    if (phone.length == 11) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 7)}-${phone.substring(7)}';
    } else if (phone.length == 10) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 6)}-${phone.substring(6)}';
    }
    return phone;
  }

// Formata data para o padrão brasileiro (dd/MM/yyyy)
  String _formatBirthDate(String birthDate) {
    try {
      final date = DateTime.parse(birthDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return birthDate;
    }
  }

// Formata data e hora para o fuso horário brasileiro (dd/MM/yyyy HH:mm:ss)
  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  Widget _buildBasketsSection(context) {
    // Ordena as cestas por data (da mais recente para a mais antiga)
    final sortedBaskets = student.baskets.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (sortedBaskets.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Nenhuma cesta registrada',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cestas Básicas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        ...sortedBaskets
            .map((basket) => _buildBasketCard(basket, context))
            .toList(),
      ],
    );
  }

  Widget _buildBasketCard(Basket basket, BuildContext context) {
    final isMostRecent = student.baskets
            .map((b) => b.createdAt)
            .toList()
            .reduce((a, b) => a.compareTo(b) > 0 ? a : b) ==
        basket.createdAt;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isMostRecent ? 4 : 1,
      shape: isMostRecent
          ? RoundedRectangleBorder(
              side: BorderSide(color: Colors.blue.shade200, width: 1),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_basket,
                  size: 20,
                  color: isMostRecent ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(basket.createdAt),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isMostRecent ? FontWeight.bold : FontWeight.w500,
                    color: isMostRecent ? Colors.blue : Colors.grey.shade700,
                  ),
                ),
                if (isMostRecent) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'MAIS RECENTE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getTimeAgo(basket.createdAt),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            if (basket.comprovants.isNotEmpty) ...[
              Text(
                'Comprovantes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: basket.comprovants
                    .map((comprovant) =>
                        _buildComprovantThumbnail(comprovant, context))
                    .toList(),
              ),
              const SizedBox(height: 20),
              SubText(
                text: "Usuário cadastrador: ${basket.profile}",
                align: TextAlign.start,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return '· Hoje';
      } else if (difference.inDays == 1) {
        return '· Há 1 dia';
      } else if (difference.inDays < 30) {
        return '· Há ${difference.inDays} dias';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '· Há $months ${months == 1 ? 'mês' : 'meses'}';
      } else {
        final years = (difference.inDays / 365).floor();
        return '· Há $years ${years == 1 ? 'ano' : 'anos'}';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildComprovantThumbnail(Comprovant comprovant, context) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(comprovant, context),
      child: Hero(
        tag: comprovant.url, // Tag única para a animação Hero
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: EnvSecret().BASEURL + comprovant.mediumUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 100,
              height: 100,
              color: Colors.grey.shade200,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: 100,
              height: 100,
              color: Colors.grey.shade200,
              child: const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(Comprovant comprovant, context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Hero(
                  tag: comprovant.url,
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: CachedNetworkImage(
                      imageUrl: EnvSecret().BASEURL + comprovant.url,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComprovantImage(Comprovant comprovant) {
    return GestureDetector(
      onTap: () {
        // Implementar visualização ampliada da imagem se necessário
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: '${EnvSecret().BASEURL}${comprovant.mediumUrl}',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 100,
            height: 100,
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            width: 100,
            height: 100,
            color: Colors.grey.shade200,
            child: const Icon(Icons.error),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: secondary ? Colors.grey[600] : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateTimeString) {
    try {
      // Converte a string para DateTime e ajusta para o fuso horário local (Brasil)
      final dateTime = DateTime.parse(dateTimeString).toLocal();

      // Formata para o padrão brasileiro: dd/MM/yyyy HH:mm:ss
      return '${dateTime.day.toString().padLeft(2, '0')}/'
          '${dateTime.month.toString().padLeft(2, '0')}/'
          '${dateTime.year} '
          '${dateTime.hour.toString().padLeft(2, '0')}:'
          '${dateTime.minute.toString().padLeft(2, '0')}:'
          '${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      // Caso ocorra algum erro na conversão, retorna a string original
      return dateTimeString;
    }
  }
}
