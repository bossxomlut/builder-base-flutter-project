import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../route/app_router.gr.dart';
import '../../widget/index.dart';
import '../utils/base_state.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginCubit, LoginState> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: LText(''),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        const Text('Login Page'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            cubit.login();
          },
          child: const Text('Login'),
        ),
      ],
    );
  }

  @override
  void onStateChange(LoginState state) {
    state.whenOrNull(
      loading: () {
        showLoading();
      },
      success: () {
        context.router.replace(HomeRoute());
      },
    );
  }
}
