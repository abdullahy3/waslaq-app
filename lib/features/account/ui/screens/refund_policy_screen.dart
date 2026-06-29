import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

@RoutePage()
class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        title: Text(
          'Refund & Return Policy',
          style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _RefundHeader(),
            SizedBox(height: 16),

            // Buyer Protection Banner
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF2E1065),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colors.primaryLight.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🛡️', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waslaq Buyer Protection',
                          style: TextStyle(
                            color: context.colors.primaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Every order placed on Waslaq is protected by our escrow system. Your payment is held securely by the Platform and is only released to the vendor after a mandatory Inspection Window — giving you time to verify that your order arrived correctly and as described.',
                          style: TextStyle(
                            color: Colors.purple.shade200,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Section 1 — Inspection Window
            _Section(
              number: '1',
              title: 'The Inspection Window',
              children: [
                Text(
                  'The Inspection Window is a mandatory hold period that begins upon order delivery or vendor shipment confirmation. During this window, funds remain in escrow and have not been released to the vendor. You must open any dispute before this window closes.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        emoji: '📦',
                        title: 'Physical Products',
                        body: '48 hours from the time the vendor marks the order as shipped or delivery is confirmed.',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _InfoCard(
                        emoji: '💻',
                        title: 'Digital Products',
                        body: '24 hours from the time the digital key, file, or access credentials are delivered.',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _AlertBox(
                  type: _AlertType.warning,
                  title: 'Important:',
                  text: 'Once the Inspection Window expires and funds are released to the vendor, the transaction is considered legally final and settled. No refund claims will be accepted after this point under any circumstances, except in cases of verified fraud at the Platform\'s sole discretion.',
                ),
              ],
            ),

            // Section 2 — Eligible Refund Conditions
            _Section(
              number: '2',
              title: 'Eligible Refund Conditions',
              children: [
                Text(
                  'Waslaq Buyer Protection covers the following situations. A dispute must be opened before the Inspection Window expires and must include supporting evidence:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _EligibleItem(text: 'Item Not Received: The vendor fails to ship the order within a reasonable timeframe and the buyer has not received the item.'),
                _EligibleItem(text: 'Significantly Not as Described: The product is materially different from what was listed — wrong item, wrong color/size, missing components, or wrong condition.'),
                _EligibleItem(text: 'Item Arrived Damaged: The product arrived non-functional, broken, or materially unusable. Photographic/video evidence required.'),
                _EligibleItem(text: 'Counterfeit Product Without Disclosure: A product was sold as genuine but is clearly counterfeit with no prior listing disclosure.'),
                _EligibleItem(text: 'Non-Functional Digital Product: A digital key or file is invalid, expired, already redeemed, or corrupted at delivery.'),
                _EligibleItem(text: 'Duplicate Charge: The buyer was charged more than once for the same order due to a payment processing error.'),
              ],
            ),

            // Section 3 — Non-Eligible Situations
            _Section(
              number: '3',
              title: 'Non-Eligible Situations',
              children: [
                Text(
                  'The following situations are explicitly NOT covered by Waslaq Buyer Protection:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _NotEligibleItem(text: 'Change of Mind: Buyer received the correct, undamaged product but no longer wants it. Vendor\'s own return policy applies.'),
                _NotEligibleItem(text: 'Claims After Inspection Window: Any dispute submitted after the window has expired and funds released. These claims are legally waived.'),
                _NotEligibleItem(text: 'Buyer-Caused Damage: Items damaged by the buyer through misuse, improper handling, or modification after delivery.'),
                _NotEligibleItem(text: 'Disclosed Non-Original Products: Products clearly listed as counterfeit, replica, or non-original. Buyer knowingly accepted the product\'s nature.'),
                _NotEligibleItem(text: 'Redeemed Digital Products: Keys, codes, or vouchers already redeemed or used by the buyer, regardless of satisfaction level.'),
                _NotEligibleItem(text: 'Incompatibility Known at Purchase: Products incompatible with buyer\'s device/region where restrictions were disclosed or discoverable.'),
                _NotEligibleItem(text: 'Minor Appearance Differences: Slight color variations or cosmetic imperfections within normal product variation tolerances.'),
              ],
            ),

            // Section 4 — How to Open a Dispute
            _Section(
              number: '4',
              title: 'How to Open a Dispute',
              children: [
                Text(
                  'To request a refund or raise a concern about your order, follow these steps:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _StepItem(n: 1, text: 'Navigate to Account → Orders and locate the relevant order using the order ID or date.'),
                _StepItem(n: 2, text: 'Click "Open Dispute" on the order detail page. This option is only available during the active Inspection Window.'),
                _StepItem(n: 3, text: 'Select the most accurate dispute reason from the available categories.'),
                _StepItem(n: 4, text: 'Provide a detailed written description of the issue including relevant dates, what you received, and how it differs from what was listed.'),
                _StepItem(n: 5, text: 'Upload supporting evidence: photographs, videos, screenshots, or receipts. The stronger your evidence, the faster the resolution.'),
                _StepItem(n: 6, text: 'Submit the dispute. The vendor will be notified and given a response window.'),
                _StepItem(n: 7, text: 'Monitor the dispute from your account. Waslaq may contact you for additional information. Respond promptly.'),
                _StepItem(n: 8, text: 'Waslaq will review all evidence and issue a final binding decision. You will be notified via email and in-app notification.'),
                SizedBox(height: 8),
                _AlertBox(
                  type: _AlertType.info,
                  title: 'Tip:',
                  text: 'For the fastest resolution, open your dispute as early as possible within the Inspection Window and provide comprehensive photographic or video evidence.',
                ),
              ],
            ),

            // Section 5 — Burden of Proof
            _Section(
              number: '5',
              title: 'Burden of Proof',
              children: [
                Text(
                  'The burden of proof rests with the buyer. Waslaq requires substantive evidence before ruling in a buyer\'s favor. Acceptable forms of evidence include:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Clear photographs or video of the received item showing the defect, damage, or discrepancy.'),
                _Bullet(text: 'Side-by-side comparison between the listing images/description and the received item.'),
                _Bullet(text: 'Screenshots of error messages for non-functional digital products.'),
                _Bullet(text: 'Packaging photographs showing condition upon arrival (useful for damage claims).'),
                _Bullet(text: 'Written communication with the vendor through the Platform\'s messaging system.'),
                SizedBox(height: 8),
                _AlertBox(
                  type: _AlertType.danger,
                  title: 'Fraud Warning:',
                  text: 'Submitting false, fabricated, or manipulated evidence in a dispute constitutes fraud and a serious violation of the Waslaq Terms of Use. Offenders will have accounts immediately terminated, balances forfeited, and may be reported to relevant Palestinian authorities.',
                ),
              ],
            ),

            // Section 6 — Refund Processing
            _Section(
              number: '6',
              title: 'Refund Processing',
              children: [
                _SubHeader(title: '6.1 When Dispute is Resolved in Buyer\'s Favor'),
                _Bullet(text: 'Funds still in escrow: The escrowed funds are immediately reversed and returned to the buyer\'s original payment method.'),
                _Bullet(text: 'Funds already released to vendor: The refund amount is deducted directly from the vendor\'s available balance.'),
                _Bullet(text: 'Full refund: The complete order amount is returned including platform service fees where applicable.'),
                _Bullet(text: 'Partial refund: In cases where partial fault is established, Waslaq may issue a partial refund.'),
                SizedBox(height: 12),
                _SubHeader(title: '6.2 Refund Timeline'),
                _Bullet(text: 'Bank of Palestine and local gateways: 3–7 business days from decision date.'),
                _Bullet(text: 'Other payment methods: Up to 14 business days depending on the provider.'),
                SizedBox(height: 8),
                Text(
                  'Waslaq is not responsible for delays caused by your bank or payment provider\'s processing timelines.',
                  style: TextStyle(color: context.colors.textMuted, fontSize: 13, height: 1.5),
                ),
              ],
            ),

            // Section 7 — Vendor Return Policies
            _Section(
              number: '7',
              title: 'Vendor Return Policies',
              children: [
                Text(
                  'In addition to Waslaq\'s platform-level protection, individual vendors may publish their own return, exchange, and after-sale service policies on their public store page. These apply exclusively to situations not covered by Waslaq Buyer Protection — most commonly, change-of-mind returns on correctly fulfilled orders.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                Text(
                  'Waslaq does not enforce or guarantee vendor-specific return policies. Buyers seeking returns under a vendor\'s own policy must coordinate directly with the vendor through the Platform\'s messaging system.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Text(
                    'Before purchasing, we recommend reviewing the vendor\'s published return policy on their store page, particularly for high-value items.',
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 13, height: 1.5),
                  ),
                ),
              ],
            ),

            // Section 8 — Digital Products
            _Section(
              number: '8',
              title: 'Digital Products — Special Provisions',
              children: [
                Text(
                  'Digital products including game keys, software licenses, vouchers, downloadable files, and activation codes are subject to the following additional provisions:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(boldPrefix: 'Immediate delivery: ', text: 'Digital products are delivered automatically upon payment confirmation. Delivery is considered complete when the key or file is available in the buyer\'s account.'),
                _Bullet(boldPrefix: '24-hour inspection window: ', text: 'Buyers have 24 hours from delivery to test and report any issues. After this window, the sale is final.'),
                _Bullet(boldPrefix: 'Non-functional keys: ', text: 'If a key is invalid or already used at delivery, the buyer must provide a screenshot of the publisher\'s error message. Valid claims are refunded in full.'),
                _Bullet(boldPrefix: 'No refunds after redemption: ', text: 'Once a digital key, code, or license has been redeemed, activated, or used — no refund will be issued regardless of satisfaction level.'),
                _Bullet(boldPrefix: 'Region-lock issues: ', text: 'Buyers are responsible for verifying regional compatibility before purchase. Refunds are not available for region-locked products where restrictions were disclosed.'),
              ],
            ),

            // Section 9 — Vendor Obligations
            _Section(
              number: '9',
              title: 'Vendor Obligations Regarding Refunds',
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Platform Role Clarification',
                        style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Waslaq acts exclusively as a technical and financial intermediary — a neutral middleman between buyers and vendors. The Platform is not responsible for the physical delivery, packaging, shipping, or logistics of any order. All delivery obligations rest entirely with the vendor.',
                        style: TextStyle(color: context.colors.textSecondary, fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                _Bullet(text: 'Vendors must ensure all products shipped match the listing description, condition, and specifications accurately.'),
                _Bullet(text: 'Vendors must respond to dispute notifications within the timeframe specified by the Platform. Failure to respond may result in automatic refund to the buyer.'),
                _Bullet(text: 'Vendors must not contact buyers outside the Platform\'s messaging system to discourage dispute filing.'),
                _Bullet(text: 'In cases where a refund is issued from a vendor\'s balance, the vendor irrevocably consents to the deduction as a condition of Platform participation.'),
                _Bullet(text: 'Repeated refund disputes resolved against a vendor may result in account review, increased escrow hold periods, or account suspension.'),
              ],
            ),

            // Section 10 — Contact and Support
            _Section(
              number: '10',
              title: 'Contact and Support',
              children: [
                Text(
                  'For questions about this policy, assistance opening a dispute, or support with a specific order:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Use the dispute system directly from your order page: Account → Orders → [Order] → Open Dispute'),
                _Bullet(text: 'Contact our support team at support@waslaq.com'),
                _Bullet(text: 'Submit a support ticket via our contact page'),
                SizedBox(height: 8),
                Text(
                  'Support is available in Arabic and English. We aim to respond to all inquiries within 1–2 business days.',
                  style: TextStyle(color: context.colors.textMuted, fontSize: 13, height: 1.5),
                ),
              ],
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Related Policies',
                    style: TextStyle(color: context.colors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Terms of Use · Privacy Policy · Cookie Policy · Contact Support',
                    style: TextStyle(color: context.colors.primaryLight, fontSize: 13, height: 1.5),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '© 2026 Waslaq. Palestine\'s Social Marketplace. All rights reserved.',
                    style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UI Components
// ─────────────────────────────────────────────────────────────────────────────

class _RefundHeader extends StatelessWidget {
  const _RefundHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LEGAL',
          style: TextStyle(
            color: context.colors.primaryLight,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Refund & Return Policy',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Effective Date: May 1, 2026 · Last Updated: May 1, 2026',
          style: TextStyle(color: context.colors.textMuted, fontSize: 12),
        ),
        SizedBox(height: 16),
        Text(
          'Waslaq is committed to providing a fair, transparent, and secure marketplace experience. This Refund & Return Policy outlines the conditions under which buyers are entitled to refunds, the dispute resolution process, the obligations of vendors regarding returns, and the rights and limitations applicable to all parties.',
          style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 8),
        Divider(color: context.colors.border, thickness: 1, height: 32),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String number;
  final String title;
  final List<Widget> children;

  const _Section({required this.number, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(0xFF2E1065),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: TextStyle(
                    color: context.colors.primaryLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubHeader extends StatelessWidget {
  final String title;
  const _SubHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: context.colors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String? boldPrefix;
  final String text;
  const _Bullet({this.boldPrefix, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4, right: 8),
            child: Text('▸', style: TextStyle(color: context.colors.primaryLight, fontSize: 14)),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.5),
                children: [
                  if (boldPrefix != null)
                    TextSpan(
                      text: boldPrefix,
                      style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EligibleItem extends StatelessWidget {
  final String text;
  const _EligibleItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3, right: 8),
            child: Text('✓', style: TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(text, style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _NotEligibleItem extends StatelessWidget {
  final String text;
  const _NotEligibleItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3, right: 8),
            child: Text('✕', style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(text, style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int n;
  final String text;
  const _StepItem({required this.n, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: EdgeInsets.only(top: 1, right: 10),
            decoration: BoxDecoration(
              color: Color(0xFF2E1065),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$n',
              style: TextStyle(
                color: context.colors.primaryLight,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(text, style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String body;
  const _InfoCard({required this.emoji, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 20)),
          SizedBox(height: 6),
          Text(title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 4),
          Text(body, style: TextStyle(color: context.colors.textSecondary, fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}

enum _AlertType { info, warning, danger }

class _AlertBox extends StatelessWidget {
  final _AlertType type;
  final String title;
  final String text;

  const _AlertBox({required this.type, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    final bgColor = switch (type) {
      _AlertType.info => Color(0xFF082F49),
      _AlertType.warning => Color(0xFF451A03),
      _AlertType.danger => Color(0xFF450A0A),
    };
    final borderColor = switch (type) {
      _AlertType.info => Color(0xFF0284C7),
      _AlertType.warning => Color(0xFFB45309),
      _AlertType.danger => Color(0xFFDC2626),
    };
    final titleColor = switch (type) {
      _AlertType.info => Colors.lightBlueAccent,
      _AlertType.warning => Colors.amberAccent,
      _AlertType.danger => Colors.redAccent,
    };
    final icon = switch (type) {
      _AlertType.info => Icons.info_outline,
      _AlertType.warning => Icons.warning_amber_outlined,
      _AlertType.danger => Icons.gpp_bad_outlined,
    };

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: titleColor, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: titleColor, fontSize: 13, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(text, style: TextStyle(color: context.colors.textPrimary, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
