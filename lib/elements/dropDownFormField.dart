import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';


class DropDownFormField extends StatefulWidget {
  final String title;
  final String hint;
  final SingleValueDropDownController controller;
  final Map<String, String> map;
  const DropDownFormField({super.key, required this.title, required this.hint, required this.controller, required this.map});

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
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        DropDownTextField(
          controller: widget.controller,
          textFieldDecoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                      style: BorderStyle.solid
                  )
              ),
              isDense: true
          ),
          clearOption: true,
          enableSearch:false,
          clearIconProperty: IconProperty(color: Colors.green),
          searchTextStyle: const TextStyle(color: Colors.red),
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
        const SizedBox(height: 5,),
      ],
    );
  }
}
