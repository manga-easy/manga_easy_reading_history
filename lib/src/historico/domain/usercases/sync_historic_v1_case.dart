import 'package:manga_easy_reading_history/src/historico/domain/models/historic_filter.dart';
import 'package:manga_easy_reading_history/src/historico/domain/repositories/historico_repo.dart';
import 'package:manga_easy_reading_history/src/historico/domain/repositories/library_repository_remote.dart';
import 'package:manga_easy_reading_history/src/historico/domain/usercases/sync_historic_case.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class SyncHistoricV1Case extends SyncHistoricCase {
  final HistoricRepositoryRemote historicRepositoryRemote;
  final MangaRepo mangaRepo;
  final HistoricRepositoryLocal historicoRepo;

  SyncHistoricV1Case(
    this.historicRepositoryRemote,
    this.mangaRepo,
    this.historicoRepo,
  );

  @override
  Future<void> call({
    bool isLogin = false,
  }) async {
    try {
      var ret = await historicoRepo.list();
      //verifica se está vazio se estiver importa
      if (ret.isEmpty || isLogin) {
        for (var i = 0; i < 30000; i++) {
          var favos = await historicRepositoryRemote.list(
            where: HistoricFilter(
              limit: 400,
              offset: 400 * i,
            ),
          );
          if (favos.isEmpty) break;
          for (var favo in favos) {
            var remote = favo;
            var local = historicoRepo.get(id: remote.uniqueid);
            verifyUpdateAt(remote, local);
          }
        }
        return;
      }
      for (Historico item in ret) {
        if (item.idUser.isEmpty) {
          item.idUser = Global.user!.id!;
        }
        //verifica se o favorito foi deletado no offline
        if (item.isDeleted && verify30Days(item.updatedAt)) {
          try {
            await historicoRepo.delete(id: item.uniqueid);
          } catch (e) {
            Helps.log(e);
          }
        }
        //verifica se já foi sincronizado
        if (!item.isSync) {
          try {
            var remote = await historicRepositoryRemote.list(
              where: HistoricFilter(
                limit: 1,
                uniqueid: item.uniqueid,
              ),
            );
            await verifyUpdateAt(remote.isNotEmpty ? remote.first : null, item);
          } catch (e) {
            Helps.log(e);
          }
        }
      }
      // carrega os ultimos mangas
      var retL = await historicRepositoryRemote.list(
        where: HistoricFilter(
          limit: 100,
          orderUpdate: true,
        ),
      );
      for (var element in retL) {
        var remote = element;
        var local = historicoRepo.get(id: remote.uniqueid);
        verifyUpdateAt(remote, local);
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordFlutterError(FlutterErrorDetails(
        exception: e,
        stack: s,
        library: 'SincronizaHistoricoCase',
      ));
      Helps.log(e);
    }
  }

  Future<void> verifyUpdateAt(Historico? remote, Historico? local) async {
    //verificar se ja foi salvo aquele favorito
    if (remote != null && local != null) {
      //verifica qual ta mais atualizado e atualiza oque não esta
      if (remote.updatedAt == local.updatedAt) {
        return;
      }
      if (remote.updatedAt < local.updatedAt) {
        remote.updatedAt = local.updatedAt;
        await historicRepositoryRemote.put(objeto: local);
        local.isSync = true;
        await historicoRepo.put(
          objeto: local,
          id: local.uniqueid,
          isUpdate: false,
        );
        return;
      }
      remote.isSync = true;
      await historicoRepo.put(
        objeto: remote,
        id: remote.uniqueid,
        isUpdate: false,
      );
      return;
    }
    if (local != null) {
      //se não foi criado ele cria
      await historicRepositoryRemote.put(objeto: local);
      local.isSync = true;
      await historicoRepo.put(
        objeto: local,
        id: local.uniqueid,
        isUpdate: false,
      );
      return;
    }
    // atualiza o status de sincronizado
    if (remote != null) {
      remote.isSync = true;
      await historicoRepo.put(
        objeto: remote,
        id: remote.uniqueid,
        isUpdate: false,
      );
      return;
    }
  }

  bool verify30Days(int update) {
    var trintaDias = 2592000000;
    var agora = DateTime.now().millisecondsSinceEpoch;
    var dif = agora - update;
    return dif > trintaDias;
  }
}
