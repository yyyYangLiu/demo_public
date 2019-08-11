


import 'package:demo/CustomItem/CustomDialogAnswerPage.dart';
import 'package:flutter/material.dart';

AnswerDialog (context) {

   _showDialog() async {
     await showDialog(
         context: context,
         builder: (_) =>Center(
             child: Container(
                 height: 500,
                 child: CustomDialogAnswerPage())),
     );
   }

  return _showDialog();
}