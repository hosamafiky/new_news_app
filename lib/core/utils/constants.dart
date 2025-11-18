enum Category {
  business,
  entertainment,
  general,
  health,
  science,
  sports,
  technology;

  static Category fromString(String source) {
    return Category.values.firstWhere((e) => e.name == source, orElse: () => Category.general);
  }
}

enum Country {
  us('us', 'United States'),
  gb('gb', 'United Kingdom'),
  ca('ca', 'Canada'),
  au('au', 'Australia'),
  de('de', 'Germany'),
  fr('fr', 'France'),
  in_('in', 'India'),
  jp('jp', 'Japan');

  final String code;
  final String name;
  const Country(this.code, this.name);
}

enum SortOption {
  publishedAt('Date Published'),
  relevancy('Relevancy'),
  popularity('Popularity');

  final String label;
  const SortOption(this.label);
}

enum Language {
  en('English'),
  es('Spanish'),
  fr('French'),
  de('German'),
  ar('Arabic');

  final String name;
  const Language(this.name);
}
