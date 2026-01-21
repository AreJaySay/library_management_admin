import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';

import '../../../models/attendances.dart';
import '../../widgets/button.dart'; // Import the library

class WeeklyReports extends StatefulWidget {
  @override
  _WeeklyReportsState createState() => _WeeklyReportsState();
}

class _WeeklyReportsState extends State<WeeklyReports> {
  final Materialbutton _materialbutton = new Materialbutton();
  DateTime _selectedDate = DateTime.now();
  DatePeriod? _selectedWeek;

  final DateTime _firstDate = DateTime.now().subtract(const Duration(days: 365));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    // Initialize the selected week based on the current date
    _selectedWeek = _calculateWeekPeriod(_selectedDate);
  }

  // Helper method to calculate the start and end dates of a week
  DatePeriod _calculateWeekPeriod(DateTime date) {
    // Assuming the week starts on Monday (DateTime.monday = 1)
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - DateTime.monday));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    return DatePeriod(startOfWeek, endOfWeek);
  }

  void _onWeekChanged(DatePeriod period) {
    setState(() {
      _selectedWeek = period;
      // You can now access the start and end dates of the week
      print('Selected Week Start: ${_selectedWeek!.start}');
      print('Selected Week End: ${_selectedWeek!.end}');
      // Store this data or use it to fetch associated data from your backend
      _selectedDate = period.start; // Update selected date to the start of the new week for UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Column(
        children: [
          WeekPicker(
            selectedDate: _selectedDate,
            onChanged: _onWeekChanged,
            firstDate: _firstDate,
            lastDate: _lastDate,
            datePickerStyles: DatePickerRangeStyles(
              selectedSingleDateDecoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
              ),
            ),
          ),
          Spacer(),
          _materialbutton.materialButton("Continue", (){
            Navigator.of(context).pop(null);
            List _res = attendanceModel.valueSearch.where((s){
              return DateTime.parse(s.first["date_time"]).isAfter(_selectedWeek!.start) && DateTime.parse(s.first["date_time"]).isBefore(_selectedWeek!.end);
            }).toList();
            attendanceModel.update(data: _res);
          }),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}