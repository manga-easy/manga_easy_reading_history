import 'package:client_driver/client_driver.dart';
import 'package:manga_easy_reading_history/core/app_url.dart';
import 'package:manga_easy_reading_history/core/auth/jwt_auth.dart';
import 'package:manga_easy_reading_history/src/historico/data/datasources/history_datasource.dart';
import 'package:manga_easy_reading_history/src/historico/domain/models/history_filter.dart';

class HistoryDatasourceV1 extends HistoryDatasource {
  final ClientRequest http;
  final JWTAuth jwtAuth;

  HistoryDatasourceV1(this.http, this.jwtAuth);

  @override
  final String host = AppUrl.userConfig;
  @override
  final String version = 'v1';

  @override
  Future<List<Map<String, dynamic>>> list(HistoryFilter where) async {
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
      'me-jwt-token': await jwtAuth.getJWTToken(),
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
      'me-jwt-token': await jwtAuth.getJWTToken(),
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
      'me-jwt-token': await jwtAuth.getJWTToken(),
    };
    var ret = await http.put(
      path: '$host/$version/historic',
      body: body,
      headers: headers,
    );
    ret.data;
  }
}
