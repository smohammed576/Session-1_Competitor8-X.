import 'package:flutter/material.dart';
import 'package:x2048_the_modern_edition/constants/colors.dart';

class MainButton extends StatelessWidget{
  final String text;
  final double fontsize;
  final VoidCallback onTap;

  const MainButton({super.key, required this.text, required this.fontsize, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        // shape: ContinuousRectangleBorder(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: AppColors.empty
      ),
      onPressed: onTap,
      child: Text(text, style: TextStyle(
        fontSize: fontsize,
        color: AppColors.whitecolor,
        fontWeight: FontWeight.bold
      ),),
    );
  }
}