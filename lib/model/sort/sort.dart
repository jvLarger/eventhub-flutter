import 'package:eventhub/utils/util.dart';

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  factory Sort.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Sort(
      empty: jsons['empty'],
      sorted: jsons['sorted'],
      unsorted: jsons['unsorted'],
    );
  }

  Map<String, dynamic> toJson() => {
        'empty': empty,
        'sorted': sorted,
        'unsorted': unsorted,
      };
}
