# 灶边记 UI 组件库

基于设计方案重构的现代化绿色主题组件库。

## 🎨 配色方案

### 主色调
- **主色**: `#4CAF50` - 现代绿色
- **主色容器**: `#E8F5E8` - 淡绿色背景
- **辅助色**: `#A5D6A7` - 柔和绿色

### 状态色
- **成功**: `#4CAF50`
- **警告**: `#FF9800`
- **错误**: `#E53935`

## 🔘 按钮组件

### PrimaryButton
主要操作按钮，支持图标、加载状态和大小变体。

```dart
PrimaryButton(
  text: '保存',
  icon: Icons.save,
  isLarge: true,
  onPressed: () {},
)
```

### SecondaryButton
次要操作按钮，轮廓样式。

```dart
SecondaryButton(
  text: '取消',
  icon: Icons.cancel,
  onPressed: () {},
)
```

### CustomFloatingActionButton
浮动操作按钮，支持扩展样式。

```dart
CustomFloatingActionButton(
  onPressed: () {},
  icon: Icons.add,
  tooltip: '添加菜谱',
)
```

### IconTextButton
图标文字按钮，适用于底部导航。

```dart
IconTextButton(
  icon: Icons.home,
  text: '首页',
  isSelected: true,
  onPressed: () {},
)
```

### ChipButton
筛选按钮，支持选中状态。

```dart
ChipButton(
  label: '川菜',
  isSelected: true,
  icon: Icons.local_fire_department,
  onPressed: () {},
)
```

## 📝 输入框组件

### CustomTextField
标准输入框，继承主题样式。

```dart
CustomTextField(
  labelText: '菜名',
  hintText: '请输入菜名',
  controller: controller,
  onChanged: (value) {},
)
```

### SearchTextField
搜索输入框，圆角样式带清除按钮。

```dart
SearchTextField(
  hintText: '搜索菜谱或食材...',
  controller: controller,
  onChanged: (value) {},
  onClear: () {},
)
```

### NumberInputField
数字输入框，带加减按钮。

```dart
NumberInputField(
  value: 5.0,
  onChanged: (value) {},
  min: 0,
  max: 100,
  step: 0.5,
  unit: 'kg',
)
```

## 🎯 使用指南

1. **导入组件**
```dart
import '../widgets/custom_buttons.dart';
import '../widgets/custom_text_field.dart';
```

2. **使用主题色彩**
```dart
import '../theme/app_colors.dart';

Container(
  color: AppColors.primaryContainer,
  child: Text(
    '内容',
    style: TextStyle(color: AppColors.onPrimaryContainer),
  ),
)
```

3. **使用主题文字样式**
```dart
Text(
  '标题',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

## 📱 响应式设计

所有组件都支持响应式设计，自动适配不同屏幕尺寸：
- 按钮最小高度：48dp（符合Material Design规范）
- 输入框内边距：16dp水平，14dp垂直
- 圆角半径：12dp（按钮）、25dp（搜索框）

## 🔧 自定义扩展

可以通过继承基础组件来创建特定功能的组件：

```dart
class RecipeButton extends PrimaryButton {
  const RecipeButton({
    super.key,
    required super.text,
    super.onPressed,
  }) : super(
    icon: Icons.restaurant_menu,
    isLarge: true,
  );
}
```