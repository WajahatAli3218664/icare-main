import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/models/lab.dart';
import 'package:icare/screens/book_lab.dart';
import 'package:icare/screens/filters.dart';
import 'package:icare/screens/lab_reports_screen.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/custom_text_input.dart';
import 'package:icare/widgets/lab_widget.dart';
import 'package:icare/widgets/svg_wrapper.dart';

class LabsListScreen extends StatefulWidget {
  const LabsListScreen({super.key});

  @override
  State<LabsListScreen> createState() => _LabsListScreenState();
}

class _LabsListScreenState extends State<LabsListScreen> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Utils.windowWidth(context) > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: const CustomBackButton(),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: "Book a Lab",
          fontFamily: "Gilroy-Bold", 
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF0F172A),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : 20,
                  vertical: 24,
                ),
                color: Colors.white,
                child: Center(
                  child: CustomInputField(
                    width: isDesktop ? 700 : double.infinity,
                    hintText: "Search lab reports, tests, or clinics...", 
                    trailingIcon: SvgWrapper(
                      assetPath: ImagePaths.filters,
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const FiltersScreen()));
                      },
                    ),
                    leadingIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 22),
                  ),
                ),
              ),

              const Expanded(
                child: LabsList(tab: 'book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LabsList extends StatelessWidget {
  final String tab;
  const LabsList({super.key, this.tab = 'book'});
   
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Utils.windowWidth(context) > 600;

    final List<Lab> labs = [
      Lab(
        id: "1",
        title: "Green Lab",
        photo: ImagePaths.lab1,
        delivery: "Home Delivery: 25min",
        address: "20 Cooper Square, USA",
        rating: "4.9",
        tests: [],
      ),
      Lab(
        id: "2",
        title: "City Diagnostics",
        photo: ImagePaths.lab2,
        delivery: "Home Delivery: 40min",
        address: "42 Broadway, USA",
        rating: "4.7",
        tests: [],
      ),
      Lab(
        id: "3",
        title: "Sunrise Medical Lab",
        photo: ImagePaths.lab1,
        delivery: "Home Delivery: 30min",
        address: "7 Park Avenue, USA",
        rating: "4.8",
        tests: [],
      ),
      Lab(
        id: "4",
        title: "HealthFirst Labs",
        photo: ImagePaths.lab2,
        delivery: "Home Delivery: 20min",
        address: "15 Elm Street, USA",
        rating: "4.6",
        tests: [],
      ),
    ];

    final actionText = tab == 'book' ? 'Book a Lab' : 'View Reports';

    if (isDesktop) {
      return GridView.builder(
        padding: const EdgeInsets.all(40),
        itemCount: labs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 340,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
        ),
        itemBuilder: (ctx, i) {
          return LabWidget(
            lab: labs[i],
            actionText: actionText,
            onActionBtnPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => tab == 'book'
                      ? BookLabScreen(labId: labs[i].id, labTitle: labs[i].title)
                      : LabReportsScreen(),
                ),
              );
            },
          );
        },
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: ScallingConfig.scale(14),
        vertical: 20,
      ),
      itemCount: labs.length,
      itemBuilder: (ctx, i) {
        return LabWidget(
          lab: labs[i],
          actionText: actionText,
          onActionBtnPressed: () {
            Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => tab == 'book'
                  ? BookLabScreen(labId: labs[i].id, labTitle: labs[i].title)
                  : LabReportsScreen(),
            ),
            );
          },
        );
      },
    );
  }
}


