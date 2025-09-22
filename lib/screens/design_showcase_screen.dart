import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_buttons.dart';

class DesignShowcaseScreen extends StatefulWidget {
  const DesignShowcaseScreen({super.key});

  @override
  State<DesignShowcaseScreen> createState() => _DesignShowcaseScreenState();
}

class _DesignShowcaseScreenState extends State<DesignShowcaseScreen> {
  final _textController = TextEditingController();
  final _searchController = TextEditingController();
  double _numberValue = 5.0;
  bool _isSelected1 = false;
  bool _isSelected2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设计组件展示'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 颜色展示
          _buildSection('配色方案', [
            _buildColorRow('主色调', AppColors.primary),
            _buildColorRow('主色容器', AppColors.primaryContainer),
            _buildColorRow('辅助色', AppColors.secondary),
            _buildColorRow('表面色', AppColors.surface),
            _buildColorRow('背景色', AppColors.background),
            _buildColorRow('错误色', AppColors.error),
            _buildColorRow('警告色', AppColors.warning),
          ]),

          const SizedBox(height: 32),

          // 文字样式展示
          _buildSection('文字样式', [
            Text('特大标题', style: Theme.of(context).textTheme.displayLarge),
            Text('大标题', style: Theme.of(context).textTheme.displayMedium),
            Text('页面标题', style: Theme.of(context).textTheme.displaySmall),
            Text('卡片标题', style: Theme.of(context).textTheme.headlineLarge),
            Text('小标题', style: Theme.of(context).textTheme.headlineMedium),
            Text('正文大', style: Theme.of(context).textTheme.bodyLarge),
            Text('正文', style: Theme.of(context).textTheme.bodyMedium),
            Text('辅助文字', style: Theme.of(context).textTheme.bodySmall),
          ]),

          const SizedBox(height: 32),

          // 按钮展示
          _buildSection('按钮组件', [
            PrimaryButton(
              text: '主要按钮',
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: '大按钮',
              icon: Icons.add,
              isLarge: true,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: '加载中',
              isLoading: true,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: '次要按钮',
              icon: Icons.edit,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: IconTextButton(
                    icon: Icons.home,
                    text: '首页',
                    isSelected: _isSelected1,
                    onPressed: () {
                      setState(() {
                        _isSelected1 = !_isSelected1;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: IconTextButton(
                    icon: Icons.favorite,
                    text: '收藏',
                    isSelected: _isSelected2,
                    onPressed: () {
                      setState(() {
                        _isSelected2 = !_isSelected2;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: IconTextButton(
                    icon: Icons.settings,
                    text: '设置',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChipButton(
                  label: '川菜',
                  isSelected: true,
                  onPressed: () {},
                ),
                ChipButton(
                  label: '粤菜',
                  onPressed: () {},
                ),
                ChipButton(
                  label: '湘菜',
                  icon: Icons.local_fire_department,
                  onPressed: () {},
                ),
              ],
            ),
          ]),

          const SizedBox(height: 32),

          // 输入框展示
          _buildSection('输入框组件', [
            CustomTextField(
              controller: _textController,
              labelText: '标准输入框',
              hintText: '请输入内容',
            ),
            const SizedBox(height: 16),
            SearchTextField(
              controller: _searchController,
              hintText: '搜索菜谱或食材...',
              onChanged: (value) {},
              onClear: () {
                _searchController.clear();
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: '多行输入框',
              hintText: '请输入详细描述...',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: '禁用状态',
              hintText: '不可编辑',
              enabled: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: '错误状态',
              errorText: '这是一个错误提示',
            ),
            const SizedBox(height: 16),
            NumberInputField(
              value: _numberValue,
              onChanged: (value) {
                setState(() {
                  _numberValue = value;
                });
              },
              min: 0,
              max: 100,
              step: 0.5,
              unit: 'kg',
            ),
          ]),

          const SizedBox(height: 32),

          // 卡片展示
          _buildSection('卡片组件', [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('卡片标题', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('这是卡片内容，展示了新的设计风格。', 
                         style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SecondaryButton(
                          text: '取消',
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        PrimaryButton(
                          text: '确定',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),

          const SizedBox(height: 100), // 为浮动按钮留空间
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {},
        icon: Icons.add,
        tooltip: '添加',
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildColorRow(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  '#${color.value.toRadixString(16).toUpperCase().substring(2)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}