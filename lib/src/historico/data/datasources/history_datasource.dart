import 'package:manga_easy_reading_history/src/historico/domain/models/history_filter.dart';

abstract class HistoryDatasource {
  abstract final String host;
  abstract final String version;

  Future<List<Map<String, dynamic>>> list(HistoryFilter where);

  Future<void> delete(String uniqueid);

  Future<void> update(Map<String, dynamic> body);
}
