import 'package:flutter/material.dart';
import 'package:icare/utils/imagePaths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    // No zoom - just subtle fade in
    _scale = Tween<double>(begin: 1.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Opacity(opacity: _opacity.value,
              child: Transform.scale(scale: _scale.value, child: child)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(ImagePaths.logo, width: 130, height: 130, fit: BoxFit.contain),
            const SizedBox(height: 20),
            const Text('iCare', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800,
                color: Color(0xFF0036BC), fontFamily: 'Gilroy-Bold', letterSpacing: 1.5)),
            const SizedBox(height: 8),
            const Text('Your Virtual Healthcare Platform',
                style: TextStyle(fontSize: 15, color: Color(0xFF64748B), fontFamily: 'Gilroy-Medium')),
          ]),
        ),
      ),
    );
  }
}
