import 'package:dart_markdown/dart_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';


import '../../home_screen/comfy_user_information_function/lesson_function.dart';
import '../../universal_widget/random_widget_loading.dart';

class MarkdownRenderer extends StatelessWidget {
  const MarkdownRenderer({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    print('markdown path is $path}');
    return FutureBuilder(
        future: lessonMarkdownRender(path),
        builder: (context, snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return randomLoadingWidget();
          }
          else{
            final markdown = Markdown(
              // The options with default value `true`.
              enableAtxHeading: true,
              enableBlankLine: true,
              enableBlockquote: true,
              enableIndentedCodeBlock: true,
              enableFencedBlockquote: true,
              enableFencedCodeBlock: true,
              enableList: true,
              enableParagraph: true,
              enableSetextHeading: true,
              enableTable: true,
              enableHtmlBlock: true,
              enableLinkReferenceDefinition: true,
              enableThematicBreak: true,
              enableAutolinkExtension: true,
              enableAutolink: true,
              enableBackslashEscape: true,
              enableCodeSpan: true,
              enableEmoji: true,
              enableEmphasis: true,
              enableHardLineBreak: true,
              enableImage: true,
              enableLink: true,
              enableRawHtml: true,
              enableSoftLineBreak: true,
              enableStrikethrough: true,

              // The options with default value `false`.
              enableHeadingId: false,
              enableHighlight: false,
              enableFootnote: false,
              enableTaskList: false,
              enableSubscript: false,
              enableSuperscript: false,
              enableKbd: false,
              forceTightList: false,

              // Customised syntaxes.
              extensions: const <Syntax>[],
            );
            print('snapshot data is ${snapshot.data.toString()}');
            // AST nodes.
            final nodes = markdown.parse(snapshot.data!);

            final html = nodes.toHtml(
              enableTagfilter: false,
              encodeHtml: true,
            );
            print(html);
            return Expanded(
              child: HtmlWidget(
                html,

              )
              /*MarkdownBlock(
                data: snapshot.data!,
              )
              MarkdownBody(
                shrinkWrap: true,

                data: snapshot.data!,
              ),*/
            );
          }
        }
    );
  }
}