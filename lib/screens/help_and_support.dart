import 'package:flutter/material.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_text.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      return const _WebHelpAndSupport();
    }

    // ORIGINAL MOBILE LAYOUT
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        title: CustomText(text: "Help And Support"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CustomText( 
                fontFamily: "Gilroy-Regular",
                width: Utils.windowWidth(context) * 0.85,
                textAlign: TextAlign.left,
                maxLines: 7,
                text: "Lorem ipsum dolor sit amet consectetur adipiscing, elit congue nisi rutrum platea lacinia sapien, sed vel cras torquent scelerisque. Tempus pharetra quam congue natoque aptent sollicitudin et bibendum ullamcorper fames facilisis urna, ac tempor arcu ridiculus proin etiam diam taciti vivamus id pulvinar.", 
                color: AppColors.themeDarkGrey,
                fontSize: 12,
              ),
              SizedBox(height: Utils.windowHeight(context) * 0.023,),
              CustomText( 
                fontFamily: "Gilroy-Regular",
                width: Utils.windowWidth(context) * 0.85,
                textAlign: TextAlign.left,
                maxLines: 10,
                text: "Inceptos phasellus magnis netus at primis sodales torquent cras, lacus potenti habitant lobortis aliquam turpis risus enim, cubilia natoque ligula aenean gravida nascetur curae.bibendum ullamcorper fames facilisis urna, ac tempor arcu ridiculus proin etiam diam taciti vivamus id pulvinar. Inceptos phasellus magnis netus at primis sodales torquent cras, lacus potenti habitant.", 
                color: AppColors.themeDarkGrey,
                fontSize: 12,
              ),
              SizedBox(height: Utils.windowHeight(context) * 0.023,),
              CustomText( 
                fontFamily: "Gilroy-Regular",
                width: Utils.windowWidth(context) * 0.85,
                textAlign: TextAlign.left,
                maxLines: 7,
                text: "Lobortis aliquam turpis risus enim, cubilia natoque ligula aenean gravida nascetur curae.bibendum ullamcorper fames facilisis urna, ac tempor arcu ridiculus proin etiam diam taciti vivamus id pulvinar. Inceptos phasellus magnis.", 
                color: AppColors.themeDarkGrey,
                fontSize: 12,
              ),
              SizedBox(height: Utils.windowHeight(context) * 0.023,),
              CustomText( 
                fontFamily: "Gilroy-Regular",       
                width: Utils.windowWidth(context) * 0.85,
                textAlign: TextAlign.left,
                maxLines: 7,
                text: "Inceptos phasellus magnis netus at primis sodales torquent cras, lacus potenti habitant lobortis aliquam turpis risus enim, cubilia natoque ligula aenean gravida nascetur curae.bibendum ullamcorper fames facilisis urna, ac tempor arcu ridiculus proin etiam diam taciti vivamus id pulvinar.", 
                color: AppColors.themeDarkGrey,
                fontSize: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// NEW STUNNING WEB VIEW
// ═══════════════════════════════════════════════════════════════════════════

class _WebHelpAndSupport extends StatelessWidget {
  const _WebHelpAndSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        title: CustomText(
          text: "Help Center",
          fontWeight: FontWeight.bold,
          letterSpacing: -0.31,
          lineHeight: 1.0,
          fontSize: 20,
          fontFamily: "Gilroy-Bold",
          color: AppColors.primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left: Contact Block ──
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Color(0x0A000000), offset: Offset(0, 4), blurRadius: 16)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.support_agent_rounded, size: 32, color: AppColors.primaryColor),
                        ),
                        const SizedBox(height: 20),
                        const Text("Still need help?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: "Gilroy-Bold")),
                        const SizedBox(height: 12),
                        const Text("Our support team is available 24/7 to help you with any issues or queries.", style: TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.6)),
                        const SizedBox(height: 32),
                        _WebContactItem(icon: Icons.email_outlined, title: "Email Us", subtitle: "support@icare.com"),
                        const SizedBox(height: 20),
                        _WebContactItem(icon: Icons.phone_outlined, title: "Call Us", subtitle: "+1 (800) 123-4567"),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {},
                            child: const Text("Message Support", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 40),

                // ── Right: FAQ Block ──
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Frequently Asked Questions",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: "Gilroy-Bold"),
                      ),
                      const SizedBox(height: 24),
                      _WebFaqCard(
                        question: "How do I book a new appointment?",
                        answer: "You can book an appointment by navigating to the 'Appointments' tab and clicking 'New Booking'. Select your preferred doctor and available time slot.",
                        isExpanded: true,
                      ),
                      _WebFaqCard(
                        question: "How can I access my lab reports?",
                        answer: "All your lab results are synced automatically. Navigate to the 'Lab Results' section under Quick Links in your sidebar to view and download past reports.",
                      ),
                      _WebFaqCard(
                        question: "What should I do if my payment fails?",
                        answer: "If your invoice payment fails, please ensure your card details are correct or try a different payment method. Visit 'Wallet' to manage billing.",
                      ),
                      _WebFaqCard(
                        question: "Can I cancel or reschedule my task?",
                        answer: "Yes, tasks can be managed directly from the 'My Tasks' dashboard. Click the three dots icon next to a task to edit or cancel it.",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WebContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WebContactItem({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Icon(icon, color: const Color(0xFF475569), size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
          ],
        )
      ],
    );
  }
}

class _WebFaqCard extends StatefulWidget {
  final String question;
  final String answer;
  final bool isExpanded;

  const _WebFaqCard({required this.question, required this.answer, this.isExpanded = false});

  @override
  State<_WebFaqCard> createState() => _WebFaqCardState();
}

class _WebFaqCardState extends State<_WebFaqCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _expanded ? AppColors.primaryColor.withOpacity(0.3) : const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), offset: Offset(0, 2), blurRadius: 8)],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _expanded,
          onExpansionChanged: (val) => setState(() => _expanded = val),
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: Text(
            widget.question,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _expanded ? AppColors.primaryColor : const Color(0xFF1E293B), fontFamily: "Gilroy-SemiBold"),
          ),
          iconColor: AppColors.primaryColor,
          collapsedIconColor: const Color(0xFF64748B),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                widget.answer,
                style: const TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}