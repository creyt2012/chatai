import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

import '../../utils/assets.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';

class SendInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onTap, voiceTab;
  final Widget icon;

  const SendInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.onTap,
    this.voiceTab,
  }) : super(key: key);

  @override
  State<SendInputField> createState() => _SendInputFieldState();
}

class _SendInputFieldState extends State<SendInputField> {
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.widthSize * 1.2,
        vertical: Dimensions.heightSize * 1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: Dimensions.widthSize * 1.2,
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
              child: TextFormField(
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
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: focusNode!.hasFocus
                        ? CustomColor.primaryColor.withOpacity(0.2)
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    fontSize: Dimensions.defaultTextSize * 2,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,

                  suffixIcon: IconButton(
                     onPressed: widget.voiceTab,
                      icon: widget.icon
                  )
                ),

              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onTap,
              child: Animator<double>(
                  duration: const Duration(milliseconds: 1000),
                  cycles: 0,
                  curve: Curves.easeInOut,
                  tween: Tween<double>(begin: 15.0, end: 25.0),
                  builder: (context, animatorState, child) => Image.asset(
                      Assets.send2,
                  )
              )
            ),
          ),

        ],
      ),
    );
  }
}
