import 'package:manga_easy_reading_history/src/historico/domain/models/historic_filter.dart';

abstract class HistoricDatasorce {
  abstract final String host;
  abstract final String version;

  Future<List<Map<String, dynamic>>> list(HistoricFilter where);

  Future<void> delete(String uniqueid);

  Future<void> update(Map<String, dynamic> body);
}
