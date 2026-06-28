class PaginationResponse<T> {
  List<T>? data;
  Pagination? pagination;

  PaginationResponse({this.data, this.pagination});

  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginationResponse<T>(
      data: json['data'] != null
          ? List<T>.from(json['data'].map((v) => fromJsonT(v)))
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonT) {
    return {
      'data': data?.map((v) => toJsonT(v)).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class Pagination {
  int? page;
  int? limit;
  int? totalRows;
  int? totalPages;
  bool get hasNextPage =>
      page != null && totalPages != null && page! < totalPages!;

  Pagination({this.page, this.limit, this.totalRows, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'] ?? 1;
    limit = json['limit'] ?? 25;
    totalRows = json['totalRows'] ?? 0;
    totalPages = json['totalPages'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['totalRows'] = totalRows;
    data['totalPages'] = totalPages;
    return data;
  }
}
