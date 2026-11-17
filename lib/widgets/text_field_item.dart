import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/res/resources.dart';
import 'package:flutter_deer/util/input_formatter/number_text_input_formatter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

/// 封装输入框
class TextFieldItem extends StatelessWidget {

  const TextFieldItem({
    super.key,
    this.controller,
    required this.title,
    this.keyboardType = TextInputType.text,
    this.hintText = '',
    this.focusNode,
  });

  final TextEditingController? controller;
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final Row child = Row(
      children: <Widget>[
        Text(title),
        Gaps.hGap16,
        Expanded(
          child: Semantics(
            label: hintText.isEmpty ? '请输入$title' : hintText,
            child: TextField(
              focusNode: focusNode,
              keyboardType: keyboardType,
              inputFormatters: _getInputFormatters(),
              controller: controller,
              //style: TextStyles.textDark14,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none, //去掉下划线
                //hintStyle: TextStyles.textGrayC14
              ),
            ),
          ),
        ),
        Gaps.hGap16
      ],
    );
    
    Widget result = Container(
      height: 50.0,
      margin: const EdgeInsets.only(left: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context, width: 0.6),
        ),
      ),
      child: child,
    );

    /// keyboard_actions 5.0：iOS 键盘工具条改为 KeyboardField 包裹输入框
    /// （无 KeyboardActions 祖先时为 no-op，不影响其他平台与页面）
    if (focusNode != null) {
      result = KeyboardField(focusNode: focusNode, child: result);
    }
    return result;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (keyboardType == const TextInputType.numberWithOptions(decimal: true)) {
      return <TextInputFormatter>[UsNumberTextInputFormatter()];
    }
    if (keyboardType == TextInputType.number || keyboardType == TextInputType.phone) {
      return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }
}
