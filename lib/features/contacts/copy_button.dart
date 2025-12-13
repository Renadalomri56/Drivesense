import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboardButton extends StatefulWidget {
  final String textToCopy;

  const CopyToClipboardButton({super.key, required this.textToCopy});

  @override
  _CopyToClipboardButtonState createState() => _CopyToClipboardButtonState();
}

class _CopyToClipboardButtonState extends State<CopyToClipboardButton> {
  void _copyText() async {
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _copyText,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      child: Text(
        '@DriveSenseAlertsBot',
        style: TextStyle(color: Colors.black, fontSize: 12),
      ),
    );
  }
}
