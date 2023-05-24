import 'package:manga_easy_reading_history/src/historico/data/datasources/historic_datasource.dart';
import 'package:manga_easy_reading_history/src/historico/domain/models/historic_filter.dart';
import 'package:manga_easy_reading_history/src/historico/domain/repositories/library_repository_remote.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class HistoricRepositoryDart extends HistoricRepositoryRemote {
  final HistoricDatasorce _historicDatasorce;
  HistoricRepositoryDart(this._historicDatasorce);

  @override
  Future<void> delete({required String uniqueid}) async {
    if (uniqueid.isEmpty) {
      throw Exception('uniqueid não pode ser vazio');
    }
    await _historicDatasorce.delete(uniqueid);
  }

  @override
  Future<Historico?> get({required String uniqueid}) async {
    if (uniqueid.isEmpty) {
      throw Exception('uniqueid não pode ser vazio');
    }
    var ret = await _historicDatasorce.list(HistoricFilter(uniqueid: uniqueid));
    return Historico.fromJson(ret.first);
  }

  @override
  Future<List<Historico>> list({required HistoricFilter where}) async {
    var ret = await _historicDatasorce.list(where);
    return ret.map((e) => Historico.fromJson(e)).toList();
  }

  @override
  Future<void> put({required Historico objeto}) async {
    await _historicDatasorce.update(objeto.toJson());
  }
}
