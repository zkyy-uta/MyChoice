import 'package:flutter/material.dart';

enum BasicDailyDecisionLimitAction { dismiss, upgrade, dashboard }

Future<BasicDailyDecisionLimitAction> showBasicDailyDecisionLimitDialog(
  BuildContext context,
) async {
  return await showDialog<BasicDailyDecisionLimitAction>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Daily Basic decision limit reached'),
          content: const Text(
            'The Basic plan allows one successfully saved decision per day '
            'in WIB. Upgrade to Premium for unlimited decisions.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(BasicDailyDecisionLimitAction.dismiss),
              child: const Text('Not now'),
            ),
            TextButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(BasicDailyDecisionLimitAction.dashboard),
              child: const Text('Back to Dashboard'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(BasicDailyDecisionLimitAction.upgrade),
              child: const Text('View Premium'),
            ),
          ],
        ),
      ) ??
      BasicDailyDecisionLimitAction.dismiss;
}

void handleBasicDailyDecisionLimitAction(
  BuildContext context,
  BasicDailyDecisionLimitAction action,
) {
  switch (action) {
    case BasicDailyDecisionLimitAction.dismiss:
      break;
    case BasicDailyDecisionLimitAction.upgrade:
      Navigator.of(context).pushNamed('/profile/premium-plan');
    case BasicDailyDecisionLimitAction.dashboard:
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
  }
}
