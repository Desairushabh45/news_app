import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsViewModel newsViewModel = NewsViewModel();
  final DateFormat format = DateFormat('MMMM dd, yyyy');
  String selectedSource = 'general-news';

  final List<Map<String, String>> newsSources = [
    {"id": "general-news", "name": "General"},
    {"id": "bbc-news", "name": "BBC News"},
    {"id": "cnn", "name": "CNN"},
    {"id": "fox-sports", "name": "Fox Sports"},
    {"id": "reuters", "name": "Reuters"},
    {"id": "mtv-news", "name": "MTV News"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            selectedSource = 'general-news';
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Top Headlines'),
              const SizedBox(height: 10),
              _buildHeadlinesSection(),
              const SizedBox(height: 20),
              _buildSectionTitle('Selected News'),
              const SizedBox(height: 10),
              _buildNewsList(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoriesScreen()),
          );
        },
        icon: Image.asset(
          'assets/images/category_icon.png',
          height: 30,
          width: 30,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.category,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      title: Text(
        'News Today',
        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (String sourceId) {
            setState(() {
              selectedSource = sourceId;
              print(sourceId);
            });
          },
          itemBuilder: (BuildContext context) {
            return newsSources
                .map(
                  (source) => PopupMenuItem<String>(
                    value: source['id']!,
                    child: Text(source['name']!),
                  ),
                )
                .toList();
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildHeadlinesSection() {
    return SizedBox(
      height: 250,
      child: FutureBuilder<NewsChannelHeadlinesModel>(
        future: newsViewModel.fetchNewsChannelHeadlinesApi(selectedSource),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitCircle(size: 50, color: Colors.blue),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorWidget('Error fetching general news.');
          } else {
            final articles = snapshot.data!.articles!;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(
                          newImage: article.urlToImage ?? '',
                          newsTitle: article.title ?? 'No Title',
                          newsDate: article.publishedAt ?? '',
                          author: article.author ?? 'Unknown',
                          description: article.description ?? '',
                          content: article.content ?? '',
                          source: article.source?.name ?? 'Unknown',
                        ),
                      ),
                    );
                  },
                  child: _buildHeadlineCard(article),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildHeadlineCard(article) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: article.urlToImage ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const SpinKitCircle(color: Colors.blue, size: 30),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image, color: Colors.grey),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 10,
              right: 10,
              child: Text(
                article.title ?? 'No Title',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 5)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return Expanded(
      child: FutureBuilder<NewsChannelHeadlinesModel>(
        future: newsViewModel.fetchNewsChannelHeadlinesApi(selectedSource),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SpinKitCircle(size: 50, color: Colors.blue));
          } else if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorWidget('Error fetching selected news.');
          } else {
            final articles = snapshot.data!.articles!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: article.urlToImage ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                  title: Text(
                    article.title ?? 'No Title',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                  subtitle: Text(
                    format.format(
                      DateTime.tryParse(article.publishedAt ?? '') ??
                          DateTime.now(),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
