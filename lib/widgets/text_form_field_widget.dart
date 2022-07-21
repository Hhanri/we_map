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

class WaterLevelParameters extends TextFormParameters{
  WaterLevelParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    label: "Water Level",
    maxLines: 1,
    validator: (value) {
      if (double.tryParse(value ?? "") != null) {
        return null;
      }
      return "Not a number";
    },
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
    ]
  );
}

class LatitudeParameters extends TextFormParameters{
  LatitudeParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    label: "Latitude",
    maxLines: 1,
    validator: (value) {
      if (double.tryParse(value ?? "") != null) {
        return null;
      }
      return "Not a number";
    },
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
    ]
  );
}

class LongitudeParameters extends TextFormParameters{
  LongitudeParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    label: "Longitude",
    maxLines: 1,
    validator: (value) {
      if (double.tryParse(value ?? "") != null) {
        return null;
      }
      return "Not a number";
    },
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
    ]
  );
}

class StreetNameParameters extends TextFormParameters{
  StreetNameParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    label: "Street Name",
    maxLines: 1,
    validator: (value) => null,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
    ]

  );
}

class NoteParameters extends TextFormParameters {
  NoteParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    label: "Note",
    maxLines: 13,
    validator: (value) => null,
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
    label: 'Email',
    maxLines: 1,
    validator: (value) {
      if (value.isEmail()) return null;
      return 'Not valid email';
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
    label: 'Password',
    maxLines: 1,
    validator: (value) {
      return value!.length >= 6 ? null : 'Password too short, needs at least 6 characters';
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
    label: 'Password',
    maxLines: 1,
    validator: (value) {
      if (value!.length < 6) return 'Password too short, needs at least 6 characters';
      if (value != mainController.text) return 'Password not matching';
      return null;
    },
    keyboardType: TextInputType.visiblePassword,
    inputFormatters: [
      FilteringTextInputFormatter.singleLineFormatter,
    ]
  );
}