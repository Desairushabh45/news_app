import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newImage,
      newsTitle,
      newsDate,
      author,
      description,
      content,
      source;

  const NewsDetailScreen({
    Key? key,
    required this.newImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  }) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(), // Fixed Image Section
              const SizedBox(height: 16),
              _buildTitleSection(),
              const SizedBox(height: 8),
              _buildMetaDataSection(),
              const SizedBox(height: 16),
              _buildSourceSection(),
              const SizedBox(height: 16),
              _buildDescriptionSection(),
              const SizedBox(height: 16),
              _buildContentSection(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CachedNetworkImage(
        imageUrl: widget.newImage,
        fit: BoxFit.cover,
        placeholder: (context, url) => const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Text(
      widget.newsTitle,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMetaDataSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Published: ${widget.newsDate}",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          "By: ${widget.author.isEmpty ? 'Unknown' : widget.author}",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSourceSection() {
    return Text(
      "Source: ${widget.source}",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Text(
      widget.description,
      style: const TextStyle(
        fontSize: 12,
        height: 1.5,
      ),
    );
  }

  Widget _buildContentSection() {
    return Text(
      widget.content.isNotEmpty ? widget.content : "Content not available.",
      style: const TextStyle(
        fontSize: 16,
        height: 1.5,
      ),
    );
  }
}
