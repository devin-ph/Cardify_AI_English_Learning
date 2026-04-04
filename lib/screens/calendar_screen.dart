import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  late List<int> _studiedDays;
  late int _currentStreak;

  @override
  void initState() {
    super.initState();
    _generateFakeData();
  }

  void _generateFakeData() {
    int daysInMonth = DateUtils.getDaysInMonth(
      _focusedDay.year,
      _focusedDay.month,
    );
    _studiedDays = List.generate(
      daysInMonth,
      (i) => i + 1,
    ).where((d) => d % 2 == 0 || d % 3 == 0).toList();
    _currentStreak = _calculateCurrentStreak();
  }

  int _calculateCurrentStreak() {
    int streak = 0;
    final now = DateTime.now();
    if (_focusedDay.year != now.year || _focusedDay.month != now.month) {
      return 0;
    }

    int day = now.day;
    while (day > 0 && _studiedDays.contains(day)) {
      streak++;
      day--;
    }
    return streak;
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + offset);
      _generateFakeData();
    });
  }

  Future<void> _openMonthYearPicker() async {
    int selectedYear = _focusedDay.year;
    int selectedMonth = _focusedDay.month;
    final currentYear = DateTime.now().year;
    final years = List.generate(9, (index) => currentYear - 4 + index);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              titlePadding: const EdgeInsets.fromLTRB(18, 16, 12, 8),
              contentPadding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
              title: const Text(
                'Đổi tháng học',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              content: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: selectedYear,
                      decoration: const InputDecoration(
                        labelText: 'Năm',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: years
                          .map(
                            (year) => DropdownMenuItem<int>(
                              value: year,
                              child: Text('$year'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setDialogState(() => selectedYear = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 2.25,
                          ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isSelected = month == selectedMonth;
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () =>
                              setDialogState(() => selectedMonth = month),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1D3557)
                                  : const Color(0xFFF4F7FB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1D3557)
                                    : const Color(0xFFDDE5EE),
                              ),
                            ),
                            child: Text(
                              'Tháng $month',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1D3557),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Hủy'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(selectedYear, selectedMonth);
                      _generateFakeData();
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Áp dụng'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateUtils.getDaysInMonth(
      _focusedDay.year,
      _focusedDay.month,
    );
    DateTime firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    int startWeekday = firstDayOfMonth.weekday; // 1 (Mon) -> 7 (Sun)
    int totalCells = daysInMonth + (startWeekday - 1);
    int rows = ((totalCells) / 7).ceil();
    int gridCount = rows * 7;
    final monthLabel = DateFormat('MMMM yyyy').format(_focusedDay);
    final totalStudyDays = _studiedDays.length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Lịch học',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1D3557),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFCEE9FF), Color(0xFFE3F5EA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFD4E6F7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: Color(0xFFFF7B2F),
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Chuỗi ngày học: $_currentStreak ngày',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D3557),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$totalStudyDays ngày trong tháng',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4A6077),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(7, (index) {
                          final today = DateTime.now();
                          final date = today.subtract(
                            Duration(days: 6 - index),
                          );
                          final isCurrentMonth =
                              date.year == _focusedDay.year &&
                              date.month == _focusedDay.month;
                          final studied =
                              isCurrentMonth && _studiedDays.contains(date.day);
                          final isToday =
                              date.day == today.day &&
                              date.month == today.month &&
                              date.year == today.year;

                          return Container(
                            width: 36,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? const Color(0xFF1D3557)
                                  : studied
                                  ? const Color(0xFF2CB67D)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: studied
                                    ? const Color(0xFF2CB67D)
                                    : const Color(0xFFD8E1EA),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('E').format(date).substring(0, 2),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isToday || studied
                                        ? Colors.white
                                        : const Color(0xFF516476),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: isToday || studied
                                        ? Colors.white
                                        : const Color(0xFF1D3557),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE1E7EE)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _changeMonth(-1),
                        icon: const Icon(Icons.chevron_left_rounded),
                        tooltip: 'Tháng trước',
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: _openMonthYearPicker,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 18,
                                  color: Color(0xFF1D3557),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  monthLabel,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xFF1D3557),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _changeMonth(1),
                        icon: const Icon(Icons.chevron_right_rounded),
                        tooltip: 'Tháng sau',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE1E7EE)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            'T2',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'T3',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'T4',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'T5',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'T6',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'T7',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'CN',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6,
                              childAspectRatio: 1.05,
                            ),
                        itemCount: gridCount,
                        itemBuilder: (context, index) {
                          int dayNum = index - (startWeekday - 1) + 1;
                          bool isValidDay = dayNum > 0 && dayNum <= daysInMonth;
                          bool studied =
                              isValidDay && _studiedDays.contains(dayNum);
                          bool isToday =
                              isValidDay &&
                              _focusedDay.year == DateTime.now().year &&
                              _focusedDay.month == DateTime.now().month &&
                              dayNum == DateTime.now().day;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              color: !isValidDay
                                  ? Colors.transparent
                                  : isToday
                                  ? const Color(0xFF1D3557)
                                  : studied
                                  ? const Color(0xFFE9F8F1)
                                  : const Color(0xFFF7FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: isValidDay
                                  ? Border.all(
                                      color: studied
                                          ? const Color(0xFF8FDDBD)
                                          : const Color(0xFFE4EAF1),
                                    )
                                  : null,
                            ),
                            child: isValidDay
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$dayNum',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: isToday
                                              ? Colors.white
                                              : const Color(0xFF1D3557),
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Icon(
                                        studied
                                            ? Icons.check_circle
                                            : Icons.remove_circle_outline,
                                        size: 13,
                                        color: isToday
                                            ? Colors.white
                                            : studied
                                            ? const Color(0xFF2CB67D)
                                            : const Color(0xFFB4C2CF),
                                      ),
                                    ],
                                  )
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _LegendDot(color: const Color(0xFF2CB67D), label: 'Đã học'),
                    const SizedBox(width: 14),
                    const _LegendDot(
                      color: Color(0xFF1D3557),
                      label: 'Hôm nay',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF516476),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
