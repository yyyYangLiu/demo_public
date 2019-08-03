

import 'package:flutter/material.dart';

class CustomDaySelector extends StatefulWidget {
  static const modeFull = monday | tuesday | wednesday | thursday | friday | saturday | sunday;
  static const modeWorkdays = monday | tuesday | wednesday | thursday | friday | saturday;
  static const monday = 2;
  static const tuesday = 4;
  static const wednesday = 8;
  static const thursday = 16;
  static const friday = 32;
  static const saturday = 64;
  static const sunday = 128;
  final int mode;
  final Color color;
  final int value;
  final Function(int) onChange;

  const CustomDaySelector({Key key, this.mode = modeWorkdays, this.onChange, this.color, this.value}) : super(key: key);

  @override
  DaySelectorState createState() {
    return DaySelectorState();
  }
}

class DaySelectorState extends State<CustomDaySelector> {
  var _selectedDays = 1; // no day selected

  int get selectedDays => _selectedDays == 1 ? null : _selectedDays;

  bool _isDayAllowed(int day) {
    return widget.mode & day == day;
  }

  @override
  void initState() {
    _selectedDays = widget.value ?? 1;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomDaySelector oldWidget) {
    if (_selectedDays != widget.value) {
      _selectedDays = widget.value ?? 1;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final days = <Widget>[];
    final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final values = [
      CustomDaySelector.monday,
      CustomDaySelector.tuesday,
      CustomDaySelector.wednesday,
      CustomDaySelector.thursday,
      CustomDaySelector.friday,
      CustomDaySelector.saturday,
      CustomDaySelector.sunday,
    ];

    _Day _getDay(int index) {
      return _Day(
        color: widget.color,
        label: labels[index],
        selected: _selectedDays & values[index] == values[index],
        value: values[index],
        onTap: (value) {
          setState(() {
            if (_selectedDays & value == value) {
              _selectedDays &= ~value;
            } else {
              _selectedDays |= value;
            }
            if (widget.onChange != null) {
              widget.onChange(_selectedDays);
            }
          });
        },
      );
    }

    if (_isDayAllowed(CustomDaySelector.monday)) {
      days.add(_getDay(0));
    }
    if (_isDayAllowed(CustomDaySelector.tuesday)) {
      days.add(_getDay(1));
    }
    if (_isDayAllowed(CustomDaySelector.wednesday)) {
      days.add(_getDay(2));
    }
    if (_isDayAllowed(CustomDaySelector.thursday)) {
      days.add(_getDay(3));
    }
    if (_isDayAllowed(CustomDaySelector.friday)) {
      days.add(_getDay(4));
    }
    if (_isDayAllowed(CustomDaySelector.saturday)) {
      days.add(_getDay(5));
    }
    if (_isDayAllowed(CustomDaySelector.sunday)) {
      days.add(_getDay(6));
    }

    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: days,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class _Day extends StatelessWidget {
  final Color color;
  final bool selected;
  final String label;
  final int value;
  final Function(int) onTap;

  const _Day({Key key, this.color, this.label, this.selected = false, this.value, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return RawMaterialButton(
      onPressed: () {
        onTap(value);
      },
      elevation: selected ? 4 : 2,
      constraints: BoxConstraints(minWidth: 40, minHeight: 40),
      fillColor: selected ? Colors.red : color,
      textStyle: Theme.of(context).textTheme.button,
      child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black)),
      shape: CircleBorder(side: BorderSide.none),
    );
  }
}
