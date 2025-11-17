# News API Flutter App

A Flutter mobile application for browsing news articles using the [News API](https://newsapi.org/).

## Features

### Two Main Endpoints

- **Everything** - Search through 150,000+ articles from various sources
- **Top Headlines** - Get breaking news headlines by country and category

### Search & Filters

- **Keyword Search** - Search articles by keyword or phrase
- **Sort Options** - Sort by date published, relevancy, or popularity
- **Country Filter** - Filter top headlines by country (US, UK, Canada, etc.)
- **Category Filter** - Browse by business, entertainment, health, science, sports, technology
- **Date Range** - Filter articles by date range (Everything endpoint)

### Article Features

- Display article image, title, description, source, author, and published time
- Save articles for later reading
- Share articles
- Open full article in browser

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── article.dart                   # Article and Source data models
├── services/
│   └── news_api_service.dart          # API service for News API calls
├── utils/
│   ├── constants.dart                 # App constants (categories, countries, etc.)
│   └── date_utils.dart                # Date formatting utilities
├── screens/
│   └── home_screen.dart               # Main screen with tabs and article list
└── widgets/
    ├── article_card.dart              # Article card widget
    └── filter_bottom_sheet.dart       # Filter bottom sheet widget
```

## Getting Started

### Prerequisites

- Flutter SDK (2.18.0 or higher)
- News API key from [newsapi.org](https://newsapi.org/)

### Installation

1. Clone the repository
2. Install dependencies:

```bash
flutter pub get
```

3. Add your News API key in `lib/services/news_api_service.dart`:

```dart
static const String _apiKey = 'YOUR_API_KEY_HERE';
```

4. Run the app:

```bash
flutter run
```

## Dependencies

- **http** (^1.1.0) - For making HTTP requests to News API
- **url_launcher** (^6.2.1) - For opening article URLs in browser

## API Endpoints Used

### Everything (`/v2/everything`)

Search through millions of articles from various sources.

**Parameters:**

- `q` - Keywords or phrases to search for
- `sortBy` - The order to sort articles (publishedAt, relevancy, popularity)
- `from` - Date to search from (ISO 8601 format)
- `to` - Date to search to (ISO 8601 format)
- `language` - Language code to filter articles

### Top Headlines (`/v2/top-headlines`)

Get breaking news headlines.

**Parameters:**

- `country` - 2-letter ISO 3166-1 country code
- `category` - Category (business, entertainment, general, health, science, sports, technology)
- `q` - Keywords to search for in headlines
- `sources` - Comma-separated string of news source identifiers

## News API Response Structure

```json
{
  "status": "ok",
  "totalResults": 10547,
  "articles": [
    {
      "source": {
        "id": "techcrunch",
        "name": "TechCrunch"
      },
      "author": "Sarah Perez",
      "title": "Article Title",
      "description": "Article description...",
      "url": "https://...",
      "urlToImage": "https://...",
      "publishedAt": "2025-11-18T10:30:00Z",
      "content": "Article content..."
    }
  ]
}
```

## Features to Add

- [ ] Bookmark/Save functionality with local storage
- [ ] Article detail screen
- [ ] Share functionality
- [ ] Search history
- [ ] Dark mode
- [ ] Offline reading
- [ ] Push notifications for breaking news
- [ ] Custom news sources selection

## License

This project is for educational purposes. Please check [News API Terms](https://newsapi.org/terms) for commercial usage.

## Credits

News data provided by [News API](https://newsapi.org/)
