import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future<bool?> dialogShow(BuildContext context, String title, String message,
    {String falseText = "Cancel", String trueText = "OK"}) async {
  return await showDialog<bool>(
    barrierDismissible: true,
    context: context,
    builder: (context) => Center(
      child: NeoBruteBorder(
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10), child: Text(message)),
                Gap(10),
                Row(
                  children: [
                    Expanded(
                      child: _BottomButton(
                        text: falseText,
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ),
                    Expanded(
                      child: _BottomButton(
                        text: trueText,
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        showSideBorder: false,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.text,
    required this.onTap,
    this.showSideBorder = true,
  });

  final String text;
  final VoidCallback onTap;
  final bool showSideBorder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 2,
              color: Colors.black,
            ),
            right: showSideBorder
                ? BorderSide(
                    width: 2,
                    color: Colors.black,
                  )
                : BorderSide.none,
          ),
        ),
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Text(text),
      ),
    );
  }
}
