enum SearchFilter {
  movie,
  tvShow,
  book,
  game,
  podcastShow,
  podcastEpisode,
}

const filterStringToSearchFilter = <String, SearchFilter>{
  'movie': SearchFilter.movie,
  'tv_show': SearchFilter.tvShow,
  'book': SearchFilter.book,
  'game': SearchFilter.game,
  'podcast_show': SearchFilter.podcastShow,
  'podcast_episode': SearchFilter.podcastEpisode,
};

const allSearchFilters = {
  SearchFilter.movie,
  SearchFilter.tvShow,
  SearchFilter.book,
  SearchFilter.game,
  SearchFilter.podcastShow,
  SearchFilter.podcastEpisode,
};

extension StringX on String? {
  /// Convert a [String] into a [Set<SearchFilter>].
  ///
  /// If [String] is null returns empty set.
  Set<SearchFilter> get stringToFilter {
    if (this == null) return <SearchFilter>{};
    final filter = this!
        .split(',')
        .where(
          (s) => filterStringToSearchFilter.containsKey(s),
        )
        .map((e) => filterStringToSearchFilter[e]!)
        .toSet();
    if (filter.isNotEmpty) return filter;
    return allSearchFilters;
  }
}

extension SearchFiltersX on Set<SearchFilter> {
  /// Convert a [Set<SearchFilter>] to a [String] representation to be used as
  /// a query parameter.
  String get filterToString {
    final filterToStringMap =
        filterStringToSearchFilter.map((k, v) => MapEntry(v, k));
    return map((e) => filterToStringMap[e]!).join(',');
  }
}
