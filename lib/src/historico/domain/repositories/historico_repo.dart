import 'package:flutter/foundation.dart';
import 'package:manga_easy_reading_history/src/historico/domain/models/historic_filter.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

abstract class HistoricRepositoryLocal {
  final BlockedComicCase blockedComicCase;

  final ILocalDatabase db;

  HistoricRepositoryLocal(this.db, this.blockedComicCase);

  Historico? get({required String id});

  Future<void> put({
    required Historico objeto,
    required String id,
    bool isUpdate = true,
  });

  Future<void> delete({required String id});

  Future<List<Historico>> list({HistoricFilter where});

  Future<void> deleteAll();
}

class HistoricRepositoryHive extends HistoricRepositoryLocal {
  String table = 'boxHistorico';

  HistoricRepositoryHive(super.db, super.blockedComicCase);

  @override
  Historico? get({required String id}) {
    var data = db.get(id: id, table: table);
    data ??= db.get(id: id, table: table);
    if (data == null) return null;
    return Historico.fromJson(Map.from(data));
  }

  @override
  Future<void> put(
      {required Historico objeto,
      required String id,
      bool isUpdate = true}) async {
    if (isUpdate) {
      objeto.isSync = false;
      objeto.updatedAt = DateTime.now().millisecondsSinceEpoch;
    }
    await db.update(objeto: objeto.toJson(), table: table, id: id);
  }

  @override
  Future<void> delete({required String id}) async {
    await db.delete(id: id, table: table);
  }

  @override
  Future<void> deleteAll() async {
    await db.deleteAll(table: table);
  }

  @override
  Future<List<Historico>> list({HistoricFilter? where}) async {
    try {
      var list = db.list(table: table);
      return await compute(filter, {
        'where': where,
        'dados': list,
        'blockedComicCase': blockedComicCase,
        'filterOf': Global.filterContentOver18,
        'blockListModel': Global.blockListModel,
      });
    } catch (e) {
      Helps.log(e);
      return [];
    }
  }

  static List<Historico> filter(dynamic map) {
    HistoricFilter? where = map['where'];
    BlockedComicCase blockedComicCase = map['blockedComicCase'];
    List<Historico> list = map['dados']
        .map<Historico>((e) => Historico.fromJson(Map.from(e)))
        .toList();
    list.removeWhere(
      (element) => blockedComicCase(
        uniqueid: element.manga.uniqueid,
        filterOf: map['filterOf'],
        blockListModel: map['blockListModel'],
      ),
    );

    if (where == null) return list;
    if (where.ordenar) {
      list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    if (where.filterIsContinue) {
      list.removeWhere((element) => element.capAtual == null);
    }
    return list;
  }
}
