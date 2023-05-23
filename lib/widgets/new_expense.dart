import 'package:flutter/material.dart';
import '../models/expense.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense expense) toAddExpense;
  const NewExpense(this.toAddExpense, {super.key});
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // var entered = '';
  // void _saveTitleInput(String received) {
  //   entered = received;
  // }
  final _titleController = TextEditingController(),
      _amtController = TextEditingController();
  DateTime? selectedDate;
  Category _selectedCategory = Category.leisure;
  @override
  void dispose() {
    _titleController.dispose();
    _amtController.dispose();
    super.dispose();
  }

  void _presentDatePicker() {
    final now = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    ).then(
      (value) => setState(() {
        selectedDate = value;
      }),
    );
  }

  void _submitExpenseData() {
    final titleReceived = _titleController.text.trim();
    final amtReceived = double.tryParse(_amtController.text);
    if (titleReceived.isEmpty ||
        amtReceived == null ||
        amtReceived <= 0 ||
        selectedDate == null) {
      // Error msg
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Alert!'),
            content: const Text('Please enter a valid title, amount and date'),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay!'),
              ),
            ],
          );
        },
      );
      return;
    }
    widget.toAddExpense(Expense(
      amount: amtReceived,
      date: selectedDate!,
      category: _selectedCategory,
      title: titleReceived,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            // onChanged: _saveTitleInput,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amtController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '₹ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      selectedDate == null
                          ? 'No date selected'
                          : formatter.format(selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            categoryIcons[category]!,
                            const SizedBox(width: 5),
                            Text(
                              category.name.toUpperCase(),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
