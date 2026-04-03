import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/providers/auth_provider.dart';
import 'package:icare/screens/select_payment_method.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/role_ui.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';

class ViewCourse extends ConsumerWidget {
  const ViewCourse({super.key, this.courseData});
  final Map<String, dynamic>? courseData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.read(authProvider).userRole;
    final bool isWeb = MediaQuery.of(context).size.width > 900;
    
    // Safe data extraction
    final dynamic titleVal = courseData?['title'] ?? courseData?['name'];
    final String name = (titleVal is String) ? titleVal : "Untitled Course";

    String instructor = "Instructor";
    final dynamic instrVal = courseData?['instructor'];
    if (instrVal is String) {
      instructor = instrVal;
    } else if (instrVal is Map) {
      // Try to get name from nested user object first
      final user = instrVal['user'];
      if (user is Map && user['name'] is String) {
        instructor = user['name'] as String;
      } else if (instrVal['name'] is String) {
        instructor = instrVal['name'] as String;
      }
    }

    final dynamic descVal = courseData?['caption'] ?? courseData?['desc'];
    final String desc = (descVal is String) ? descVal : "No description available.";

    final dynamic imageVal = courseData?['image'];
    final String image = (imageVal is String && imageVal.isNotEmpty) ? imageVal : ImagePaths.course1;

    final String courseId = courseData?['_id'] ?? courseData?['id'] ?? "";
    final double price = (courseData?['price'] != null) ? (double.tryParse((courseData?['price'] ?? '').toString()) ?? 45.0) : 45.0;

    final dynamic tagVal = courseData?['tag'] ?? courseData?['category'];
    final String tag = (tagVal is String) ? tagVal : "Health";

    final dynamic ratingVal = courseData?['rating'];
    final double rating = double.tryParse(ratingVal?.toString() ?? '4.8') ?? 4.8;
    final bool isPurchased = (courseData?['isPurchased'] == true);

    // ── MOBILE: original layout (untouched) ────────────────────────────────
    if (!isWeb) {
      return Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          automaticallyImplyLeading: false,
          title: CustomText(
            text: "Course",
            fontFamily: "Gilroy-Bold",
            fontSize: 16.78,
            fontWeight: FontWeight.bold,
            color: AppColors.primary500,
            letterSpacing: -0.31,
            lineHeight: 1.0,
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isStudentRole(role) && !isPurchased) ...[
                    CustomText(
                      maxLines: 4,
                      width: Utils.windowWidth(context) * 0.9,
                      padding: EdgeInsets.symmetric(
                        vertical: ScallingConfig.verticalScale(10),
                      ),
                      fontFamily: "Gilroy-SemiBold",
                      fontSize: 14,
                      color: AppColors.themeRed,
                      letterSpacing: -0.31,
                      lineHeight: 1.0,
                      text: "You just have 10 sec trial to gain idea, what this course about.  You have to purchase this course to see full video.",
                    ),
                  ],
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          image,
                          width: Utils.windowWidth(context) * 0.9,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: Utils.windowWidth(context) * 0.4,
                        top: Utils.windowHeight(context) * 0.12,
                        child: CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                          child: const Icon(Icons.pause, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Utils.windowHeight(context) * 0.032),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: Utils.windowHeight(context) * 0.08,
                        maxWidth: Utils.windowWidth(context) * 0.9,
                      ),
                      child: ListView.builder(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                image,
                                width: Utils.windowWidth(context) * 0.28,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: ScallingConfig.scale(6)),
                  CustomText(
                    text: name,
                    color: AppColors.primary500,
                    fontFamily: "Gilroy-Bold",
                    textAlign: TextAlign.left,
                    width: Utils.windowWidth(context) * 0.85,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  SizedBox(height: ScallingConfig.scale(7)),
                  CustomText(
                    width: Utils.windowWidth(context) * 0.85,
                    text: desc,
                    maxLines: 100,
                    textAlign: TextAlign.justify,
                    color: AppColors.grayColor,
                    fontSize: 12,
                    fontFamily: "Gilroy-Regular",
                  ),
                  const SizedBox(height: 10),
                  CustomText(
                    width: Utils.windowWidth(context) * 0.85,
                    text: "Instructor: $instructor",
                    color: AppColors.themeDarkGrey,
                    fontSize: 13,
                    fontFamily: "Gilroy-SemiBold",
                  ),
                  SizedBox(height: Utils.windowHeight(context) * 0.05),
                ],
              ),
              if (!isInstructorRole(role) && !isPurchased) ...[
                Positioned(
                  left: ScallingConfig.scale(30),
                  bottom: ScallingConfig.verticalScale(80),
                  child: CustomButton(
                    label: "Buy Full Course",
                    borderRadius: 30,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SelectPaymentMethod(
                          courseId: courseId,
                          amount: price,
                        )),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // ── WEB: premium redesigned layout ─────────────────────────────────────
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 440,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const CustomBackButton(),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(image, fit: BoxFit.cover),
                  // Dark gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x22000000), Color(0xCC000000)],
                      ),
                    ),
                  ),
                  // Play button
                  Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 38),
                    ),
                  ),
                  // Student trial banner
                  if (isStudentRole(role) && !isPurchased)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                        color: AppColors.themeRed.withOpacity(0.9),
                        child: const Text(
                          "⚠️  You have a 10-second trial. Purchase the full course to unlock all content.",
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  // Course title overlay at bottom of hero
                  Positioned(
                    left: 60,
                    right: 60,
                    bottom: 32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person_rounded, color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            Text(instructor, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(width: 20),
                            const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                            const SizedBox(width: 4),
                            Text("$rating", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 20),
                            const Icon(Icons.group_rounded, color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            const Text("128 students", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Left: Thumbnails + Description ──────────────────
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail strip
                            _sectionLabel("Course Previews"),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 100,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                separatorBuilder: (_, __) => const SizedBox(width: 12),
                                itemBuilder: (ctx, i) => ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    image,
                                    width: 160,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 36),

                            // Description
                            _sectionLabel("About This Course"),
                            const SizedBox(height: 16),
                            _descriptionParagraph(desc),
                          ],
                        ),
                      ),

                      const SizedBox(width: 40),

                      // ── Right: Sticky CTA card ───────────────────────────
                      if (!isInstructorRole(role))
                        SizedBox(
                          width: 320,
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 30,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Enrol Now",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Get lifetime access to all modules and certificates.",
                                  style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8), height: 1.4),
                                ),
                                const SizedBox(height: 24),
                                // Feature list
                                ...[
                                  ("Full video access", Icons.play_circle_outline_rounded),
                                  ("Downloadable resources", Icons.download_rounded),
                                  ("Certificate on completion", Icons.workspace_premium_rounded),
                                  ("Lifetime access", Icons.lock_open_rounded),
                                ].map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Icon(item.$2, size: 18, color: const Color(0xFF10B981)),
                                      const SizedBox(width: 10),
                                      Text(item.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 24),
                                if (!isPurchased)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (ctx) => SelectPaymentMethod(
                                        courseId: courseId,
                                        amount: price,
                                      )),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      elevation: 8,
                                      shadowColor: AppColors.primaryColor.withOpacity(0.35),
                                    ),
                                    child: const Text(
                                      "Buy Full Course",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.3),
        ),
      ],
    );
  }

  Widget _descriptionParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF475569),
        height: 1.75,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
