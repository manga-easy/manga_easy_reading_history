import 'package:manga_easy_reading_history/src/historico/domain/models/historic_filter.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

abstract class HistoricRepositoryRemote {
  Future<Historico?> get({required String uniqueid});

  Future<void> put({required Historico objeto});

  Future<void> delete({required String uniqueid});

  Future<List<Historico>> list({required HistoricFilter where});
}
