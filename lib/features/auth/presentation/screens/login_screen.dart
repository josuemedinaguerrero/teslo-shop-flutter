import 'package:flutter/material.dart';

import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const Icon(
                  Icons.production_quantity_limits_rounded,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(height: 80),
                Container(
                  height: size.height - 260, // 80 los dos sizebox y 100 el ícono
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _LoginForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);
    ref.listen(
      authProvider,
      (previous, next) {
        if (next.errorMessage.isEmpty) return;
        showSnackbar(context, next.errorMessage);
      },
    );
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Login', style: textStyles.titleLarge),
          CustomTextFormField(
            label: 'Correo',
            onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
            keyboardType: TextInputType.emailAddress,
            errorMessage: loginForm.email.errorMessage,
          ),
          CustomTextFormField(
            label: 'Contraseña',
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
            errorMessage: loginForm.password.errorMessage,
            obscureText: true,
          ),
          SizedBox(height: 100),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: Colors.black,
              onPressed: () => ref.read(loginFormProvider.notifier).onFormSubmit(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(onPressed: () => context.push('/register'), child: const Text('Crea una aquí'))
            ],
          ),
        ],
      ),
    );
  }
}
