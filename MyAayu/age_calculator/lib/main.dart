import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Required for the Timer

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Age calculator application..!",
      theme: ThemeData(primarySwatch: Colors.orange),
      // 1. We start with the WelcomePage now
      home: WelcomePage(),
    );
  }
}

// 2. Changed WelcomePage to StatefulWidget to handle the Timer
class WelcomePage extends StatefulWidget{
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
    // 3. This is the 3-second timer logic
    Timer(Duration(seconds: 3), () {
      // Use pushReplacement so the user can't go 'back' to the welcome screen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF90CAF9),
        child: Center(
          child: Text(
            "Welcome..!",
            style: TextStyle(
                fontFamily: "Welcome",
                fontSize:100,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedDate;
  int ageYears = 0;
  int ageDays = 0;
  int ageMonths = 0;

  void _calculateAge(DateTime birthDate) {
    DateTime now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += 12;
    }
    if (days < 0) {
      final daysInLastMonth = DateTime(now.year, now.month, 0).day;
      days += daysInLastMonth;
      months--;
    }
    setState(() {
      ageYears = years;
      ageMonths = months;
      ageDays = days;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      // Calculate automatically after picking
      _calculateAge(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Age calculator..!",style: TextStyle(fontFamily: "Welcome",fontSize:30, fontWeight: FontWeight.bold,color: Colors.white))),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF141E30),
              Color(0xFF243B55),
            ],
          ),
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only( left:30),
              child: Text("Select Your Date Of Birth :",style: TextStyle(fontFamily: "Welcome",fontSize:30, fontWeight: FontWeight.bold,color: Colors.white)),
            ),
            SizedBox(height:10,),
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 30),
                child: Container(
                  width:double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border:Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                        _selectedDate == null
                            ? "Select Date"
                            : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",style: TextStyle(fontFamily: "Welcome",fontSize:30, fontWeight: FontWeight.bold,color: Colors.white)
                    ),
                  ),

                ),
              ),
            ),
            SizedBox(height: 50,),
            Center(child: Text( _selectedDate == null
                ? ""
                :"You are $ageYears years\n$ageMonths month \n $ageDays days old...!",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Welcome",fontSize:40, fontWeight: FontWeight.bold,color: Colors.white),)),
            SizedBox(height: 80,),
            InkWell(
              onTap: (){
                setState(() {
                  _selectedDate= null;
                  ageYears = 0;
                  ageMonths = 0;
                  ageDays = 0;
                });
              },
              child:  Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Center(child:Text("Clear",style: TextStyle(fontFamily: "Welcome",fontSize:35, fontWeight: FontWeight.bold,color: Color(0xFF243B55),)) ,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}