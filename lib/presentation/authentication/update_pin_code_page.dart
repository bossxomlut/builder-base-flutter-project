import 'package:flutter/material.dart';

import '../../domain/index.dart';
import '../../injection/injection.dart';
import '../../resource/index.dart';
import '../../widget/index.dart';
import '../utils/index.dart';
import 'pin_code_page.dart';
import 'widget/number_pad.dart';
import 'widget/pin_code.dart';

@RoutePage()
class UpdatePinCodePage extends StatefulWidget {
  const UpdatePinCodePage({super.key});

  @override
  State<UpdatePinCodePage> createState() => _UpdatePinCodePageState();
}

class _UpdatePinCodePageState extends State<UpdatePinCodePage>
    with SingleTickerProviderStateMixin, StateTemplate<UpdatePinCodePage> {
  final GlobalKey<NumberPadState> _numberPadKey = GlobalKey<NumberPadState>();

  final UpdatePinCodeUseCase _updatePinCodeUseCase = getIt.get<UpdatePinCodeUseCase>();

  String _existingPin = '';
  String _newPin = '';

  void resetNumPadPin() {
    _numberPadKey.currentState?.resetPad();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: LKey.updatePinCode.tr(),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LText(LKey.enterCurrentPinCode, style: theme.textTheme.titleMedium),
                const Gap(8),
                PinCodeWidget(
                  _existingPin,
                  showPin: true,
                ),
                const Gap(40),
                LText(LKey.enterNewPinCode, style: theme.textTheme.titleMedium),
                const Gap(8),
                PinCodeWidget(
                  _newPin,
                  showPin: true,
                  isDisabled: _existingPin.length < maxPinLength,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FilledButton(
            onPressed: !isFormValid
                ? null
                : () {
                    _updatePinCodeUseCase.execute(
                      UpdatePinCodeParamEntity(
                        confirmPin: _existingPin,
                        newPin: _newPin,
                      ),
                    );
                  },
            child: const LText(LKey.update),
          ),
        ),
        NumberPad(
          key: _numberPadKey,
          maxLength: maxPinLength * 2,
          onChanged: (String value) {
            if (value.length < maxPinLength) {
              _existingPin = value;
              _newPin = '';
              setState(() {});
            } else {
              _existingPin = value.substring(0, maxPinLength);
              _newPin = value.substring(maxPinLength, value.length);

              setState(() {});
            }
          },
        ),
      ],
    );
  }

  bool get isFormValid => _existingPin.length == maxPinLength && _newPin.length == maxPinLength;
}
