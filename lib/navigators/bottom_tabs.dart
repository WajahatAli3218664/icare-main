import 'package:flutter/material.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/role_ui.dart';
import 'package:icare/widgets/custom_tab_button.dart';

List<Widget> buildTabs({
  required String role,
  required BuildContext context,
  required int currentIndex,
  required Function(int) onSelect,
}) {
  final secondaryTitle = tabLabelForRole(role);
  final homeTitle = isBackofficeRole(role) ? 'Console' : 'Home';
  final thirdTitle = isBackofficeRole(role) ? 'Referrals' : 'Chat';
  final thirdImage = isBackofficeRole(role) ? ImagePaths.bookings : ImagePaths.chat;
  return [
    CustomTabButton(
      onPressed: () => onSelect(0),
      iconColor: currentIndex == 0 ? AppColors.primaryColor : AppColors.grayColor,
      image: ImagePaths.home,
      title: homeTitle,
    ),
    CustomTabButton(
      onPressed: () => onSelect(1),
      iconColor: currentIndex == 1 ? AppColors.primaryColor : AppColors.grayColor,
      image: isPharmacyRole(role) ? ImagePaths.track : isLabRole(role) ? ImagePaths.bookings : isInstructorRole(role) || isStudentRole(role) ? ImagePaths.bookings : ImagePaths.bookings,
      title: secondaryTitle,
    ),
    const SizedBox(width: 20),
    CustomTabButton(
      onPressed: () => onSelect(2),
      iconColor: currentIndex == 2 ? AppColors.primaryColor : AppColors.grayColor,
      image: thirdImage,
      title: thirdTitle,
    ),
    CustomTabButton(
      onPressed: () => onSelect(3),
      iconColor: currentIndex == 3 ? AppColors.primaryColor : AppColors.grayColor,
      image: ImagePaths.profile2,
      title: 'Profile',
    ),
  ];
}
