import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700)),
      ),
      body: Center(
        child: Text('Notifications', style: GoogleFonts.inter(fontSize: 16)),
      ),
    );
  }
}
