import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/screens/complete_screen.dart';

class ReservationSubmit extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String parkingZoneName;
  final List<Map<String, String>> timeSlots;
  final int fee;

  const ReservationSubmit({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.parkingZoneName,
    required this.timeSlots,
    required this.fee,
  }) : super(key: key);

  @override
  _ReservationSubmitState createState() => _ReservationSubmitState();
}

class _ReservationSubmitState extends State<ReservationSubmit> {
  List<DateTime> selectedDates = [];
  int startHour = 0;
  int startMinute = 0;
  int endHour = 0;
  int endMinute = 0;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      if (selectedDates.contains(day)) {
        selectedDates.remove(day);
      } else {
        selectedDates.add(day);
        selectedDates.sort();
      }
    });
  }

  int calculateFee() {
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;
    final duration = endMinutes - startMinutes;

    if (duration <= 0 || selectedDates.isEmpty) return 0;

    final days = selectedDates.length;
    final hours = duration / 60;
    return (widget.fee * hours * days).round();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.parkingZoneName),
          bottom: const TabBar(
            tabs: [
              Tab(text: '달력'),
              Tab(text: '시간 및 요금'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth,
                          child: TableCalendar(
                            firstDay: DateTime.now(),
                            lastDay: DateTime(2025, 12, 31),
                            focusedDay: DateTime.now(),
                            rangeSelectionMode: RangeSelectionMode.toggledOn,
                            selectedDayPredicate: (day) =>
                                selectedDates.contains(day),
                            onDaySelected: (selectedDay, focusedDay) {
                              _onDaySelected(selectedDay, focusedDay);
                            },
                            calendarStyle: const CalendarStyle(
                              isTodayHighlighted: true,
                              selectedDecoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text("시작 시간"),
                              SizedBox(
                                height: 120,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CupertinoPicker(
                                        itemExtent: 40,
                                        onSelectedItemChanged: (int value) {
                                          setState(() {
                                            startHour = value;
                                          });
                                        },
                                        children:
                                            List<Widget>.generate(24, (index) {
                                          return Center(
                                              child: Text("$index 시"));
                                        }),
                                      ),
                                    ),
                                    Expanded(
                                      child: CupertinoPicker(
                                        itemExtent: 40,
                                        onSelectedItemChanged: (int value) {
                                          setState(() {
                                            startMinute = value * 10;
                                          });
                                        },
                                        children:
                                            List<Widget>.generate(6, (index) {
                                          return Center(
                                              child: Text("${index * 10} 분"));
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              const Text("종료 시간"),
                              SizedBox(
                                height: 120,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CupertinoPicker(
                                        itemExtent: 40,
                                        onSelectedItemChanged: (int value) {
                                          setState(() {
                                            endHour = value;
                                          });
                                        },
                                        children:
                                            List<Widget>.generate(24, (index) {
                                          return Center(
                                              child: Text("$index 시"));
                                        }),
                                      ),
                                    ),
                                    Expanded(
                                      child: CupertinoPicker(
                                        itemExtent: 40,
                                        onSelectedItemChanged: (int value) {
                                          setState(() {
                                            endMinute = value * 10;
                                          });
                                        },
                                        children:
                                            List<Widget>.generate(6, (index) {
                                          return Center(
                                              child: Text("${index * 10} 분"));
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${calculateFee()} 원',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: selectedDates.isNotEmpty
                              ? () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('결제하시겠습니까?'),
                                        content:
                                            Text('결제 금액: ${calculateFee()}원'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.to(() => CompleteScreen(),
                                                  arguments: {
                                                    'type': 'reservation'
                                                  });
                                            },
                                            child: const Text('결제하기'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('결제하기'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
