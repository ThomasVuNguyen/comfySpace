
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

Widget comfyBubbleBuilder(
    Widget child, {
      required message,
      required nextMessageInGroup,
      required user,
    }) =>
    Bubble(
      color: user.id != message.author.id ||
          message.type == types.MessageType.image
          ? const Color(0xfff5f5f7)
          : const Color(0xff6f61e8),
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : user.id != message.author.id
          ? BubbleNip.leftBottom
          : BubbleNip.rightBottom,
      child: child,
    );