import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';

@RoutePage()
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        title: Text(t.legal.terms_title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
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
              title: 'Terms of Use',
              dateInfo: 'Effective Date: May 1, 2026 · Last Updated: May 1, 2026',
              leadText: 'These Terms of Use ("Agreement") constitute a legally binding contract between Waslaq ("Platform," "we," "our") and all users, including buyers and vendors ("you," "User"). By accessing or using any part of the Waslaq platform — including browsing, registering, purchasing, or selling — you unconditionally accept all terms set forth herein. If you do not agree to any part of this Agreement, you must immediately discontinue all use of the Platform.',
            ),
            SizedBox(height: 8),

            // Quick Navigation
            _QuickNavGrid(
              sections: [
                '1. Nature of the Platform',
                '2. Account Registration',
                '3. Escrow and Payments',
                '4. Vendor Obligations & KYC',
                '5. Buyer Obligations',
                '6. Prohibited Content',
                '7. Intellectual Property',
                '8. Dispute Resolution',
                '9. Chargebacks',
                '10. Fees and Commissions',
                '11. Limitation of Liability',
                '12. Termination & Suspension',
                '13. Governing Law',
                '14. Amendments',
              ],
            ),
            SizedBox(height: 24),

            // Section 1
            _Section(
              number: '1',
              title: 'Nature of the Platform',
              children: [
                Text(
                  'Waslaq operates as an independent electronic, technical, and financial intermediary that connects independent vendors with buyers exclusively within the Palestinian market. The Platform facilitates transactions through a secure escrow system and provides social commerce features including communities, posts, product reviews, and direct messaging.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 10),
                Text(
                  'The Platform is not a direct party to sale contracts concluded between buyers and vendors. No agency, partnership, employment, franchise, or joint venture relationship exists between Waslaq and any user. Vendors are independent sellers and are solely responsible for their products, listings, and fulfillment obligations.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 10),
                Text(
                  'Waslaq reserves the right to modify, suspend, or permanently discontinue any feature, section, or the entire Platform at any time, with or without prior notice, and shall not be liable to any user or third party for any such modification, suspension, or discontinuation.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 2
            _Section(
              number: '2',
              title: 'Account Registration and Eligibility',
              children: [
                Text(
                  'To access full platform features, you must register an account. By registering, you represent and warrant that:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'You are at least 18 years of age or the age of legal majority in your jurisdiction.'),
                _Bullet(text: 'All information provided during registration is accurate, current, and complete.'),
                _Bullet(text: 'You will maintain the accuracy of your account information and update it promptly when it changes.'),
                _Bullet(text: 'You will not create multiple accounts to circumvent restrictions, suspensions, or bans.'),
                _Bullet(text: 'You are solely responsible for all activity conducted under your account and for maintaining the confidentiality of your credentials.'),
                SizedBox(height: 10),
                Text(
                  'Waslaq reserves the right to refuse registration, verify identity, suspend access, or permanently ban any account at its sole discretion, including without limitation for violations of this Agreement, suspected fraud, or reputational harm to the Platform.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 3
            _Section(
              number: '3',
              title: 'Escrow and Payment System',
              children: [
                _SubHeader(title: '3.1 Payment Processing'),
                Text(
                  'All transactions on Waslaq are processed exclusively through authorized payment gateways including Bank of Palestine and other licensed processors. All amounts are denominated in Israeli New Shekel (ILS). By placing an order, you authorize the Platform to charge the full order amount, including any applicable platform fees, to your selected payment method.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '3.2 Escrow Hold'),
                Text(
                  'Upon successful payment, the full order amount is held in escrow by the Platform. Funds are not released to the vendor until the mandatory Inspection Window has elapsed without a dispute being opened. The Inspection Window is:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Physical products: 48 hours from confirmed delivery or vendor marking the order as shipped.'),
                _Bullet(text: 'Digital products: 24 hours from confirmed delivery of the digital key, file, or access credentials.'),
                SizedBox(height: 16),

                _SubHeader(title: '3.3 Vendor Rights to Funds'),
                Text(
                  'Vendors do not acquire any vested legal right to held funds until the Inspection Window expires without a dispute. Waslaq retains absolute and unilateral discretionary authority to:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Extend the hold period beyond the standard Inspection Window in cases of suspected fraud or unresolved disputes.'),
                _Bullet(text: 'Freeze funds indefinitely pending investigation of reported misconduct, multiple complaints, or regulatory inquiry.'),
                _Bullet(text: 'Reverse or redirect held funds to buyers in the event of a resolved dispute or confirmed vendor breach.'),
                _Bullet(text: 'Withhold pending payouts from vendors whose accounts are under investigation or suspension.'),
                SizedBox(height: 16),

                _SubHeader(title: '3.4 Currency and Pricing'),
                Text(
                  'All prices, fees, and payouts on the Platform are denominated in Israeli New Shekel (ILS). Waslaq does not guarantee exchange rates and is not responsible for currency conversion losses incurred by users transacting from outside Palestine.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 4
            _Section(
              number: '4',
              title: 'Vendor Obligations and KYC',
              children: [
                _SubHeader(title: '4.1 Onboarding and Verification'),
                Text(
                  'All vendors must complete the Waslaq seller onboarding process, including providing accurate store information, delivery zone configuration, and payout account details. Vendors must complete identity verification (KYC) before accessing payout functionality. KYC may require submission of:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Government-issued photo identification (national ID or passport).'),
                _Bullet(text: 'Proof of bank account ownership (bank statement or IBAN verification letter).'),
                _Bullet(text: 'Business registration documentation, where applicable.'),
                SizedBox(height: 8),
                Text(
                  'Failure to complete KYC within a reasonable period may result in account suspension and withholding of accumulated funds pending completion.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '4.2 Product Listing Accuracy'),
                Text(
                  'Vendors are exclusively and wholly responsible for the accuracy, completeness, legality, and authenticity of all product listings, including titles, descriptions, images, pricing, and specifications. Listings must accurately reflect the actual product the buyer will receive.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '4.3 Counterfeit and Non-Original Products'),
                Text(
                  'Vendors may list counterfeit, replica, or non-original products only if and when they explicitly and unambiguously disclose this in both the product title and product description in a manner that leaves no reasonable doubt in the buyer\'s mind. Acceptable disclosure language includes:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: '"This product is a replica / non-original / imitation — not affiliated with or endorsed by the original brand."'),
                _Bullet(text: 'Clear use of terms such as "copy," "fake," "replica," "imitation," or "not original" in the title itself.'),
                SizedBox(height: 8),
                _AlertBox(
                  type: _AlertBoxType.error,
                  title: 'STRICTLY PROHIBITED:',
                  text: 'Listing any counterfeit or non-original item as "genuine," "original," "authentic," or "brand new" without clear disclosure. This constitutes commercial fraud and a material breach of this Agreement, entitling Waslaq to immediately remove all listings, freeze the vendor\'s balance, process full refunds to affected buyers, permanently close the account, and pursue civil and criminal legal remedies including compensation claims for damages.',
                ),
                SizedBox(height: 16),

                _SubHeader(title: '4.4 Fulfillment and Delivery'),
                Text(
                  'Vendors are solely responsible for fulfilling orders within a reasonable and communicated timeframe. For physical products, vendors are responsible for packaging, shipping, and delivery to the buyer\'s specified address. For digital products, delivery must occur automatically and immediately upon payment confirmation. Repeated fulfillment failures may result in account suspension.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '4.5 Communication with Buyers'),
                Text(
                  'Vendors must respond to buyer inquiries through the Platform\'s messaging system within a reasonable timeframe. Vendors must not communicate with buyers through external channels to circumvent the Platform\'s escrow or dispute systems.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 5
            _Section(
              number: '5',
              title: 'Buyer Obligations',
              children: [
                _Bullet(text: 'Provide accurate shipping addresses and contact information at checkout. Waslaq and vendors are not responsible for delivery failures resulting from buyer-provided incorrect addresses.'),
                _Bullet(text: 'Review orders during the Inspection Window and open disputes promptly if issues are identified. Failure to open a dispute before the Inspection Window expires constitutes legal acceptance of the order.'),
                _Bullet(text: 'Not submit false or manipulated evidence in disputes. Doing so constitutes fraud and will result in permanent account termination and potential legal action.'),
                _Bullet(text: 'Not initiate bank chargebacks without first exhausting the Platform\'s internal dispute resolution process.'),
                _Bullet(text: 'Comply with all applicable Palestinian law when purchasing products on the Platform.'),
              ],
            ),

            // Section 6
            _Section(
              number: '6',
              title: 'Prohibited Content and Activities',
              children: [
                Text(
                  'The following are strictly prohibited on Waslaq. Violations may result in immediate account suspension, permanent ban, fund forfeiture, and/or legal action:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),
                _SubHeader(title: '6.1 Commerce Violations'),
                _Prohibited(text: 'Listing counterfeit, replica, or non-original products without clear and explicit disclosure in the product title and description.'),
                _Prohibited(text: 'Offering, selling, or facilitating products or services that violate applicable Palestinian law, Islamic financial principles where mandated, or international sanctions.'),
                _Prohibited(text: 'Any scheme designed to circumvent the escrow system, including attempting to complete transactions outside the Platform.'),
                _Prohibited(text: 'Using the Platform for money laundering, terrorism financing, or any activity that violates anti-money laundering (AML) regulations.'),
                SizedBox(height: 16),

                _SubHeader(title: '6.2 Adult and NSFW Content — Zero Tolerance'),
                _AlertBox(
                  type: _AlertBoxType.error,
                  title: 'ABSOLUTE ZERO-TOLERANCE POLICY:',
                  text: 'Waslaq operates as a family-friendly, community-oriented marketplace serving the Palestinian market. Any violation of this section will result in immediate and permanent account termination with no right of appeal, regardless of the user\'s history or standing on the Platform.',
                ),
                _Prohibited(text: 'Posting, uploading, sharing, or linking to any sexually explicit, pornographic, or adult-only content in any format — including images, videos, text, links, or product listings — under any circumstances and without exception.'),
                _Prohibited(text: 'Posting any content that sexualizes, exploits, or endangers minors in any way. This constitutes a criminal offense and will be reported immediately to relevant Palestinian authorities and international child protection organizations.'),
                _Prohibited(text: 'Sharing nude, semi-nude, or suggestive imagery in any Platform section including posts, communities, product images, store banners, profile avatars, or direct messages.'),
                _Prohibited(text: 'Listing or selling any adult products, services, or materials regardless of their legal status in the user\'s jurisdiction.'),
                _Prohibited(text: 'Attempting to circumvent content moderation by using coded language, emojis, links to external sites, or indirect references to route users to prohibited content.'),
                SizedBox(height: 16),

                _SubHeader(title: '6.3 Social Layer and Community Standards'),
                _Prohibited(text: 'Harassment, bullying, threats, intimidation, or targeted abuse directed at any user, vendor, community member, or Platform staff in any Platform section.'),
                _Prohibited(text: 'Hate speech, discrimination, or content that demeans individuals or groups based on religion, ethnicity, nationality, gender, political affiliation, or any other protected characteristic.'),
                _Prohibited(text: 'Posting graphic violence, gore, disturbing imagery, or content designed to shock or distress other users.'),
                _Prohibited(text: 'Spreading deliberate misinformation, disinformation, or fabricated content intended to deceive other users or damage reputations.'),
                _Prohibited(text: 'Spamming communities, post feeds, or direct messages with unsolicited promotional content, repetitive posts, or automated bot activity.'),
                _Prohibited(text: 'Doxxing — publishing private personal information of any individual (name, address, phone number, financial details) without their explicit consent.'),
                _Prohibited(text: 'Impersonating another user, vendor, community moderator, or Waslaq staff member in any Platform context.'),
                SizedBox(height: 16),

                _SubHeader(title: '6.4 Technical and Security Violations'),
                _Prohibited(text: 'Unauthorized collection, scraping, or commercial use of other users\' personal data or Platform content.'),
                _Prohibited(text: 'Uploading malicious code, conducting denial of service attacks, or attempting to breach Platform security systems.'),
                _Prohibited(text: 'Creating multiple accounts to circumvent a ban, suspension, or account restriction.'),
                _Prohibited(text: 'Manipulation of product reviews, community votes, or ratings through fake accounts, paid reviews, or coordinated inauthentic behavior.'),
                SizedBox(height: 16),

                _SubHeader(title: '6.5 Enforcement and Moderation'),
                Text(
                  'Waslaq retains full, unilateral, and non-reviewable authority to determine what constitutes a violation of these standards and to take appropriate action, with or without prior notice. Enforcement actions include but are not limited to:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Removal of specific posts, listings, images, or comments.'),
                _Bullet(text: 'Temporary suspension from posting in specific communities or Platform-wide.'),
                _Bullet(text: 'Permanent ban from all Platform features including buying, selling, and social participation.'),
                _Bullet(text: 'Forfeiture of pending balances in cases of fraud or severe violations.'),
                _Bullet(text: 'Referral to Palestinian law enforcement or relevant authorities for criminal violations.'),
                SizedBox(height: 8),
                Text(
                  'Users may report violations using the Platform\'s built-in reporting system available on all posts, profiles, and listings. All reports are reviewed by the Waslaq moderation team.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 7
            _Section(
              number: '7',
              title: 'Intellectual Property',
              children: [
                _SubHeader(title: '7.1 Platform Content'),
                Text(
                  'All Platform content including the Waslaq name, logo, interface design, source code, written content, and proprietary features are the exclusive intellectual property of Waslaq and are protected by applicable copyright, trademark, and intellectual property laws. No user may reproduce, distribute, or commercially exploit Platform content without prior written consent.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '7.2 User Content License'),
                Text(
                  'By posting content on Waslaq (including product listings, photos, posts, reviews, and community content), you grant Waslaq a non-exclusive, royalty-free, worldwide, sublicensable license to use, display, reproduce, and distribute that content for the purpose of operating and promoting the Platform. This license ends when you delete the content or close your account, subject to retention requirements.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '7.3 Third-Party Intellectual Property'),
                Text(
                  'Vendors are solely and exclusively responsible for ensuring that their product listings, images, descriptions, and brand references do not infringe any third-party intellectual property rights including trademarks, copyrights, patents, or trade dress. Waslaq will respond to valid intellectual property infringement notices and will remove infringing content. Repeated infringement will result in permanent account closure.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 8
            _Section(
              number: '8',
              title: 'Dispute Resolution',
              children: [
                _SubHeader(title: '8.1 Opening a Dispute'),
                Text(
                  'Disputes must be opened exclusively through the Platform\'s built-in dispute system, accessible from the order detail page under Account → Orders. Disputes must be submitted before the expiration of the applicable Inspection Window. Any claim submitted after funds have been released to the vendor is legally considered waived and will not be entertained.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '8.2 Evidence and Process'),
                Text(
                  'The burden of proof rests with the buyer. Supporting evidence such as photographs, videos, screenshots, and written descriptions may be submitted. Waslaq may request additional documentation from either party. The vendor will be notified and given a reasonable opportunity to respond within the dispute window.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '8.3 Platform Decision'),
                Text(
                  'Following review of all submitted evidence, Waslaq will render a final, binding, and non-appealable decision. In cases where vendor fault is established, Waslaq may refund the buyer directly from the vendor\'s available or escrowed balance without requiring vendor consent. Waslaq\'s decision is final and constitutes full and final settlement of the dispute.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '8.4 Abuse of Dispute System'),
                Text(
                  'Submitting false, fabricated, or manipulated evidence in a dispute constitutes fraud. Waslaq reserves the right to immediately terminate the offending user\'s account, forfeit any pending funds, and pursue civil and criminal legal remedies.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 9
            _Section(
              number: '9',
              title: 'Chargebacks',
              children: [
                Text(
                  'By using Waslaq, you expressly agree not to initiate a chargeback through your bank, card issuer, or payment provider without first:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Submitting a dispute through the Platform\'s dispute system.'),
                _Bullet(text: 'Allowing Waslaq a reasonable period of at least 7 business days to investigate and respond.'),
                SizedBox(height: 10),
                Text(
                  'Initiating an unjustified or premature chargeback constitutes a material breach of this Agreement. In such cases, Waslaq reserves the right to:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Recover the full disputed transaction amount from the user\'s account or any held funds.'),
                _Bullet(text: 'Charge all associated bank fees, processing costs, and administrative expenses to the offending user.'),
                _Bullet(text: 'Permanently ban the user from the Platform.'),
                _Bullet(text: 'Pursue civil legal action to recover all losses, costs, and damages including legal fees.'),
              ],
            ),

            // Section 10
            _Section(
              number: '10',
              title: 'Platform Fees and Commissions',
              children: [
                Text(
                  'Waslaq charges the following fees, which are subject to change with 30 days\' notice:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 12),
                _CustomTable(
                  headers: ['Fee Type', 'Amount', 'Applied To'],
                  rows: [
                    ['Physical order platform fee', '₪2 flat per order', 'Included in checkout as delivery/service fee'],
                    ['Digital item platform fee', '₪1 per item', 'Deducted from proceeds at order placement'],
                    ['Vendor payout commission', '5% of payout amount', 'Deducted at time of payout execution'],
                    ['Bank transfer fee', '₪8 flat per transfer', 'Absorbed by Platform — not charged to vendor'],
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'All fees are non-refundable unless the Platform determines otherwise at its sole discretion. Waslaq reserves the right to introduce, modify, or remove fees at any time with reasonable advance notice to affected users.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 11
            _Section(
              number: '11',
              title: 'Limitation of Liability',
              children: [
                Text(
                  'Waslaq provides its services on an "as-is" and "as-available" basis without warranties of any kind, either express or implied, including but not limited to implied warranties of merchantability, fitness for a particular purpose, non-infringement, or continuous availability.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 10),
                Text(
                  'To the maximum extent permitted by applicable law, Waslaq shall not be liable for:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'Any indirect, incidental, special, consequential, exemplary, or punitive damages.'),
                _Bullet(text: 'Loss of profits, revenue, data, business opportunities, or goodwill.'),
                _Bullet(text: 'Damages arising from the conduct, products, or services of vendors or buyers.'),
                _Bullet(text: 'Service interruptions caused by circumstances beyond Waslaq\'s reasonable control, including internet outages, third-party service failures, natural disasters, civil unrest, or force majeure events.'),
                _Bullet(text: 'Unauthorized access to or alteration of your data resulting from third-party actions beyond our reasonable control.'),
                SizedBox(height: 10),
                _AlertBox(
                  type: _AlertBoxType.warning,
                  title: 'MAXIMUM LIABILITY CAP:',
                  text: 'In all cases, the maximum aggregate financial liability of Waslaq to any user in connection with any single transaction or claim shall not exceed the total value of that specific transaction as recorded on the Platform.',
                ),
              ],
            ),

            // Section 12
            _Section(
              number: '12',
              title: 'Termination and Suspension',
              children: [
                _SubHeader(title: '12.1 By Waslaq'),
                Text(
                  'Waslaq reserves the right to suspend or permanently terminate any account, with or without prior notice, for any violation of this Agreement, suspected fraud, reputational harm to the Platform, or any reason at its sole discretion. Upon termination, access to the Platform will be immediately revoked.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '12.2 Effect on Funds'),
                Text(
                  'In the event of account termination for cause (including fraud or material breach), Waslaq reserves the right to withhold any pending balance as security for claims, chargebacks, or legal proceedings. Funds not subject to any claim will be released to the vendor\'s registered payout account within 30 days of account closure, subject to completed KYC and verification.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 16),

                _SubHeader(title: '12.3 By the User'),
                Text(
                  'Users may close their account at any time through the account settings. Prior to closure, all pending orders must be fulfilled or resolved, and any disputed funds must be settled. Waslaq will retain transaction records as required by applicable law.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 13
            _Section(
              number: '13',
              title: 'Governing Law and Jurisdiction',
              children: [
                Text(
                  'This Agreement shall be governed by, construed, and enforced in accordance with the laws of the State of Palestine. Any dispute, controversy, or claim arising out of or in connection with this Agreement, including its formation, validity, breach, or termination, shall be subject to the exclusive jurisdiction of the competent Palestinian courts. Users irrevocably submit to the personal jurisdiction of such courts and waive any objection to proceedings in such courts on grounds of venue or inconvenient forum.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            // Section 14
            _Section(
              number: '14',
              title: 'Amendments',
              children: [
                Text(
                  'Waslaq reserves the right to amend, update, or replace these Terms of Use at any time. When material changes are made:',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
                SizedBox(height: 8),
                _Bullet(text: 'The "Last Updated" date will be updated at the top of this page.'),
                _Bullet(text: 'Registered users will be notified via email at least 14 days before changes take effect.'),
                _Bullet(text: 'A prominent notice will be displayed on the Platform.'),
                SizedBox(height: 10),
                Text(
                  'Continued use of the Platform after the effective date of any amendment constitutes your full and unconditional acceptance of the revised Terms. If you do not agree to the revised Terms, you must discontinue use and may request account deletion.',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6),
                ),
              ],
            ),

            SizedBox(height: 16),

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
                    'Questions about these terms?',
                    style: TextStyle(color: context.colors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Contact our legal team at legal@waslaq.com or visit our contact page.',
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

class _QuickNavGrid extends StatelessWidget {
  final List<String> sections;

  const _QuickNavGrid({required this.sections});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Navigation',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          // Clean layout using simple custom layout instead of scrollable GridView
          ...List.generate((sections.length / 2).ceil(), (index) {
            final leftIdx = index * 2;
            final rightIdx = leftIdx + 1;
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildNavItem(context, sections[leftIdx]),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: rightIdx < sections.length
                        ? _buildNavItem(context, sections[rightIdx])
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label) {
    // Splits "1. Title" into number and text
    final parts = label.split('. ');
    final num = parts[0];
    final title = parts.length > 1 ? parts[1] : '';
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
        children: [
          TextSpan(
            text: '$num. ',
            style: TextStyle(color: context.colors.primaryLight, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: title),
        ],
      ),
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
  final String text;

  const _Bullet({required this.text});

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
            child: Text(
              text,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Prohibited extends StatelessWidget {
  final String text;

  const _Prohibited({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4, right: 8),
            child: Text(
              '✕',
              style: TextStyle(color: context.colors.error, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _AlertBoxType { success, warning, error }

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
        ? const Color(0xFF052E16) // deep green
        : type == _AlertBoxType.warning
            ? const Color(0xFF451A03) // deep amber
            : const Color(0xFF450A0A); // deep red

    final borderColor = type == _AlertBoxType.success
        ? const Color(0xFF15803D)
        : type == _AlertBoxType.warning
            ? const Color(0xFFB45309)
            : const Color(0xFFB91C1C);

    final titleColor = type == _AlertBoxType.success
        ? Colors.greenAccent
        : type == _AlertBoxType.warning
            ? Colors.amberAccent
            : Colors.redAccent;

    final icon = type == _AlertBoxType.success
        ? Icons.verified_user
        : type == _AlertBoxType.warning
            ? Icons.info_outline
            : Icons.report_problem;

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

  const _CustomTable({
    required this.headers,
    required this.rows,
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
