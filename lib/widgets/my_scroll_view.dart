
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deer/util/other_utils.dart';
import 'package:flutter_deer/util/theme_utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

/// 本项目通用的布局（SingleChildScrollView）
/// 1.底部存在按钮
/// 2.底部没有按钮
class MyScrollView extends StatelessWidget {

  /// 注意：同时存在底部按钮与keyboardActions配置时，为保证软键盘弹出高度正常。需要在`Scaffold`使用 `resizeToAvoidBottomInset: defaultTargetPlatform != TargetPlatform.iOS,`
  /// 除非Android与iOS平台均使用keyboard_actions
  ///
  /// keyboard_actions 5.0：iOS 键盘工具条不再通过 config 注册 FocusNode，
  /// 而是输入框组件内部用 `KeyboardField` 包裹（见 MyTextField / TextFieldItem），
  /// 此处 `keyboardActions` 仅负责在 iOS 上启用工具条宿主。
  const MyScrollView({
    super.key,
    required this.children,
    this.padding,
    this.physics = const BouncingScrollPhysics(),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.bottomButton,
    this.keyboardActions = false,
    this.tapOutsideToDismiss = false,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics physics;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? bottomButton;
  /// iOS 是否启用键盘工具条
  final bool keyboardActions;
  /// 键盘外部按下将其关闭
  final bool tapOutsideToDismiss;

  @override
  Widget build(BuildContext context) {

    Widget contents = Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );

    contents = SingleChildScrollView(
      padding: padding,
      physics: physics,
      child: contents,
    );

    if (defaultTargetPlatform == TargetPlatform.iOS && keyboardActions) {
      /// iOS 键盘处理
      contents = KeyboardActions(
        dismissOnTapOutside: tapOutsideToDismiss,
        doneText: Utils.getCurrLocale() == 'zh' ? '关闭' : 'Close',
        theme: KeyboardActionsThemeData(
          barColor: ThemeUtils.getKeyboardActionsColor(context),
        ),
        child: contents,
      );
    }

    if (bottomButton != null) {
      contents = Column(
        children: <Widget>[
          Expanded(
            child: contents
          ),
          SafeArea(
            child: bottomButton!
          )
        ],
      );
    }

    return contents;
  }
}
