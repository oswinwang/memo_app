// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Memotile extends StatefulWidget {
  final String momolistname;

  Memotile({
    super.key,
    required this.momolistname,
  });

  @override
  State<Memotile> createState() => _MemotileState();
}

class _MemotileState extends State<Memotile> {
  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.momolistname,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ),
        // ignore: prefer_const_literals_to_create_immutables

      ),
    );
  }
}