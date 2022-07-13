import 'package:we_map/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextFormParameters parameters;
  const TextFormFieldWidget({Key? key, required this.parameters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: parameters.controller,
      decoration: InputDecoration(
        label: Text(parameters.label),
        //hintText: parameters.hint,
      ),
      keyboardType: parameters.keyboardType,
      inputFormatters: parameters.inputFormatters,
      validator: parameters.validator,
      maxLines: parameters.maxLines,
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
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  List<TextInputFormatter> inputFormatters;

  TextFormParameters({
    required this.controller,
    required this.label,
    required this.hint,
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
    hint: "458974",
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
    hint: "48.974",
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
    hint: "48.974",
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
    hint: "89 rue du Pont",
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
    hint: "something to jot down",
    label: "Note",
    maxLines: 4,
    validator: (value) => null,
    keyboardType: TextInputType.multiline,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
    ]
  );
}