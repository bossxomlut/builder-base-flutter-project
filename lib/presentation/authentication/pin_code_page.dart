import 'package:flutter/material.dart';

import '../../domain/use_case/login_use.dart';
import '../../injection/injection.dart';
import '../../resource/index.dart';
import '../../route/app_router.dart';
import '../../route/app_router.gr.dart';
import '../../widget/index.dart';
import '../utils/index.dart';
import 'widget/number_pad.dart';
import 'widget/pin_code.dart';

const int maxPinLength = 4;

@RoutePage()
class PinCodePage extends StatefulWidget {
  const PinCodePage({super.key});

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> with StateTemplate<PinCodePage> {
  final ValueNotifier<String> _pinNotifier = ValueNotifier<String>('');
  final ValueNotifier<bool> _errorNotifier = ValueNotifier<bool>(false);
  final GlobalKey<NumberPadState> _numberPadKey = GlobalKey<NumberPadState>();

  final LoginUseCase _loginUseCase = getIt.get();

  @override
  void initState() {
    super.initState();
    _pinNotifier.addListener(_onPinChanged);
  }

  void _onPinChanged() {
    _errorNotifier.value = false;

    if (_pinNotifier.value.length == maxPinLength) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          // Xử lý mã PIN
          _loginUseCase.execute(_pinNotifier.value).then((_) {
            // Xử lý thành công
            appRouter.goHome();
          }).catchError((error) {
            // Xử lý lỗi
            _pinNotifier.value = '';
            _numberPadKey.currentState?.resetPad();
            _errorNotifier.value = true;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _pinNotifier.removeListener(_onPinChanged);
    _pinNotifier.dispose();
    _errorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LText(LKey.inputPinCode, style: theme.textTheme.headlineMedium),
                const Gap(40),
                // Hiển thị các ô tròn mã PIN
                ValueListenableBuilder<String>(
                  valueListenable: _pinNotifier,
                  builder: (context, pin, _) {
                    return Center(child: PinCodeWidget(pin));
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _errorNotifier,
                  builder: (context, error, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: !error
                          ? Text('')
                          : LText(
                              LKey.wrongPinCode,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                    );
                  },
                ),
                const Gap(16),
                // Link Quên mật khẩu
                InkWell(
                  onTap: () {
                    appRouter.push(ForgotPinCodeRoute());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LText(LKey.forgotPinCode,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bàn phím số
        NumberPad(
          key: _numberPadKey,
          onChanged: _onNumberPressed,
        ),
      ],
    );
  }

  void _onNumberPressed(String number) {
    if (number.length <= maxPinLength) {
      _pinNotifier.value = number;
    }
  }
}
