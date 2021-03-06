import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextFormParameters parameters;
  const TextFormFieldWidget({Key? key, required this.parameters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: parameters.controller,
        decoration: InputDecoration(
          label: Text(parameters.label),
          labelStyle: Theme.of(context).textTheme.bodyText2,
          filled: true,
          fillColor: AppTheme.secondaryColor,
          border: _getBorders(width: 0.2, color: AppTheme.primary2Color),
          enabledBorder: _getBorders(width: 0.2, color: AppTheme.primary2Color),
          focusedBorder: _getBorders(width: 0.8, color: AppTheme.primary2Color),
          errorBorder: _getBorders(width: 0.2, color: AppTheme.errorColor),
          focusedErrorBorder: _getBorders(width: 0.8, color: AppTheme.errorColor),
        ),
        obscureText: (parameters is PasswordParameters || parameters is PasswordConfirmationParameters) ? true : false,
        keyboardType: parameters.keyboardType,
        inputFormatters: parameters.inputFormatters,
        validator: parameters.validator,
        maxLines: parameters.maxLines,
      ),
    );
  }

  OutlineInputBorder _getBorders({required double width, required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(width: width, color: color),
    );
  }
}

class DatePickerTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  const DatePickerTextFieldWidget({Key? key, required this.controller, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        label: Text('Date')
      ),
      readOnly: true,
      onTap: onTap,
      keyboardType: TextInputType.none,
      validator: (value) {
        try {
          value.parseStringToDate();
          return null;
        } catch(e) {
          return "Wrong date format";
        }
      },
    );
  }
}

class TextFormParameters {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  List<TextInputFormatter> inputFormatters;

  TextFormParameters({
    required this.controller,
    required this.label,
    required this.maxLines,
    required this.validator,
    required this.keyboardType,
    required this.inputFormatters
  });
}

class TitleParameters extends TextFormParameters{
  TitleParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    label: AppStringsConstants.title,
    maxLines: 1,
    validator: (value) {
      if (value!.isEmpty) return AppStringsConstants.emptyField;
      return null;
    },
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
    ]
  );
}

class DescriptionParameters extends TextFormParameters {
  DescriptionParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    label: AppStringsConstants.description,
    maxLines: 13,
    validator: (value) {
      if (value!.isEmpty) return AppStringsConstants.emptyField;
      return null;
    },
    keyboardType: TextInputType.multiline,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
    ]
  );
}

class EmailParameters extends TextFormParameters {
  EmailParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    label: AppStringsConstants.email,
    maxLines: 1,
    validator: (value) {
      if (value.isEmail()) return null;
      return AppStringsConstants.notEmail;
    },
    keyboardType: TextInputType.emailAddress,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
    ]
  );
}

class PasswordParameters extends TextFormParameters {
  PasswordParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    label: AppStringsConstants.password,
    maxLines: 1,
    validator: (value) {
      return value!.length >= 6 ? null : AppStringsConstants.shortPassword;
    },
    keyboardType: TextInputType.visiblePassword,
    inputFormatters: [
      FilteringTextInputFormatter.singleLineFormatter,
    ]
  );
}

class PasswordConfirmationParameters extends TextFormParameters {
  PasswordConfirmationParameters({
    required TextEditingController mainController,
    required TextEditingController confirmationController
  }) : super(
    controller: confirmationController,
    label: AppStringsConstants.confirmPassword,
    maxLines: 1,
    validator: (value) {
      if (value!.length < 6) return AppStringsConstants.shortPassword;
      if (value != mainController.text) return AppStringsConstants.notMatching;
      return null;
    },
    keyboardType: TextInputType.visiblePassword,
    inputFormatters: [
      FilteringTextInputFormatter.singleLineFormatter,
    ]
  );
}

class UsernameParameters extends TextFormParameters{
  UsernameParameters({
    required TextEditingController controller
  }) : super(
      controller: controller,
      label: AppStringsConstants.username,
      maxLines: 1,
      validator: (value) {
        if (value!.isEmpty) return AppStringsConstants.emptyField;
        if (value.length > 20) return AppStringsConstants.tooLongUsername;
        return null;
      },
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
        FilteringTextInputFormatter.singleLineFormatter,
      ]
  );
}

class CommentTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final FocusNode node;
  const CommentTextFieldWidget({Key? key, required this.controller, required this.onSend, required this.node}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: TextField(
        focusNode: node,
        controller: controller,
        decoration: InputDecoration(
          hintText: AppStringsConstants.yourComment,
          suffixIcon: IconButton(onPressed: onSend, icon: const Icon(Icons.send))
        ),
      ),
    );
  }
}

class FakeCommentTextFieldWidget extends StatelessWidget {
  final VoidCallback onTap;
  const FakeCommentTextFieldWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: const TextField(
        enabled: false,
        decoration: InputDecoration(
          hintText: AppStringsConstants.yourComment,
        ),
      ),
    );
  }
}
