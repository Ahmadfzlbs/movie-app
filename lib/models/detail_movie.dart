class DetailMovie {
  final String title;
  final String posterPath;
  final String overview;
  final List<Genre> genres;

  DetailMovie({
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.genres,
  });

  factory DetailMovie.fromJson(Map<String, dynamic> json) {
    return DetailMovie(
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      genres: (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
    );
  }
}

class Genre {
  final String name;

  Genre({required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(name: json['name']);
  }
}
