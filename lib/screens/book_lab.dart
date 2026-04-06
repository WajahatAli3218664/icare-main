import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:icare/screens/select_test.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/custom_text_input.dart';
import 'package:icare/widgets/svg_wrapper.dart';
import 'package:intl/intl.dart';

class BookLabScreen extends StatefulWidget {
  final String? labId;
  final String? labTitle;
  const BookLabScreen({super.key, this.labId, this.labTitle});

  @override
  State<BookLabScreen> createState() => _BookLabScreenState();
}

class _BookLabScreenState extends State<BookLabScreen> {
  var _selectedDate = '';
  var _selectedTime = "";
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _homeSample = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        title: CustomText(
          text: "Book A Lab",
          fontFamily: "Gilroy-Bold",
          fontSize: 18,
          color: AppColors.darkGray500,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: ScallingConfig.verticalScale(15)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  boxShadow: BoxShadow(offset: Offset(0, 0)),
                  borderRadius: 35,
                  labelWidth: Utils.windowWidth(context) * 0.35,

                  // outlined: true,
                  borderColor: AppColors.veryLightGrey,
                  height: Utils.windowHeight(context) * 0.045,
                  width: Utils.windowWidth(context) * 0.4,
                  bgColor: AppColors.veryLightGrey,

                  label: _selectedDate.isNotEmpty
                      ? _selectedDate
                      : "Select Date",
                  labelColor: AppColors.primaryColor,
                  labelSize: 11,
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = DateFormat("yyyy/MM/dd").format(date);
                      });
                    }
                  },
                  trailingIcon: Align(
                    // alignment: AlignmentGeometry.xy(5, 0),
                    child: SvgWrapper(assetPath: ImagePaths.calendar),
                  ),
                ),
                SizedBox(width: ScallingConfig.scale(10)),
               CustomButton(
                  boxShadow: BoxShadow(offset: Offset(0, 0)),
                  borderRadius: 35,
                  labelWidth: Utils.windowWidth(context) * 0.35,

                  // outlined: true,
                  borderColor: AppColors.veryLightGrey,
                  height: Utils.windowHeight(context) * 0.045,
                  width: Utils.windowWidth(context) * 0.4,
                  bgColor: AppColors.veryLightGrey,

                  label: _selectedDate.isNotEmpty
                      ? _selectedDate
                      : "Select Date",
                  labelColor: AppColors.primaryColor,
                  labelSize: 11,
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _selectedTime = time.format(context);
                      });
                    }
                  },
                  trailingIcon: Align(
                    // alignment: AlignmentGeometry.xy(5, 0),
                    child: SvgWrapper(assetPath: ImagePaths.clock),
                  ),
                ),

              ],
            ),

            CustomInputField(
              controller: _cityController,
              width: Utils.windowWidth(context) * 0.9,
              hintText: "City",
              hintStyle: TextStyle(
                color: AppColors.grayColor.withAlpha(60),
                fontFamily: "Gilroy-SemiBold",
                fontSize: 12,
              ),
              margin: EdgeInsets.only(top:ScallingConfig.verticalScale(15)),
              borderRadius: 28,
              borderColor: AppColors.grayColor.withAlpha(70),
            ),

            CustomInputField(
              controller: _addressController,
              width: Utils.windowWidth(context) * 0.9,
              hintText: "Address",
              hintStyle: TextStyle(
                color: AppColors.grayColor.withAlpha(60),
                fontFamily: "Gilroy-SemiBold",
                fontSize: 12,
              ),
              margin: EdgeInsets.only(top:ScallingConfig.verticalScale(15)),
              // padding: EdgeInsets.only(left: ScallingConfig.scale(25), top: ScallingConfig.scale(10)),
              // height: Utils.windowHeight(context) * 0.15,
              // maxLines: 50,
              borderRadius: 26,
              borderColor: AppColors.grayColor.withAlpha(70),
            ),
            const SizedBox(height: 15),
              Container(
                width: Utils.windowWidth(context) * 0.9,
                height: ScallingConfig.scale(50),
               padding: EdgeInsets.symmetric(horizontal: ScallingConfig.scale(12), vertical: ScallingConfig.verticalScale(10) ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.grayColor.withAlpha(70)
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 20),
                    CustomText(
                      text: "Home Sample",
                      fontFamily: "Gilroy-Medium",
                      fontSize: 14.78,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grayColor,
                    ),
                    const Spacer(),
                    FlutterSwitch(
                      width: 45.0,
                      height: 25.0,
                      toggleSize: 20.0,
                      value: _homeSample,
                      borderRadius: 30.0,
                      padding: 2.0,
                      activeColor: AppColors.primaryColor,
                      onToggle: (val) {
                        setState(() {
                          _homeSample = val;
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              SizedBox(height: ScallingConfig.scale(15),  ),
              CustomButton(
              onPressed: () {
                if (_selectedDate.isEmpty || _selectedTime.isEmpty || _addressController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all details')),
                  );
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SelectTest(
                      bookingData: {
                        'labId': widget.labId ?? '1',
                        'labTitle': widget.labTitle ?? 'Green Lab',
                        'date': _selectedDate,
                        'time': _selectedTime,
                        'city': _cityController.text,
                        'address': _addressController.text,
                        'homeSample': _homeSample,
                      },
                    ),
                  ),
                );
              },
              width: Utils.windowWidth(context) * 0.9,
              label: "Select Test ",
              borderRadius: 30,
            ),

          ],
        ),
      ),
    );
  }
}
