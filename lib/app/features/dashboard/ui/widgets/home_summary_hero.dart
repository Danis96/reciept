import 'package:flutter/material.dart';
import 'package:reciep/app/features/dashboard/action_utils/dashboard_action_utils.dart';
import 'package:reciep/app/features/dashboard/repository/home_dashboard_model.dart';
import 'package:reciep/theme/app_spacing.dart';

class HomeSummaryHero extends StatelessWidget {
  const HomeSummaryHero({super.key, required this.data});

  final HomeDashboardModel data;

  @override
  Widget build(BuildContext context) {
    final double safeTotalBudget =
    data.totalBudget <= 0 ? 1 : data.totalBudget;
    final double ratio = (data.thisMonthSpending / safeTotalBudget).clamp(0, 1);
    final int usedPercent = (ratio * 100).round();
    final String greeting = TimeGreetingLabel.forNow(DateTime.now());
    final double topInset = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        topInset + AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: HomeThemePalette.heroGradient(context),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$greeting!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "Here's your spending overview",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withAlpha(31), // 0.12
              border: Border.all(color: Colors.white.withAlpha(46)), // 0.18
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _HeroMetric(
                      title: 'This Month',
                      value:
                      '${DashboardMoney.formatDecimalConditionally(data.thisMonthSpending)} KM',
                      alignEnd: false,
                    ),
                    _HeroMetric(
                      title: 'Budget',
                      value:
                      '${DashboardMoney.formatDecimalConditionally(data.totalBudget)} KM',
                      alignEnd: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 8,
                    backgroundColor: Colors.white.withAlpha(66), // 0.26
                    valueColor: AlwaysStoppedAnimation<Color>(
                      HomeThemePalette.success(context),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '$usedPercent% used',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${DashboardMoney.formatDecimalConditionally(data.remainingBudget)} KM left',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: HomeThemePalette.success(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.title,
    required this.value,
    required this.alignEnd,
  });

  final String title;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
