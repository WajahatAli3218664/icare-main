import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/providers/auth_provider.dart';
import 'package:icare/screens/login.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/user_type_card.dart';
import 'package:icare/screens/tabs.dart';
import 'package:path/path.dart';

class SelectUserType extends ConsumerStatefulWidget {
  const SelectUserType({super.key});

  @override
  ConsumerState<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends ConsumerState<SelectUserType> {
  final List<Map<String, dynamic>> userTypes = [
    {
      "id": 1,
      "title": "I am a Patient",
      "description": "Consult doctors, access prescriptions and manage your health in one secure place.",
      "role": "patient",
      "image": ImagePaths.userType1,
    },
    {
      "id": 2,
      "title": "I am a Doctor",
      "description": "Manage patients, consultations and digital prescriptions with a clinical workflow.",
      "role": "doctor",
      "image": ImagePaths.userType2,
    },
  ];

int? selected_id;

void onSelect(int id) {

  setState(() {
    selected_id= id;
  });
}

@override
  void dispose() {
    setState(() {
      selected_id = null;
    });
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {


    
   return LayoutBuilder(builder: (ctx, constraints) {
      if(constraints.maxWidth < 600){
   return _buildMobileLayout(context);
      }
      else if(constraints.maxWidth <1200) {
        return _buildDesktopLayout(context, true);
      }
      else{
        return _buildDesktopLayout(context, false);
      }
    });

  
}


Widget _buildMobileLayout(BuildContext context){
  return Container(
        width: Utils.windowWidth(context),
        height: Utils.windowHeight(context),
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/bgImage.jpeg", ),
         fit: BoxFit.cover
        )
        ),
        child: Padding(
          padding:  EdgeInsets.only(top:ScallingConfig.verticalScale(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: ScallingConfig.scale(50),),
              CustomText(text: "Welcome to your healthcare journey",
              fontSize:25.27,
              maxLines: 2,
              padding: EdgeInsets.only(left: ScallingConfig.moderateScale(12)),
              color: AppColors.themeBlue,
              width: Utils.windowWidth(context) * 0.5 ,
              fontWeight: FontWeight.w700,
              isBold: true,
              ),
              CustomText(text: "Select a role to continue. Partner roles such as labs, pharmacies and instructors are managed securely by admin.",
              padding: EdgeInsets.only(top: ScallingConfig.verticalScale(10), left: ScallingConfig.moderateScale(12)),

              width: Utils.windowWidth(context) * 0.8 ,
              textAlign: TextAlign.start,
              fontSize: 12.60,
              maxLines: 2,
              isSemiBold: true,
                    ),
              SizedBox(height: ScallingConfig.scale(20),),
              Expanded(child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                   width: Utils.windowWidth(context),
                   padding: EdgeInsets.symmetric(horizontal: ScallingConfig.scale(10)), 
                    decoration: BoxDecoration(

                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        
                      ),
                      child: Center(
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: ScallingConfig.verticalScale(60)),                          
                          itemCount: userTypes.length,
                          itemBuilder: (ctx,i) {
                          return UserTypeCard(
                            image:userTypes[i]["image"],
                            title: userTypes[i]["title"],
                            description: userTypes[i]["description"],
                            onPressed: () {
  ref.read(authProvider.notifier).setUserRole(userTypes[i]["role"]);                              
                              onSelect(userTypes[i]["id"]);
                            },
                            isSelected: selected_id == userTypes[i]["id"]  ,
                          ); 
                        }
                        ),
                      ),
                  ),
                  if(selected_id != null)
                  Positioned(
                    bottom: ScallingConfig.verticalScale(20),
                    left: ScallingConfig.scale(20),
                    child: CustomButton(
                      width: Utils.windowWidth(context) * 0.9 ,
                      label: "Select a role to continue", 
                    borderRadius: ScallingConfig.moderateScale(30),
                    onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LoginScreen()));
                  },))
                ],
              ))         
            ],
          ),
        ) 
    );

}
Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
  return Scaffold(
    backgroundColor: const Color(0xFFF4F6FB),
    body: Row(
      children: [
        // ── Left Hero Panel ───────────────────────────────────────
        Expanded(
          flex: 4,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF001E6C),
                  Color(0xFF0036BC),
                  Color(0xFF035BE5),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -80,
                  left: -80,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.04),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  right: -50,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.03),
                    ),
                  ),
                ),
                // Center content
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Image.asset(
                            ImagePaths.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          "Choose Your Role",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: "Gilroy-Bold",
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Select the account type that best\ndescribes your role in iCare",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.65),
                            fontFamily: "Gilroy-Medium",
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.info_outline_rounded, color: Colors.white.withOpacity(0.7), size: 18),
                              const SizedBox(width: 10),
                              Text(
                                "Your role helps personalise your experience",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Gilroy-Medium",
                                ),
                              ),
                            ],
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

        // ── Right Panel: Role Cards ──────────────────────────────
        Expanded(
          flex: 6,
          child: Container(
            color: const Color(0xFFF8FAFD),
            child: Column(
              children: [
                // Top spacing
                const SizedBox(height: 40),
                // Grid content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: userTypes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet ? 2 : 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: isTablet ? 1.3 : 1.5,
                      ),
                      itemBuilder: (ctx, i) {
                        return UserTypeCard(
                          image: userTypes[i]["image"],
                          title: userTypes[i]["title"],
                          description: userTypes[i]["description"],
                          isSelected: selected_id == userTypes[i]["id"],
                          onPressed: () {
                            ref.read(authProvider.notifier).setUserRole(userTypes[i]["role"]);
                            onSelect(userTypes[i]["id"]);
                          },
                        );
                      },
                    ),
                  ),
                ),
                // Bottom action bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (selected_id != null)
                        Text(
                          "Role selected: ${userTypes.firstWhere((e) => e['id'] == selected_id)['role'].toString().replaceAll('_', ' ').toUpperCase()}",
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Gilroy-Medium",
                          ),
                        ),
                      const Spacer(),
                      SizedBox(
                        height: 52,
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: selected_id == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                          icon: const Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                          label: const Text(
                            "Select a role to continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontFamily: "Gilroy-Bold",
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            disabledBackgroundColor: const Color(0xFFCBD5E1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

}
