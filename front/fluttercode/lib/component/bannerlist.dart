import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerList extends StatelessWidget {
  final String imageUrl;
  final String? redirectUrl;
  final bool isInternalRedirect; // Define se o redirecionamento é interno
  final Widget? widgetRoute;

  const BannerList({
    super.key,
    required this.imageUrl,
    this.redirectUrl,
    required this.isInternalRedirect,
    this.widgetRoute,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula a altura com base na largura da tela para manter a proporção 16:9
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerHeight = (screenWidth * 9) / 16;

    return GestureDetector(
      onTap: () {
        if (isInternalRedirect) {
          // Navegar para uma tela interna
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  widgetRoute!, // Substitua pelo widget da tela interna
            ),
          );
        } else {
          // Abrir URL externa no navegador
          _launchURL(redirectUrl ?? "");
        }
      },
      child: Container(
        width: screenWidth, // Ocupar 100% da largura da tela
        height:
            containerHeight, // Altura calculada para manter a proporção 16:9
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Bordas arredondadas
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.2), // Sombra para dar profundidade
              blurRadius: 5,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(15), // Bordas arredondadas no conteúdo
          child: Image.network(
            imageUrl,
                    width: screenWidth,
            height: containerHeight,
            fit: BoxFit.cover, // Faz a imagem preencher todo o espaço
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          (progress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(
                Icons.broken_image,
                color: Colors.grey,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Função para abrir URLs externas
  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
