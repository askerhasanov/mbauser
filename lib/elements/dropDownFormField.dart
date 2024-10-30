import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/globalVariables.dart';


class DropDownFormField extends StatefulWidget {
  final String title;
  final String hint;
  final bool isColumnar;
  final SingleValueDropDownController controller;
  final Map<String, String> map;
  const DropDownFormField({super.key, required this.title, required this.hint, required this.controller, required this.map, required this.isColumnar});

  @override
  State<DropDownFormField> createState() => _DropDownFormFieldState();
}

List<DropDownValueModel> dropdownListFromMap(Map<String, String> map) {
  if (map.isNotEmpty) {
    return map.entries.map((entry) => DropDownValueModel(name: entry.key, value: entry.value)).toList();
  } else {
    return [const DropDownValueModel(name: '', value: '')];
  }
}

class _DropDownFormFieldState extends State<DropDownFormField> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.isColumnar) ?
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ):
            Container(),
        const SizedBox(
          height: 5,
        ),
        DropDownTextField(
          controller: widget.controller,
          textFieldDecoration: InputDecoration(
              hintText: widget.hint,
              filled: true,
              fillColor: MbaColors.white,
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.transparent
                )
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Colors.transparent
                  )
              ),
              isDense: true
          ),
          clearOption: true,
          enableSearch:false,
          clearIconProperty: IconProperty(color: MbaColors.red),
          searchTextStyle: const TextStyle(color: MbaColors.dark),
          searchDecoration: InputDecoration(
              hintText: widget.hint
          ),
          validator: (value) {
            if (value == null) {
              return "Required field";
            } else {
              return null;
            }
          },
          dropDownItemCount: dropdownListFromMap(widget.map).length,
          dropDownList: dropdownListFromMap(widget.map),
          onChanged: (val) {},
        ),
      ],
    );
  }
}
