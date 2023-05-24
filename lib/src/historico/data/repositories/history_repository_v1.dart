import 'package:manga_easy_reading_history/src/historico/data/datasources/history_datasource.dart';
import 'package:manga_easy_reading_history/src/historico/domain/models/history_filter.dart';
import 'package:manga_easy_reading_history/src/historico/domain/repositories/history_repository.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class HistoryRepositoryV1 extends HistoryRepositoryRemote {
  final HistoryDatasource _historyDatasource;
  HistoryRepositoryV1(this._historyDatasource);

  @override
  Future<void> delete({required String uniqueid}) async {
    if (uniqueid.isEmpty) {
      throw Exception('uniqueid não pode ser vazio');
    }
    await _historyDatasource.delete(uniqueid);
  }

  @override
  Future<Historico?> get({required String uniqueid}) async {
    if (uniqueid.isEmpty) {
      throw Exception('uniqueid não pode ser vazio');
    }
    var ret = await _historyDatasource.list(HistoryFilter(uniqueid: uniqueid));
    return Historico.fromJson(ret.first);
  }

  @override
  Future<List<Historico>> list({required HistoryFilter where}) async {
    var ret = await _historyDatasource.list(where);
    return ret.map((e) => Historico.fromJson(e)).toList();
  }

  @override
  Future<void> put({required Historico objeto}) async {
    await _historyDatasource.update(objeto.toJson());
  }
}
