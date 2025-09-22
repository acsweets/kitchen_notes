import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../providers/data_provider.dart';
import '../models/cooking_record.dart';
import 'cooking_record_detail_screen.dart';

class CookingCalendarScreen extends StatefulWidget {
  const CookingCalendarScreen({super.key});

  @override
  State<CookingCalendarScreen> createState() => _CookingCalendarScreenState();
}

class _CookingCalendarScreenState extends State<CookingCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('做菜日历'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _focusedDate = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 月份导航
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surfaceVariant,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  '${_focusedDate.year}年${_focusedDate.month}月',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          // 日历网格
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return _buildCalendarGrid(dataProvider);
              },
            ),
          ),

          // 选中日期的记录
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedDate.month}月${_selectedDate.day}日的记录',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      final records = dataProvider.getCookingRecordsByDate(_selectedDate);
                      
                      if (records.isEmpty) {
                        return const Center(
                          child: Text('这一天还没有做菜记录', style: TextStyle(color: Colors.grey)),
                        );
                      }

                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  record.recipeName.substring(0, 1),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(record.recipeName),
                              subtitle: Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < record.rating ? Icons.star : Icons.star_border,
                                        size: 16,
                                        color: Colors.amber,
                                      );
                                    }),
                                  ),
                                  if (record.notes.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    const Icon(Icons.note, size: 16, color: Colors.grey),
                                  ],
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CookingRecordDetailScreen(record: record),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCookingRecord(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendarGrid(DataProvider dataProvider) {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    final monthRecords = dataProvider.getCookingRecordsByMonth(_focusedDate.year, _focusedDate.month);
    final recordsByDay = <int, List<CookingRecord>>{};
    for (var record in monthRecords) {
      final day = record.cookingDate.day;
      recordsByDay[day] = (recordsByDay[day] ?? [])..add(record);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 42, // 6周 * 7天
      itemBuilder: (context, index) {
        // 计算日期
        final dayOffset = index - (firstDayWeekday - 1);
        
        if (dayOffset < 0 || dayOffset >= daysInMonth) {
          return Container(); // 空白格子
        }

        final day = dayOffset + 1;
        final date = DateTime(_focusedDate.year, _focusedDate.month, day);
        final isSelected = _isSameDay(date, _selectedDate);
        final isToday = _isSameDay(date, DateTime.now());
        final dayRecords = recordsByDay[day] ?? [];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primary
                  : isToday 
                      ? AppColors.surfaceVariant
                      : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (dayRecords.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (dayRecords.length > 1) ...[
                        const SizedBox(width: 2),
                        Text(
                          '${dayRecords.length}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _addCookingRecord() {
    showDialog(
      context: context,
      builder: (context) => _AddCookingRecordDialog(
        selectedDate: _selectedDate,
        onSave: (record) {
          Provider.of<DataProvider>(context, listen: false).addCookingRecord(record);
        },
      ),
    );
  }
}

// 添加做菜记录对话框
class _AddCookingRecordDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(CookingRecord) onSave;

  const _AddCookingRecordDialog({
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<_AddCookingRecordDialog> createState() => _AddCookingRecordDialogState();
}

class _AddCookingRecordDialogState extends State<_AddCookingRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _recipeNameController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedRecipeId = '';
  double _rating = 0;
  final List<String> _images = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('添加做菜记录 - ${widget.selectedDate.month}月${widget.selectedDate.day}日'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 选择菜谱或输入菜名
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedRecipeId.isEmpty ? null : _selectedRecipeId,
                        decoration: const InputDecoration(labelText: '选择菜谱（可选）'),
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('不选择菜谱'),
                          ),
                          ...dataProvider.recipes.map<DropdownMenuItem<String>>((recipe) {
                            return DropdownMenuItem<String>(
                              value: recipe.id,
                              child: Text(recipe.name),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRecipeId = value ?? '';
                            if (value != null && value.isNotEmpty) {
                              final recipe = dataProvider.recipes.firstWhere((r) => r.id == value);
                              _recipeNameController.text = recipe.name;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _recipeNameController,
                        decoration: const InputDecoration(labelText: '菜名'),
                        validator: (value) => value?.isEmpty == true ? '请输入菜名' : null,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // 评分
              const Text('评分'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // 制作心得
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: '制作心得（可选）',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // 添加图片
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('添加图片'),
                  ),
                  const SizedBox(width: 8),
                  Text('已选择${_images.length}张图片'),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: _saveCookingRecord,
          child: const Text('保存'),
        ),
      ],
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(image.path);
      });
    }
  }

  void _saveCookingRecord() {
    if (_formKey.currentState!.validate()) {
      final record = CookingRecord(
        id: const Uuid().v4(),
        recipeId: _selectedRecipeId,
        recipeName: _recipeNameController.text,
        cookingDate: widget.selectedDate,
        rating: _rating,
        notes: _notesController.text,
        images: _images,
      );
      
      widget.onSave(record);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}