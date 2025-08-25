import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../network/models/recipe_models.dart';
import 'login_screen.dart';

class CommunityScreenV2 extends StatefulWidget {
  const CommunityScreenV2({super.key});

  @override
  State<CommunityScreenV2> createState() => _CommunityScreenV2State();
}

class _CommunityScreenV2State extends State<CommunityScreenV2> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  List<RecipeSummary> _communityRecipes = [];
  List<RecipeSummary> _trendingRecipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCommunityData();
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCommunityData,
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
          if (AuthService.requiresAuth()) {
            _showLoginDialog();
            return;
          }
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final recipes = _getFilteredCommunityRecipes(_communityRecipes);
    
    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('暂无推荐菜谱', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCommunityData,
              child: const Text('重新加载'),
            ),
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
              _buildCommunityRecipeHeader(recipe),
              const SizedBox(height: 8),
              _buildCommunityRecipeCard(recipe),
              const SizedBox(height: 8),
              _buildCommunityRecipeActions(recipe),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLatestTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final recipes = _getFilteredCommunityRecipes(_communityRecipes);
    
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
              _buildCommunityRecipeHeader(recipe),
              const SizedBox(height: 8),
              _buildCommunityRecipeCard(recipe),
              const SizedBox(height: 8),
              _buildCommunityRecipeActions(recipe),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final recipes = _getFilteredCommunityRecipes(_trendingRecipes);
    
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
              _buildCommunityRecipeHeader(recipe),
              const SizedBox(height: 8),
              _buildCommunityRecipeCard(recipe),
              const SizedBox(height: 8),
              _buildCommunityRecipeActions(recipe),
            ],
          ),
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

  Widget _buildCommunityRecipeHeader(RecipeSummary recipe) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFB8860B),
          backgroundImage: recipe.author.avatar != null 
              ? NetworkImage('http://localhost:8080${recipe.author.avatar}')
              : null,
          child: recipe.author.avatar == null
              ? Text(
                  recipe.author.username.isNotEmpty ? recipe.author.username[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.author.username,
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

  Widget _buildCommunityRecipeActions(RecipeSummary recipe) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.grey),
          onPressed: () => _toggleCommunityLike(recipe),
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

  List<RecipeSummary> _getFilteredCommunityRecipes(List<RecipeSummary> recipes) {
    if (_searchQuery.isEmpty) return recipes;
    
    return recipes.where((recipe) {
      final query = _searchQuery.toLowerCase();
      return recipe.title.toLowerCase().contains(query) ||
             recipe.tags.any((tag) => tag.toLowerCase().contains(query)) ||
             recipe.description.toLowerCase().contains(query);
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

  void _toggleCommunityLike(RecipeSummary recipe) async {
    if (AuthService.requiresAuth()) {
      _showLoginDialog();
      return;
    }

    try {
      await ApiService.likeRecipe(recipe.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('点赞成功')),
        );
      }
      _loadCommunityData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('点赞失败：$e')),
        );
      }
    }
  }

  void _collectRecipe(RecipeSummary recipe) async {
    if (AuthService.requiresAuth()) {
      _showLoginDialog();
      return;
    }

    try {
      await ApiService.collectRecipe(recipe.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('收藏成功')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('收藏失败：$e')),
        );
      }
    }
  }

  void _shareRecipe(RecipeSummary recipe) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('分享功能开发中...')),
    );
  }

  void _addToMyRecipes(RecipeSummary recipe) async {
    if (AuthService.requiresAuth()) {
      _showLoginDialog();
      return;
    }

    try {
      await ApiService.collectRecipe(recipe.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已添加到我的菜谱')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('添加失败：$e')),
        );
      }
    }
  }

  Future<void> _loadCommunityData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recipesResponse = await ApiService.getRecipes(page: 0, size: 20);
      final trendingRecipes = await ApiService.getTrendingRecipes(limit: 10);
      
      setState(() {
        _communityRecipes = recipesResponse.content;
        _trendingRecipes = trendingRecipes;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败：$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCommunityRecipeCard(RecipeSummary recipe) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recipe.images.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                'http://localhost:8080${recipe.images.first}',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.description,
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${recipe.prepTime + recipe.cookTime}分钟'),
                    const SizedBox(width: 16),
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${recipe.servings}人份'),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(recipe.difficulty),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        recipe.difficulty,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '简单':
        return Colors.green;
      case '中等':
        return Colors.orange;
      case '困难':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要登录'),
        content: const Text('此功能需要登录后才能使用，是否前往登录？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
              if (result == true) {
                _loadCommunityData();
              }
            },
            child: const Text('登录'),
          ),
        ],
      ),
    );
  }
}