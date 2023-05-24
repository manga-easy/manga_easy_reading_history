import 'package:client_driver/client_driver.dart';
import 'package:manga_easy_reading_history/src/historico/data/datasources/historic_datasource.dart';
import 'package:manga_easy_reading_history/src/historico/domain/models/historic_filter.dart';

class HistoricDatasorceV1 extends HistoricDatasorce {
  final ClientRequest http;
  final GetJWTAuthCase getJWTAuthCase;

  HistoricDatasorceV1(this.http, this.getJWTAuthCase);

  @override
  final String host = AppUrl.userConfig;
  @override
  final String version = 'v1';

  @override
  Future<List<Map<String, dynamic>>> list(HistoricFilter where) async {
    var param = '';

    if (where.uniqueid.isNotEmpty) {
      param += 'uniqueid=${where.uniqueid}&';
    }

    if (where.orderUpdate) {
      param += 'orderUpdate=true&';
    }

    param += 'limit=${where.limit}&';
    param += 'offset=${where.offset}&';
    final headers = {
      'me-jwt-token': await getJWTAuthCase(),
    };
    var ret = await http.get(
      path: '$host/$version/historic?$param',
      headers: headers,
    );
    List data = ret.data['data'];
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<void> delete(String uniqueid) async {
    final headers = {
      'me-jwt-token': await getJWTAuthCase(),
    };
    var ret = await http.delete(
      path: '$host/$version/historic?uniqueid=$uniqueid',
      headers: headers,
    );
    ret.data;
  }

  @override
  Future<void> update(Map<String, dynamic> body) async {
    final headers = {
      'me-jwt-token': await getJWTAuthCase(),
    };
    var ret = await http.put(
      path: '$host/$version/historic',
      body: body,
      headers: headers,
    );
    ret.data;
  }
}
