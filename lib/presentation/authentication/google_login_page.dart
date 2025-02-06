import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../domain/index.dart';
import '../../injection/injection.dart';
import '../../widget/index.dart';
import '../utils/index.dart';

@RoutePage()
class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> with StateTemplate<GoogleLoginPage> {
  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Đăng nhập bằng tài khoản Google',
            style: theme.textTheme.titleLarge,
          ),
          const Gap(8),
          Text(
            'Để lưu trữ dữ liệu của bạn bằng Google Drive',
            style: theme.textTheme.titleSmall,
          ),
          const Gap(16),
          SignInButton(
            Buttons.google,
            onPressed: () {
              final GoogleLoginUseCase useCase = getIt.get();

              useCase.execute(null).then(
                (value) {
                  if (value) {
                    getIt.get<CheckLoginByPinCodeUseCase>().execute(null);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
