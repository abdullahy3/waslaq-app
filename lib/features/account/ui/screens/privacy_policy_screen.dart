import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';

@RoutePage()
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        title: Text(t.legal.privacy_policy_title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _Header(
              category: 'LEGAL',
              title: 'Privacy Policy',
              dateInfo: 'Effective Date: May 1, 2026 · Last Updated: May 1, 2026',
              leadText: 'Waslaq ("we," "our," or "the Platform") is committed to protecting the privacy and personal data of all users. This Privacy Policy describes how we collect, process, store, and protect your information in accordance with applicable Palestinian data protection principles and international best practices including GDPR standards. By accessing or using Waslaq, you acknowledge that you have read and agree to the practices described in this Policy.',
            ),
            SizedBox(height: 16),

            // Section 1
            _Section(
              number: '1',
              title: 'Who We Are',
              children: [
                Text(
                  'Waslaq is an independent electronic social marketplace platform operating under Palestinian jurisdiction. We connect independent vendors with buyers, facilitate secure escrow-based transactions, and provide community features including posts, communities, direct messaging, and product reviews.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 10),
                Text(
                  'For privacy inquiries: privacy@waslaq.com · waslaq.com/contact',
                  style: TextStyle(color: context.colors.primaryLight, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // Section 2
            _Section(
              number: '2',
              title: 'Information We Collect',
              children: [
                _SubHeader(title: '2.1 Account and Registration Information'),
                _Bullet(text: 'Full name'),
                _Bullet(text: 'Email address (via Google Firebase Authentication or direct registration)'),
                _Bullet(text: 'Phone number (optional unless required for vendor onboarding)'),
                _Bullet(text: 'Profile display name and avatar'),
                _Bullet(text: 'Account creation date and authentication method (Google, Facebook, or email/password)'),
                SizedBox(height: 16),

                _SubHeader(title: '2.2 Vendor-Specific Information'),
                Text(
                  'Vendors submitting onboarding applications provide:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Store name, public description, logo, and banner images'),
                _Bullet(text: 'Delivery zone (Gaza, West Bank, or both) and physical location'),
                _Bullet(text: 'Payout account details: IBAN or PayPal address (stored securely, never publicly disclosed)'),
                _Bullet(text: 'Identity verification documentation (KYC) as required for compliance'),
                SizedBox(height: 16),

                _SubHeader(title: '2.3 Transaction and Order Data'),
                _Bullet(text: 'Order ID, display number, creation timestamp, and status'),
                _Bullet(text: 'Product details: title, variant, quantity, unit price in ILS'),
                _Bullet(text: 'Shipping address: recipient name, street, city, postal code'),
                _Bullet(text: 'Payment status and confirmation references'),
                _Bullet(text: 'Escrow status and ledger entries associated with the transaction'),
                _Bullet(text: 'Vendor payout request history'),
                SizedBox(height: 10),
                _AlertBox(
                  type: _AlertBoxType.success,
                  title: 'Payment Card Security:',
                  text: 'We do not store, process, or transmit full payment card numbers, CVV codes, or cardholder authentication data. All payment processing is handled exclusively by PCI-DSS Level 1 compliant gateways. We receive only transaction confirmation references and status codes.',
                ),
                SizedBox(height: 16),

                _SubHeader(title: '2.4 Identity Verification (KYC) Data'),
                Text(
                  'KYC may include government-issued photo ID, proof of bank account ownership, and business documentation. These are stored with strict access controls, used solely for AML compliance and fraud prevention, and never shared with other users.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '2.5 User-Generated Content'),
                _Bullet(text: 'Social posts, comments, votes, and saves'),
                const _Bullet(text: 'Community memberships and roles'),
                const _Bullet(text: 'Product reviews and star ratings'),
                const _Bullet(text: 'Customer Q&A submitted to vendors'),
                const _Bullet(text: 'Direct messages and order conversations via GetStream'),
                const SizedBox(height: 16),

                const _SubHeader(title: '2.6 Technical and Usage Data'),
                const _Bullet(text: 'IP address and approximate geographic location (city/region level)'),
                const _Bullet(text: 'Device type, operating system, and browser version'),
                const _Bullet(text: 'Pages visited, time spent, and navigation path'),
                const _Bullet(text: 'Search queries entered on the platform'),
                const _Bullet(text: 'Error logs and diagnostic information'),
              ],
            ),

            // Section 3
            const _Section(
              number: '3',
              title: 'Legal Basis for Processing',
              children: [
                _CustomTable(
                  headers: ['Legal Basis', 'Processing Activities'],
                  rows: [
                    ['Contractual necessity', 'Account management, order processing, escrow operations, vendor payouts, dispute resolution'],
                    ['Legal obligation', 'KYC/AML compliance, tax records, judicial orders'],
                    ['Legitimate interests', 'Fraud prevention, security monitoring, platform analytics, abuse detection'],
                    ['Consent', 'Push notifications, optional marketing communications, non-essential cookies'],
                  ],
                ),
              ],
            ),

            // Section 4
            _Section(
              number: '4',
              title: 'How We Use Your Information',
              children: [
                _SubHeader(title: '4.1 Platform Operations'),
                _Bullet(text: 'Creating and authenticating user accounts'),
                _Bullet(text: 'Processing orders and managing the full transaction lifecycle'),
                _Bullet(text: 'Executing escrow fund flows and releasing vendor payouts'),
                _Bullet(text: 'Delivering digital products upon verified purchase'),
                _Bullet(text: 'Communicating delivery addresses to vendors for physical order fulfillment'),
                SizedBox(height: 16),

                _SubHeader(title: '4.2 Security and Fraud Prevention'),
                _Bullet(text: 'Detecting unusual account activity and unauthorized access'),
                _Bullet(text: 'Identifying and blocking fraudulent transactions and fake reviews'),
                _Bullet(text: 'Enforcing Terms of Use and community standards'),
                _Bullet(text: 'Investigating and resolving buyer-vendor disputes'),
                _Bullet(text: 'Maintaining append-only audit logs for all financial and administrative actions'),
                SizedBox(height: 16),

                _SubHeader(title: '4.3 Communication'),
                _Bullet(text: 'Order confirmations, shipping notifications, payout confirmations, and dispute updates via email'),
                _Bullet(text: 'In-app and push notifications for orders, community activity, and messages'),
                _Bullet(text: 'Responding to support tickets submitted through our contact form'),
              ],
            ),

            // Section 5
            _Section(
              number: '5',
              title: 'How We Share Your Information',
              children: [
                Text(
                  'We do not sell, rent, or trade your personal data to third parties for advertising or marketing purposes.',
                  style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold, height: 1.6),
                ),
                SizedBox(height: 12),
                _SubHeader(title: '5.1 Payment Processors'),
                Text(
                  'Transaction data is shared with Bank of Palestine and authorized payment gateways solely for payment execution and fraud prevention.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),
                _SubHeader(title: '5.2 Infrastructure Sub-Processors'),
                _CustomTable(
                  headers: ['Service', 'Purpose', 'Data Processed'],
                  columnWidths: {
                    0: FixedColumnWidth(100),
                    1: FlexColumnWidth(),
                    2: FixedColumnWidth(110),
                  },
                  rows: [
                    ['Cloudflare', 'CDN, DDoS protection, SSL', 'IP addresses, request metadata'],
                    ['Google Firebase', 'User authentication', 'Email, UID, auth tokens'],
                    ['GetStream', 'Real-time messaging and feeds', 'User IDs, message content'],
                    ['Resend', 'Transactional email delivery', 'Email addresses, email content'],
                    ['Cloudflare R2', 'Media storage', 'Uploaded files and images'],
                  ],
                ),
                SizedBox(height: 16),
                _SubHeader(title: '5.3 Between Buyers and Vendors'),
                Text(
                  'When an order is placed, the buyer\'s shipping name, delivery address, and order details are shared with the relevant vendor solely to fulfill the order. Vendors are prohibited from using this information for any other purpose.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),
                _SubHeader(title: '5.4 Legal and Judicial Disclosure'),
                Text(
                  'We may disclose personal data to Palestinian courts, law enforcement, or regulatory bodies when required by a lawful formal judicial order. Where legally permitted, we will notify the affected user prior to such disclosure.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 6
            _Section(
              number: '6',
              title: 'Data Security',
              children: [
                _Bullet(text: 'TLS 1.2+ encryption for all data in transit (HTTPS enforced)'),
                _Bullet(text: 'Encrypted storage for sensitive data including KYC documents and payout details'),
                _Bullet(text: 'Role-based access control (RBAC) — data access restricted to authorized personnel on a need-to-know basis'),
                _Bullet(text: 'Production databases are not publicly accessible; all connections use authenticated encrypted channels'),
                _Bullet(text: 'Content Security Policy (CSP), X-Frame-Options, and other standard security headers enforced'),
                _Bullet(text: 'Append-only audit logs for all administrative actions and financial transactions'),
                SizedBox(height: 12),
                Text(
                  'While we implement industry-standard security measures, no electronic system is 100% secure. You are responsible for maintaining the confidentiality of your credentials. Report suspected unauthorized access to security@waslaq.com.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 7
            _Section(
              number: '7',
              title: 'Data Retention',
              children: [
                _CustomTable(
                  headers: ['Data Category', 'Retention Period'],
                  columnWidths: {
                    0: FixedColumnWidth(140),
                    1: FlexColumnWidth(),
                  },
                  rows: [
                    ['Account information', 'Duration of account + 2 years after deletion'],
                    ['Transaction records', 'Minimum 5 years (financial compliance)'],
                    ['KYC / identity docs', 'Duration of vendor relationship + 5 years'],
                    ['Dispute records', '5 years from resolution date'],
                    ['Order and shipping data', '3 years'],
                    ['Usage and technical logs', '90 days'],
                    ['Support tickets', '3 years'],
                    ['Deleted account data', 'Anonymized or deleted within 30 days'],
                  ],
                ),
              ],
            ),

            // Section 8
            _Section(
              number: '8',
              title: 'Your Rights',
              children: [
                _Bullet(boldPrefix: 'Right of Access: ', text: 'Request a copy of the personal data we hold about you.'),
                _Bullet(boldPrefix: 'Right to Rectification: ', text: 'Request correction of inaccurate or incomplete data.'),
                _Bullet(boldPrefix: 'Right to Erasure: ', text: 'Request deletion of your data (subject to legal retention requirements).'),
                _Bullet(boldPrefix: 'Right to Restriction: ', text: 'Request temporary halt of processing in certain circumstances.'),
                _Bullet(boldPrefix: 'Right to Data Portability: ', text: 'Request a structured, machine-readable export of your data.'),
                _Bullet(boldPrefix: 'Right to Object: ', text: 'Object to processing based on legitimate interests.'),
                _Bullet(boldPrefix: 'Right to Withdraw Consent: ', text: 'Withdraw consent for consent-based processing at any time.'),
                SizedBox(height: 12),
                Text(
                  'Submit requests to privacy@waslaq.com. We respond within 30 days. Identity verification may be required.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 9
            _Section(
              number: '9',
              title: "Children's Privacy",
              children: [
                Text(
                  'Waslaq is not intended for users under the age of 18. We do not knowingly collect data from minors. If we become aware a minor has registered, we will immediately suspend the account and delete associated data. Report concerns to privacy@waslaq.com.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 10
            _Section(
              number: '10',
              title: 'Changes to This Policy',
              children: [
                Text(
                  'We may update this Policy at any time. Material changes will be communicated via email and a platform notice at least 14 days before taking effect. Continued use of Waslaq after changes take effect constitutes acceptance of the revised Policy.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Cookie Policy Divider
            Divider(color: context.colors.border, height: 60, thickness: 1.5),

            // Cookie Policy Header
            _Header(
              category: 'COOKIE DISCLOSURE',
              title: 'Cookie Policy',
              dateInfo: 'For EU, EEA, UK, and international users · Last Updated: May 1, 2026',
              leadText: 'This Cookie Policy applies to users accessing Waslaq from the European Union, European Economic Area, United Kingdom, and other jurisdictions where cookie consent requirements apply under the ePrivacy Directive, GDPR, or equivalent legislation.',
            ),
            SizedBox(height: 16),

            Text(
              'What Are Cookies?',
              style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Cookies are small text files placed on your device by a website. They enable websites to function, remember your preferences, and provide analytics to the site owner. Cookies may be session-based (deleted when you close your browser) or persistent (stored on your device for a defined period).',
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
            ),
            SizedBox(height: 24),

            Text(
              'Cookies We Use',
              style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _SubHeader(title: 'Strictly Necessary Cookies — No Consent Required'),
            _CustomTable(
              headers: ['Cookie', 'Purpose', 'Duration'],
              rows: [
                ['medusa_auth_token', 'Authenticated session token for the commerce backend', 'Session'],
                ['__session', 'Firebase authentication session', 'Session'],
                ['CSRF tokens', 'Prevents cross-site request forgery', 'Session'],
              ],
            ),
            SizedBox(height: 16),

            _SubHeader(title: 'Functional Cookies — Consent Required'),
            _CustomTable(
              headers: ['Cookie', 'Purpose', 'Duration'],
              rows: [
                ['Preference cookies', 'Remembers display and notification preferences', '1 year'],
                ['Cart persistence', 'Maintains cart contents across sessions', '30 days'],
              ],
            ),
            SizedBox(height: 12),
            _AlertBox(
              type: _AlertBoxType.success,
              title: 'No Advertising Cookies:',
              text: 'Waslaq does not display advertisements and does not use retargeting pixels, third-party tracking cookies, or behavioral advertising technologies.',
            ),
            SizedBox(height: 24),

            Text(
              'Third-Party Cookies',
              style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _CustomTable(
              headers: ['Service', 'Purpose', 'Privacy Reference'],
              columnWidths: {
                0: FixedColumnWidth(110),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(100),
              },
              rows: [
                ['Google Firebase', 'Authentication', 'firebase.google.com'],
                ['Cloudflare', 'Security and CDN', 'cloudflare.com'],
                ['GetStream', 'Messaging', 'getstream.io'],
              ],
            ),
            SizedBox(height: 24),

            Text(
              'Your Cookie Choices',
              style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You can configure your browser to refuse or delete cookies:',
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
            ),
            SizedBox(height: 8),
            _Bullet(text: 'Chrome: Settings → Privacy and Security → Cookies and other site data'),
            _Bullet(text: 'Firefox: Options → Privacy & Security → Cookies and Site Data'),
            _Bullet(text: 'Safari: Preferences → Privacy → Manage Website Data'),
            _Bullet(text: 'Edge: Settings → Privacy, search, and services → Cookies'),
            SizedBox(height: 10),
            _AlertBox(
              type: _AlertBoxType.warning,
              title: 'Notice:',
              text: 'Disabling strictly necessary cookies will prevent you from logging in and using core platform features.',
            ),
            SizedBox(height: 24),

            Text(
              'Legal Basis for Cookie Use',
              style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _CustomTable(
              headers: ['Category', 'Legal Basis'],
              rows: [
                ['Strictly necessary', 'Legitimate interest / Contractual necessity — no consent required'],
                ['Functional', 'Consent'],
                ['Analytics', 'Consent (server-side only, no tracking cookies)'],
                ['Advertising', 'Not applicable — no advertising cookies used'],
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Cookie inquiries: privacy@waslaq.com',
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14, fontStyle: FontStyle.italic),
            ),

            SizedBox(height: 48),

            // Footer Section
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
                    'Questions about this policy?',
                    style: TextStyle(color: context.colors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Contact privacy@waslaq.com or visit our contact page.',
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 13, height: 1.5),
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
// UI Component Widgets Reusable inside Legal Reader
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String category;
  final String title;
  final String dateInfo;
  final String leadText;

  const _Header({
    required this.category,
    required this.title,
    required this.dateInfo,
    required this.leadText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            color: context.colors.primaryLight,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8),
        Text(
          dateInfo,
          style: TextStyle(
            color: context.colors.textMuted,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 16),
        Text(
          leadText,
          style: TextStyle(
            color: context.colors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
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

  const _Section({
    required this.number,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 36),
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
                  color: Color(0xFF2E1065), // deep purple background
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
            child: Text(
              '▸',
              style: TextStyle(color: context.colors.primaryLight, fontSize: 14),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: [
                  if (boldPrefix != null)
                    TextSpan(
                      text: boldPrefix,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
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

enum _AlertBoxType { success, warning }

class _AlertBox extends StatelessWidget {
  final _AlertBoxType type;
  final String title;
  final String text;

  const _AlertBox({
    required this.type,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = type == _AlertBoxType.success
        ? Color(0xFF052E16) // deep green
        : Color(0xFF451A03); // deep amber

    final borderColor = type == _AlertBoxType.success
        ? Color(0xFF15803D)
        : Color(0xFFB45309);

    final titleColor = type == _AlertBoxType.success
        ? Colors.greenAccent
        : Colors.amberAccent;

    final icon = type == _AlertBoxType.success
        ? Icons.verified_user
        : Icons.info_outline;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: titleColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final Map<int, TableColumnWidth>? columnWidths;

  const _CustomTable({
    required this.headers,
    required this.rows,
    this.columnWidths,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: columnWidths,
        border: TableBorder.symmetric(
          inside: BorderSide(color: context.colors.border, width: 0.5),
        ),
        children: [
          // Header Row
          TableRow(
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              border: Border(bottom: BorderSide(color: context.colors.border, width: 1.5)),
            ),
            children: headers
                .map(
                  (h) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Text(
                      h,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          // Data Rows
          ...rows.map(
            (r) => TableRow(
              children: r
                  .map(
                    (cell) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        cell,
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
