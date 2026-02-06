import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:roastcalc/theme_extension.dart';

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
            Text(
              'RoastCalc🔥',
              style: context.textTheme.headlineMedium!.copyWith(
                fontWeight: .bold, // emphasize
                color: context.colorScheme.primary,
              ),
            ),
            // small text for version info
            Text('v0.6.5', style: context.textTheme.labelSmall),
          ],
        ),
        content: Wrap(
          children: [
            Text('Made with 🤍. Check out my: '),
            // when tapped trigger going to my github through device browser
            GestureDetector(
              onTap: () => _launchGithub(), // handler function
              child: Text(
                'Github',
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: .bold, // emphasize
                  color: context.colorScheme.primary, // highlight
                ),
              ),
            ),
          ],
        ),
        // dismiss by button or tapping outside popup boundaires
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'CLOSE',
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: .bold, // emphasize
                color: context.colorScheme.error, // red
              ),
            ),
          ),
        ],
      );
    },
  );
}
