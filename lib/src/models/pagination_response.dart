/// A paginated API response wrapping a list of [data] of type [T].
class PaginationResponse<T> {
  /// The rows returned for the current page.
  List<T>? data;

  /// Pagination metadata for the response.
  Pagination? pagination;

  /// Creates a paginated response.
  PaginationResponse({this.data, this.pagination});

  /// Parses a [PaginationResponse] from [json], decoding each item with
  /// [fromJsonT].
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

  /// Serializes this response to JSON, encoding each item with [toJsonT].
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonT) {
    return {
      'data': data?.map((v) => toJsonT(v)).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

/// Pagination metadata describing the current page and totals.
class Pagination {
  /// Current page number (1-based).
  int? page;

  /// Number of rows per page.
  int? limit;

  /// Total number of rows across all pages.
  int? totalRows;

  /// Total number of pages.
  int? totalPages;

  /// Whether a next page is available after the current [page].
  bool get hasNextPage =>
      page != null && totalPages != null && page! < totalPages!;

  /// Creates pagination metadata.
  Pagination({this.page, this.limit, this.totalRows, this.totalPages});

  /// Parses [Pagination] from [json], defaulting missing fields.
  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'] ?? 1;
    limit = json['limit'] ?? 25;
    totalRows = json['totalRows'] ?? 0;
    totalPages = json['totalPages'] ?? 0;
  }

  /// Serializes this pagination metadata to JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['totalRows'] = totalRows;
    data['totalPages'] = totalPages;
    return data;
  }
}
