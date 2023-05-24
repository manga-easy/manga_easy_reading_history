import 'package:flutter/material.dart';
import 'package:manga_easy_reading_history/src/historico/domain/repositories/historico_repo.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class HistoricoController extends IController {
  final HistoricRepositoryLocal historicoRepo;
  final MangaRepo mangaRepo;

  HistoricoController({
    required this.historicoRepo,
    required this.mangaRepo,
  });

  var listHistorico = <Historico>[];

  @override
  void init(BuildContext context) {
    loadingHistorico();
  }

  Future<void> loadingHistorico() async {
    state = PageStatus.loading;
    var history = await historicoRepo.list(
      where: HistoricFilter(ordenar: true),
    );
    listHistorico = history;
    state = PageStatus.done;
  }

  void removeHist(Manga mang, int index) {
    state = PageStatus.loading;
    if (Global.user != null) {
      listHistorico[index].isDeleted = true;
      historicoRepo.put(objeto: listHistorico[index], id: mang.uniqueid);
    } else {
      historicoRepo.delete(id: mang.uniqueid);
    }
    listHistorico.removeAt(index);
    state = PageStatus.done;
  }
}
