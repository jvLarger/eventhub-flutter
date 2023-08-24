import 'package:eventhub/model/pageable/pageable.dart';
import 'package:eventhub/model/sort/sort.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class PageUsuario {
  List<Usuario>? content;
  Pageable? pageable;
  Sort? sort;
  bool? last;
  bool? first;
  bool? empty;
  int? totalElements;
  int? totalPages;
  int? size;
  int? number;
  int? numberOfElements;

  PageUsuario({
    this.content,
    this.pageable,
    this.sort,
    this.last,
    this.first,
    this.empty,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.numberOfElements,
  });

  factory PageUsuario.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);

    List<Usuario> content = List.empty();

    if (jsons['content'] != null) {
      content = (jsons['content'] as List).map((model) => Usuario.fromJson(model)).toList();
    }

    return PageUsuario(
      content: content,
      pageable: Pageable.fromJson(jsons['pageable']),
      sort: Sort.fromJson(jsons['sort']),
      last: jsons['last'],
      first: jsons['first'],
      empty: jsons['empty'],
      totalElements: jsons['totalElements'],
      totalPages: jsons['totalPages'],
      size: jsons['size'],
      number: jsons['number'],
      numberOfElements: jsons['numberOfElements'],
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'pageable': pageable,
        'sort': sort,
        'last': last,
        'first': first,
        'empty': empty,
        'totalElements': totalElements,
        'totalPages': totalPages,
        'size': size,
        'number': number,
        'numberOfElements': numberOfElements,
      };
}
