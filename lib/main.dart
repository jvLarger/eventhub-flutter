import 'dart:io';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/config/themes/app_theme.dart';
import 'package:eventhub/db/usuario_db.dart';
import 'package:eventhub/firebase_options.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/presentation/views/auth/login/login_page.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/eventos_destaque_page.dart';
import 'package:eventhub/presentation/views/ipconfig/ipconfig_page.dart';
import 'package:eventhub/services/firebase/firebase_messaging_service.dart';
import 'package:eventhub/services/firebase/notification_service.dart';
import 'package:eventhub/services/usuario/usuario_service.dart';
import 'package:eventhub/utils/singleton.dart';
import 'package:eventhub/utils/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = 'pk_live_51NPsQ2APLSZyFJm2dV4ym62fHSyzdsR3jY78BDYcsjCZJGK9BCy312yLqwj9qcHOIWghEiHGWm0qk1AsbuRaPqjz00cfaRDS6X';
  await Stripe.instance.applySettings();

  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationService>(
          create: (context) => NotificationService(),
        ),
        Provider<FirebaseMessagingService>(
          create: (context) => FirebaseMessagingService(context.read<NotificationService>()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Event Hub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
      ),
    ),
  );
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const EventHubApp(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (_, __) => Scaffold(
            appBar: AppBar(title: const Text('Details Screen')),
          ),
        ),
        GoRoute(
          path: 'ipconfig',
          builder: (_, __) => IpConfigPage(),
        ),
      ],
    ),
  ],
);

class EventHubApp extends StatefulWidget {
  const EventHubApp({super.key});

  @override
  State<EventHubApp> createState() => _EventHubAppState();
}

class _EventHubAppState extends State<EventHubApp> {
  Future<UsuarioAutenticado?> validarUsuarioLogado() async {
    print("Host utilizado: " + EventhubSingleton().getHost());
    try {
      UsuarioAutenticado? usuarioAutenticado = await UsuarioDB().buscarUsuario();
      if (usuarioAutenticado != null) {
        bool isTokenValido = await UsuarioService().isTokenValido(usuarioAutenticado.token!);

        if (!isTokenValido) {
          await UsuarioDB().removerUsuario();
          usuarioAutenticado = null;
        } else {
          Api.apiKey = usuarioAutenticado.token!;
          usuarioAutenticado = await UsuarioService().tratarIdentificadorNotificacao(usuarioAutenticado);
        }
      }

      return usuarioAutenticado;
    } on SocketException {
      Util.showSnackbarError(context, "Não foi possível se conectar com esse host");
      Util.goToAndOverride(context, const IpConfigPage());
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    initilizeFirebaseMessaging();
    checkNotifications();
  }

  initilizeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false).checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
    );
  }
}
