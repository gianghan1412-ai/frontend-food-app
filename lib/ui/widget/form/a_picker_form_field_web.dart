import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_order_food/ui/config/app_style.dart';
import 'package:project_order_food/ui/shared/app_color.dart';
import 'package:project_order_food/ui/widget/a_button.dart';

class APickerFormField extends FormField<Uint8List> {
  APickerFormField({
    super.key,
    FormFieldSetter<Uint8List>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(
          onSaved: onSaved,
          validator: (v) {
            if (v == null) {
              return 'Bạn buộc phải chọn ảnh';
            }
            return null;
          },
          autovalidateMode: autovalidateMode,
          builder: (state) {
            return _ItemButtonPicker(state);
          },
        );
}

class _ItemButtonPicker extends StatelessWidget {
  const _ItemButtonPicker(this.state);

  final FormFieldState<Uint8List> state;

  Future<void> pickImage(FormFieldState<Uint8List> state) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      state.didChange(result.files.first.bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AButton(
          isExpanded: true,
          color: AColor.primary,
          onPressed: () => pickImage(state),
          child: state.value == null
              ? AText.body('Chọn hình ảnh')
              : Image.memory(
                  state.value!,
                  height: 120,
                  fit: BoxFit.cover,
                ),
        ),
        if (state.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: AText.caption(state.errorText!, color: AColor.red),
          ),
      ],
    );
  }
}
