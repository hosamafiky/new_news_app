import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';
import '../utils/date_utils.dart' as app_date_utils;

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (article.urlToImage != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                article.urlToImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
                  );
                },
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            article.source.name,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
                          ),
                          if (article.author != null) ...[
                            const Text(' • ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Flexible(
                              child: Text(
                                article.author!,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(app_date_utils.DateUtils.getTimeAgo(article.publishedAt), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 8),

                // Title
                Text(
                  article.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.3),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Description
                if (article.description != null)
                  Text(
                    article.description!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 12),

                // Divider
                const Divider(height: 1),

                const SizedBox(height: 12),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // Save functionality
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Article saved')));
                          },
                          icon: const Icon(Icons.bookmark_border, size: 18),
                          label: const Text('Save', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(foregroundColor: Colors.grey[700], padding: const EdgeInsets.symmetric(horizontal: 8)),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {
                            // Share functionality
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share functionality')));
                          },
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(foregroundColor: Colors.grey[700], padding: const EdgeInsets.symmetric(horizontal: 8)),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () => _launchUrl(article.url),
                      icon: const Text('Read Full', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      label: const Icon(Icons.open_in_new, size: 14),
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
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
}
