import 'package:eventhub/model/sort/sort.dart';
import 'package:eventhub/utils/util.dart';

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? unpaged;
  bool? paged;

  Pageable({this.sort, this.offset, this.pageNumber, this.pageSize, this.unpaged, this.paged});

  factory Pageable.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Pageable(
      sort: Sort.fromJson(jsons['sort']),
      offset: jsons['offset'],
      pageNumber: jsons['pageNumber'],
      pageSize: jsons['pageSize'],
      unpaged: jsons['unpaged'],
      paged: jsons['paged'],
    );
  }

  Map<String, dynamic> toJson() => {
        'sort': sort,
        'offset': offset,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'unpaged': unpaged,
        'paged': paged,
      };
}
