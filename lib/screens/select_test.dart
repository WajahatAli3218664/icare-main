import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/models/lab_test.dart';
import 'package:icare/screens/confirm_booking.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/svg_wrapper.dart';
import 'package:icare/services/laboratory_service.dart';

class SelectTest extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  const SelectTest({super.key, required this.bookingData});

  @override
  State<SelectTest> createState() => _SelectTestState();
}

class _SelectTestState extends State<SelectTest> {
  final LaboratoryService _labService = LaboratoryService();
  bool _isLoading = true;
  List<LabTest> _tests = [];
  final List<LabTest> _selectedTests = [];

  @override
  void initState() {
    super.initState();
    _fetchLabTests();
  }

  Future<void> _fetchLabTests() async {
    try {
      final labId = widget.bookingData['labId'];
      if (labId == null) throw 'Lab ID is missing';
      
      final lab = await _labService.getLabById(labId);
      final List<dynamic> availableTests = lab['availableTests'] ?? [];
      
      setState(() {
        _tests = availableTests.map((t) => LabTest(
          id: t['_id'] ?? t['name'], 
          name: t['name'], 
          price: (t['price'] ?? 0).toDouble(),
        )).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching tests: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onSelect(LabTest item) {
    setState(() {
      if (_selectedTests.any((e) => e.id == item.id)) {
        _selectedTests.removeWhere((e) => e.id == item.id);
      } else {
        _selectedTests.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    log(jsonEncode(_selectedTests.map((e) => e).toList()));

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        title: CustomText(
          text: "Book A Lab",
          fontSize: 16.78,
          fontFamily: "Gilroy-Bold",
          fontWeight: FontWeight.bold,
          letterSpacing: -0.31,
          lineHeight: 1.0,
          color: AppColors.primary500,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: ScallingConfig.scale(10)),
              CustomText(
                width: Utils.windowWidth(context) * 0.9,
                text: "Select Test",
                fontFamily: "Gilroy-SemiBold",
                fontWeight: FontWeight.w400,
                fontSize: 14.78,
                color: AppColors.primary500,
              ),

              if (_tests.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: CustomText(
                    text: "No tests available for this laboratory.",
                    color: Colors.grey,
                  ),
                )
              else
                ..._tests.map(
                  (labtest) => SelectableItem(
                    selected: _selectedTests.any((e) => e.id == labtest.id),
                    item: labtest,
                    onSelect: () => _onSelect(labtest),
                  ),
                ),

              SizedBox(height: ScallingConfig.scale(20)),
              CustomButton(
                labelSize: 16.89,
                label: "Confirm Booking Summary",
                onPressed: () {
                  if (_selectedTests.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select at least one test')),
                    );
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ConfirmBookingScreen(
                        bookingData: widget.bookingData,
                        selectedTests: _selectedTests,
                      ),
                    ),
                  );
                },
                borderRadius: 30,
                width: Utils.windowWidth(context) * 0.9,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectableItem extends StatelessWidget {
  const SelectableItem({
    super.key,
    this.onSelect,
    this.selected = false,
    this.item,
    this.selectedItems,
  });
  final bool selected;
  final LabTest? item;
  final List? selectedItems;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: EdgeInsets.only(top: ScallingConfig.verticalScale(12)),
        padding: EdgeInsets.symmetric(
          vertical: ScallingConfig.verticalScale(10),
          horizontal: ScallingConfig.scale(15),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.lightGrey10),
          borderRadius: BorderRadius.circular(25),
        ),
        width: Utils.windowWidth(context) * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selected
                ? SvgWrapper(
                    assetPath: ImagePaths.success,
                    width: ScallingConfig.scale(20),
                    height: ScallingConfig.scale(20),
                  )
                : Icon(
                    Icons.radio_button_unchecked,
                    color: AppColors.darkGreyColor.withAlpha(70),
                  ),
            SizedBox(width: ScallingConfig.scale(10)),
            Expanded(
              child: CustomText(
                text: item?.name ?? "",
                fontFamily: "Gilroy-Medium",
                fontSize: 14.79,
                color: AppColors.grayColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            CustomText(
              text: "\$${item?.price}",
              fontFamily: "Gilroy-SemiBold",
              fontSize: 14.79,
              color: AppColors.primary500,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
