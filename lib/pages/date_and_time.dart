import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sum/widgets/build_button.dart';
import 'package:sum/widgets/top_bar.dart';

class DateAndTime extends StatefulWidget {
  const DateAndTime({super.key});

  @override
  State<DateAndTime> createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateAndTime> {
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();
  final TextEditingController _timeStartController = TextEditingController();
  final TextEditingController _timeEndController = TextEditingController();
  final PageController _pageController = PageController();
  bool _includeEndDay = false;
  bool _isDatePageSelected = true;
  String _daysPassed = '';
  String _timePassed  = '';

  // format date input with dd.mm.yyyy format inside textfield
  String _formatDateInput(String value) {
    // remove dots from string
    String text = value.replaceAll('.', '');

    if(text.length > 2 && text.length <= 4) {
      // text length > 2 and <= 4
      // insert dot after the day
      text = '${text.substring(0, 2)}.${text.substring(2)}';
    } else if(text.length > 4) {
      // text length > 4
      // insert dots after the day and month
      text = '${text.substring(0, 2)}.${text.substring(2, 4)}.${text.substring(4)}';
    }

    return text;
  }

  // format time input with HH:mm format inside textfield
  String _formatTimeInput(String value) {
    // remove : from String
    String text = value.replaceAll(':', '');

    if(text.length <= 2) {
      return text;
    }
    return '${text.substring(0, 2)}:${text.substring(2)}';
  }

  void calculateDifferenceBetweenDates(String firstDateStr, String secondDateStr) {
    // make sure dates are in correct format
    if(_validateFormat(_dateStartController.text, 'dd.MM.yyyy') && 
      _validateFormat(_dateEndController.text, 'dd.MM.yyyy')
      ) {
      int daysDifference = 0;
      // parse dates from String to the DateTime correct format 
      DateTime firstDate = _parseDate(firstDateStr);
      DateTime secondDate = _parseDate(secondDateStr);

      Duration difference = secondDate.difference(firstDate);

      if(_includeEndDay) {
        // include end day
        if(difference.inDays < 0) {
          daysDifference = difference.inDays - 1;
        } else if (difference.inDays > 0) {
          daysDifference = difference.inDays + 1;
        } else {
          daysDifference = difference.inDays + 1;
        }
      } else {
        // do not include end day
        daysDifference = difference.inDays;
      }
      setState(() {
        _daysPassed = '$daysDifference days';
      });
    }
  }

  void calculateDifferenceBetweenTime(String firstTimeStr, String secondTimeStr){
    if(_validateFormat(_timeStartController.text, 'HH:mm') &&
      _validateFormat(_timeEndController.text, 'HH:mm')
    ) {
      // parse time from String to the DateTime correct format
      DateTime firstTime = _parseTime(firstTimeStr);
      DateTime secondTime = _parseTime(secondTimeStr);

      // if end time is before start time 
      if(secondTime.isBefore(firstTime)) {
        secondTime = secondTime.add(Duration(days: 1));
      }

      Duration difference = secondTime.difference(firstTime);
      int hours = difference.inHours;
      int mins = difference.inMinutes.remainder(60);

      String formattedOutput = '';
      if(hours > 0) formattedOutput +='$hours hour${hours > 1 ? 's' : ''} ';
      if(mins > 0) formattedOutput += '$mins minute${mins > 1 ? 's' : ''}';

      setState(() {
        _timePassed = formattedOutput.trim();
      });
    }
  }

  // validate String to correct DateTime format (e.g HH:mm)
  bool _validateFormat(String value, String requiredFormat) {
    try {
      final format = DateFormat(requiredFormat);
      format.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  // parse date in correct format (year, month, day)
  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('.');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  DateTime _parseTime(String timeStr) {
    final format = DateFormat('HH:mm');
    return format.parse(timeStr);
  }

  Widget _buildTextField({
    required bool isDate,
    required int maxLength,
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required Function(String) formatInput,
  }) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          counterText: '',
          labelStyle: TextStyle(
            color: Theme.of(context).disabledColor
          ),
          hintStyle: TextStyle(
            color: Theme.of(context).disabledColor
          ),
          border: InputBorder.none
        ),
        onChanged: (String value) {
          setState(() {
            _daysPassed = '';
            _timePassed = '';
          });
          final newValue = formatInput(value);
          if(newValue != value) {
            controller.value = TextEditingValue(
              text: newValue,
              selection: TextSelection.collapsed(offset: newValue.length)
            );
          }
          if(isDate) {
            calculateDifferenceBetweenDates(_dateStartController.text, _dateEndController.text);
          } else {
            calculateDifferenceBetweenTime(_timeStartController.text, _timeEndController.text);
          }
        },
        keyboardType: TextInputType.number,
      )
    );
  }

  // switch between date and time pages 
  void _openPage(int index) {
    _pageController.animateToPage(
      index, 
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut
    );
  }

  Widget _resultPlaceholder(String result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Chip(
        label: Text(
          result,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).disabledColor,
            width: 1
          )
        ),
      )
    );
  }

  // date page
  Widget datePage() {
    return Column(
      children: [
        SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: Text('Start Date')
        ),
        // start date text field
        _buildTextField(
          isDate: true,
          maxLength: 10,
          controller: _dateStartController,
          labelText: 'Start Date',
          hintText: 'dd.mm.yyyy',
          formatInput: _formatDateInput,
        ),
        Align(
          alignment: Alignment.center,
          child: Text('End Date')
        ),
        // end date text field
        _buildTextField(
          isDate: true,
          maxLength: 10,
          controller: _dateEndController,
          labelText: 'End Date',
          hintText: 'dd.mm.yyyy',
          formatInput: _formatDateInput,
        ),
        // include end day checkbox
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Row(
            children: [
              Checkbox(
                value: _includeEndDay, 
                onChanged: (bool? value) {
                  setState(() {
                    _includeEndDay = value!;
                  });
                  calculateDifferenceBetweenDates(_dateStartController.text, _dateEndController.text);
                }
              ),
              const Text('Include End Day')
            ],
          ),
        ),
        // placeholder with the duration in days between dates
        if(_daysPassed.isNotEmpty)
          _resultPlaceholder(_daysPassed)
      ],
    );
  }

  // time page 
  Widget timePage() {
    return Column(
      children: [
        SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: Text('Start Time')
        ),
        _buildTextField(
          isDate: false,
          maxLength: 5,
          controller: _timeStartController, 
          labelText: 'Start Time',
          hintText: 'HH:mm',
          formatInput: _formatTimeInput
        ),
        Align(
          alignment: Alignment.center,
          child: Text('End Time')
        ),
        _buildTextField(
          isDate: false,
          maxLength: 5,
          controller: _timeEndController, 
          labelText: 'End Time',
          hintText: 'HH:mm',
          formatInput: _formatTimeInput
        ),
        // placeholder with the duration in days between dates
        if(_timePassed.isNotEmpty)
          _resultPlaceholder(_timePassed)
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            topBar(
              context: context, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back button
                  buildIconButton(
                    context: context, 
                    onTap: () {
                      Navigator.pop(context);
                    }, 
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icons.arrow_back
                  ),
                  Text('Date & Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  SizedBox(width: 48),
                ],
              )
            ),
            // slide buttons
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDatePageSelected = !_isDatePageSelected;
                  if(_isDatePageSelected) {
                    _openPage(0);
                  } else {
                    _openPage(1);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      alignment: _isDatePageSelected ? Alignment.centerLeft : Alignment.centerRight, 
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Center(child: Text('Date'))),
                        Expanded(child: Center(child: Text('Time'))),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  datePage(),
                  timePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}