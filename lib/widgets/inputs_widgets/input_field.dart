import 'package:flutter/material.dart';

import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;


  const InputField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.readOnly = false
  }) : super(key: key);

  @override
  State<InputField> createState() => _PrimaryInputFieldState();
}

class _PrimaryInputFieldState extends State<InputField> {

  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.heightSize * 0.7
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.widthSize * 1.2,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            color: focusNode!.hasFocus
                ? CustomColor.primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.1),
            width: 1
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: widget.readOnly,
              controller: widget.controller,
              style: CustomStyle.primaryTextStyle.copyWith(fontSize: Dimensions.defaultTextSize * 1.6),
              textAlign: TextAlign.left,
              onTap: (){
                setState(() {
                  focusNode!.requestFocus();
                });
              },
              onFieldSubmitted: (value){
                setState(() {
                  focusNode!.unfocus();
                });
              },
              focusNode: focusNode,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: widget.hintText,
                  labelStyle: TextStyle(
                    color: focusNode!.hasFocus
                        ? CustomColor.primaryColor.withOpacity(0.2)
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    fontSize: Dimensions.defaultTextSize * 2,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
              ),

            ),
          ),
          Visibility(
            visible: widget.readOnly,
            child: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}
