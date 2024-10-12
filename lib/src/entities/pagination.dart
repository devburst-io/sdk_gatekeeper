class Pagination<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int pageCount;
  final bool hasNext;
  final bool hasPrevious;

  Pagination({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory Pagination.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    var itemsJson = json['items'] as List;
    List<T> itemsList =
        itemsJson.map((itemJson) => fromJsonT(itemJson)).toList();

    return Pagination(
      items: itemsList,
      page: json['page'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      hasNext: json['hasNext'],
      hasPrevious: json['hasPrevious'],
    );
  }
}
