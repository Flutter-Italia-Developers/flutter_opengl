import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_opengl/flutter_opengl.dart';
import 'package:flutter_opengl_example/controls.dart';
import 'package:flutter_opengl_example/edit_shader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controls_texture.dart';
import 'states.dart';
import 'test_widget.dart';

void main() {
  OpenGLController().initializeGL();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textureSize = ref.watch(stateTextureSize);
    final textureId = ref.watch(stateTextureId);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                /// FPS and ShaderToy URL text
                const UpperText(),
                const SizedBox(height: 8),

                /// TEXTURE
                AspectRatio(
                  aspectRatio:
                      textureSize.width / textureSize.height,
                  child: textureId == -1
                    ? const ColoredBox(color: Colors.red)
                    : OpenGLTexture(id: textureId)
                ),

                const SizedBox(
                  height: 40,
                  child: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: 'shaders'),
                      Tab(text: 'edit shader'),
                      Tab(text: 'test 1'),
                      Tab(text: 'test 2'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// TABS
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Controls(),
                      const EditShader(),
                      const TestWidget(shaderToyCode: 'ls3cDB'),
                      const TestWidget(shaderToyCode: 'XdXGR7'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// FPS, texture size and shader URL
///
class UpperText extends ConsumerWidget {
  const UpperText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fps = ref.watch(stateFPS);
    final shaderUrl = ref.watch(stateUrl);
    final textureSize = ref.watch(stateTextureSize);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
            '$fps\n${textureSize.width.toInt()} x '
                '${textureSize.height.toInt()}',
            textScaleFactor: 1.3),
        const SizedBox(width: 30),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: shaderUrl,
                style: const TextStyle(
                    decoration:
                    TextDecoration.underline,
                    fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse(shaderUrl));
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}