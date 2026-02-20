import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:roastcalc/services/theme_extension.dart';

// my github link
final Uri _url = Uri.parse('https://github.com/ruchirraina');

// trigger going to my github through device browser
Future<void> _launchGithub() async {
  if (!await launchUrl(_url)) return;
}

// dialog popup info about app and me
void showInfoPopUp(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogcontext) {
      return AlertDialog(
        // app info
        title: Column(
          crossAxisAlignment: .start,
          children: [
            // app name
            FittedBox(
              fit: .scaleDown,
              child: Text(
                'RoastCalc🔥',
                style: context.textTheme.headlineMedium!.copyWith(
                  fontWeight: .bold, // emphasize
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            // small text for version info
            FittedBox(
              fit: .scaleDown,
              child: Text('v1.0.0', style: context.textTheme.labelSmall),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    'Do math. Get roasted. Gemini-powered, history-based burns\nMade with 🤍.\nCheck out my: ',
                style: context.textTheme.bodyMedium,
              ),
              // when tapped trigger going to my github through device browser
              TextSpan(
                text: 'Github',
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: .bold, // emphasize
                  color: context.colorScheme.primary, // highlight
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _launchGithub(),
              ),
            ],
          ),
        ),
        // dismiss by button or tapping outside popup boundaires
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: FittedBox(
              fit: .scaleDown,
              child: Text(
                'CLOSE',
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: .bold, // emphasize
                  color: context.colorScheme.error, // red
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
