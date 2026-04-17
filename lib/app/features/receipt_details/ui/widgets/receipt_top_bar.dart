import 'package:flutter/material.dart';

class ReceiptTopBar extends StatelessWidget {
  const ReceiptTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;

    return Container(
      height: 72 + topInset,
      padding: EdgeInsets.fromLTRB(18, topInset, 18, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE7EDF6)),
        ),
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Color(0xFF4A5468),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Receipt Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
