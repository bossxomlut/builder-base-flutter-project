import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/index.dart';
import '../../injection/injection.dart';
import '../../resource/index.dart';
import '../../route/app_router.dart';
import '../../widget/index.dart';
import '../../widget/toast.dart';
import '../utils/index.dart';
import 'set_up_pin_code_page.dart';

@RoutePage()
class ForgotPinCodePage extends SetUpPinCodePage {
  const ForgotPinCodePage({super.key});

  @override
  State<SetUpPinCodePage> createState() => _ForgotPinCodePageState();
}

class _ForgotPinCodePageState extends SetUpPinCodePageState {
  final CheckSecurityQuestionUseCase checkSecurityQuestionUseCase = getIt.get<CheckSecurityQuestionUseCase>();
  int tapCount = 0;
  Timer? resetTimer;

  @override
  void initState() {
    super.initState();

    onTitleTap = () {
      // Tăng tapCount
      tapCount++;

      // Kiểm tra nếu tapCount đạt 7 lần
      if (tapCount == 7) {
        tapCount = 0; // Reset tapCount
        EncryptPinCodeWidget().show(context); // Gọi widget mã hóa
      }

      setState(() {});

      // Hủy timer cũ nếu người dùng bấm trước khi timer kết thúc
      resetTimer?.cancel();

      // Đặt lại tapCount sau 5 giây nếu không có lần bấm mới
      resetTimer = Timer(const Duration(seconds: 5), () {
        tapCount = 0;
        setState(() {});
      });
    };
  }

  @override
  void dispose() {
    resetTimer?.cancel(); // Hủy timer khi widget bị dispose
    super.dispose();
  }

  @override
  String get title => LKey.forgotPinCode.tr();

  @override
  void onQuestionAnswered(SecurityQuestionEntity question, String answer) {
    selectedQuestion = question;
    this.answer = answer;
    checkSecurityQuestionUseCase
        .execute(CheckSecurityQuestionParamEntity(
      question: selectedQuestion!,
      answer: this.answer,
    ))
        .then((value) {
      if (value) {
        tabController.animateTo(1);
      } else {
        showError(message: LKey.messageInvalidSecurityQuestion.tr());
      }
    });
  }

  @override
  void onPinCodeSet(String pin) {
    this.pin = pin;

    // Save pin code and security question
    savePinCodeUseCase.execute(
      SavePinCodeParamEntity(
        question: selectedQuestion!,
        answer: answer,
        pin: pin,
      ),
    );

    showSuccess(message: LKey.messagePinCodeSetSuccessfully.tr());

    // Navigate to pin code page
    appRouter.goToPinCodeAtTop();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        super.buildBody(context),
        if (tapCount > 3)
          Positioned(
            top: 100,
            left: 100,
            right: 100,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                tapCount.toString(),
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
      ],
    );
  }
}

class EncryptPinCodeWidget extends StatefulWidget with ShowBottomSheet {
  const EncryptPinCodeWidget({super.key});

  @override
  State<EncryptPinCodeWidget> createState() => _EncryptPinCodeWidgetState();
}

class _EncryptPinCodeWidgetState extends State<EncryptPinCodeWidget> {
  final GetEncryptPinCodeUseCase _getEncryptPinCodeUseCase = getIt.get<GetEncryptPinCodeUseCase>();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          LText(
            LKey.pinCodeEncryptDescription,
            style: theme.textTheme.labelLarge,
          ),
          Gap(16),
          FutureBuilder<String>(
              future: _getEncryptPinCodeUseCase.execute(null),
              builder: (context, snapshot) {
                final String? code = snapshot.data;
                return OutlineField(
                  label: LKey.setUpPinCode.tr(),
                  value: code ?? '---',
                  onTap: () {
                    //copy to clipboard
                    Clipboard.setData(ClipboardData(text: code ?? ''));

                    Navigator.pop(context);

                    const snackBar = SnackBar(
                      content: LText(LKey.copied),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  trailing: const Icon(LineIcons.copy),
                );
              }),
          Gap(40),
        ],
      ),
    );
  }
}
