import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/config/themes/app_theme.dart';
import 'package:eventhub/db/usuario_db.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/presentation/views/auth/login/login_page.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/eventos_destaque_page.dart';
import 'package:eventhub/services/usuario/usuario_service.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EventHubApp());
}

class EventHubApp extends StatefulWidget {
  const EventHubApp({super.key});

  @override
  State<EventHubApp> createState() => _EventHubAppState();
}

class _EventHubAppState extends State<EventHubApp> {
  Future<UsuarioAutenticado?> validarUsuarioLogado() async {
    try {
      UsuarioAutenticado? usuarioAutenticado =
          await UsuarioDB().buscarUsuario();

      if (usuarioAutenticado != null) {
        bool isTokenValido =
            await UsuarioService().isTokenValido(usuarioAutenticado.token!);

        if (!isTokenValido) {
          await UsuarioDB().removerUsuario();
          usuarioAutenticado = null;
        } else {
          Api.apiKey = usuarioAutenticado.token!;
        }
      }

      return usuarioAutenticado;
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: FutureBuilder(
        future: validarUsuarioLogado(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.data == null) {
              return const LoginPage();
            } else {
              return EventosDestaquePage(
                usuarioAutenticado: snapshot.data!,
              );
            }
          }
        },
      ),
    );
  }
}
