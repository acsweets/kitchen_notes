import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import '../models/recipe.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: const Text('社区'),
        backgroundColor: const Color(0xFFE8D5B7),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '推荐'),
            Tab(text: '最新'),
            Tab(text: '热门'),
            Tab(text: '关注'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searchQuery.isNotEmpty) _buildSearchHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRecommendedTab(),
                _buildLatestTab(),
                _buildPopularTab(),
                _buildFollowingTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 跳转到发布菜谱页面
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('发布菜谱功能开发中...')),
          );
        },
        backgroundColor: const Color(0xFFB8860B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '搜索: $_searchQuery',
              style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedTab() {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final recipes = _getFilteredRecipes(dataProvider.topRatedRecipes);
        
        if (recipes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('暂无推荐菜谱', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecipeHeader(recipe),
                  const SizedBox(height: 8),
                  RecipeCard(
                    recipe: recipe,
                    onTap: () => _navigateToRecipeDetail(recipe),
                  ),
                  const SizedBox(height: 8),
                  _buildRecipeActions(recipe),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLatestTab() {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final recipes = _getFilteredRecipes(dataProvider.recentRecipes);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecipeHeader(recipe),
                  const SizedBox(height: 8),
                  RecipeCard(
                    recipe: recipe,
                    onTap: () => _navigateToRecipeDetail(recipe),
                  ),
                  const SizedBox(height: 8),
                  _buildRecipeActions(recipe),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPopularTab() {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final recipes = _getFilteredRecipes(dataProvider.frequentRecipes);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecipeHeader(recipe),
                  const SizedBox(height: 8),
                  RecipeCard(
                    recipe: recipe,
                    onTap: () => _navigateToRecipeDetail(recipe),
                  ),
                  const SizedBox(height: 8),
                  _buildRecipeActions(recipe),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFollowingTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('关注功能开发中...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRecipeHeader(Recipe recipe) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFB8860B),
          child: Text(
            recipe.name.isNotEmpty ? recipe.name[0] : '?',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '美食达人', // 实际应该从用户信息获取
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                _formatDate(recipe.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        if (recipe.tags.isNotEmpty)
          Wrap(
            spacing: 4,
            children: recipe.tags.take(2).map((tag) => Chip(
              label: Text(tag, style: const TextStyle(fontSize: 10)),
              backgroundColor: Colors.orange[100],
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )).toList(),
          ),
      ],
    );
  }

  Widget _buildRecipeActions(Recipe recipe) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: recipe.isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () => _toggleLike(recipe),
        ),
        Text('${recipe.likesCount}'),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.grey),
          onPressed: () => _collectRecipe(recipe),
        ),
        Text('${recipe.collectionsCount}'),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.grey),
          onPressed: () => _shareRecipe(recipe),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => _addToMyRecipes(recipe),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('一键收藏'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB8860B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
        ),
      ],
    );
  }

  List<dynamic> _getFilteredRecipes(List<dynamic> recipes) {
    if (_searchQuery.isEmpty) return recipes;
    
    return recipes.where((recipe) {
      final query = _searchQuery.toLowerCase();
      return recipe.name.toLowerCase().contains(query) ||
             recipe.tags.any((tag) => tag.toLowerCase().contains(query)) ||
             recipe.notes.toLowerCase().contains(query);
    }).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String query = _searchQuery;
        return AlertDialog(
          title: const Text('搜索菜谱'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '输入菜名、标签或关键词',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => query = value,
            onSubmitted: (value) {
              setState(() {
                _searchQuery = value;
              });
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = query;
                });
                Navigator.pop(context);
              },
              child: const Text('搜索'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToRecipeDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  void _toggleLike(Recipe recipe) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    // 这里应该调用点赞API，暂时模拟本地操作
    recipe.likesCount += recipe.isFavorite ? -1 : 1;
    recipe.isFavorite = !recipe.isFavorite;
    dataProvider.updateRecipe(recipe);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(recipe.isFavorite ? '已点赞' : '取消点赞'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _collectRecipe(Recipe recipe) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    recipe.collectionsCount++;
    dataProvider.updateRecipe(recipe);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已收藏到个人菜谱'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareRecipe(Recipe recipe) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('分享功能开发中...')),
    );
  }

  void _addToMyRecipes(Recipe recipe) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    
    // 检查是否已经收藏
    final existingRecipe = dataProvider.recipes.any((r) => r.name == recipe.name);
    if (existingRecipe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('您已经收藏过这道菜了')),
      );
      return;
    }

    // 创建新的菜谱副本
    final newRecipe = recipe; // 实际应该创建副本并修改ID
    newRecipe.authorId = null; // 清除原作者信息
    newRecipe.isPublic = false; // 设为私人菜谱
    
    dataProvider.addRecipe(newRecipe);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已添加到我的菜谱'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}