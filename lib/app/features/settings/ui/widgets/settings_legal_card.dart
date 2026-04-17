import 'package:flutter/material.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_card_frame.dart';

class SettingsLegalCard extends StatelessWidget {
  const SettingsLegalCard({
    super.key,
    required this.onPrivacyPolicyTap,
    required this.onTermsOfServiceTap,
  });

  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsOfServiceTap;

  @override
  Widget build(BuildContext context) {
    return SettingsCardFrame(
      child: Column(
        children: <Widget>[
          _SettingsLegalRow(
            icon: Icons.verified_user_outlined,
            label: 'Privacy Policy',
            onTap: onPrivacyPolicyTap,
          ),
          const SizedBox(height: 14),
          _SettingsLegalRow(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            onTap: onTermsOfServiceTap,
          ),
        ],
      ),
    );
  }
}

class _SettingsLegalRow extends StatelessWidget {
  const _SettingsLegalRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
