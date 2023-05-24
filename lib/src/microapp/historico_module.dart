import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_reading_history/src/historico/data/datasources/historic_datasource.dart';
import 'package:manga_easy_reading_history/src/historico/data/datasources/historic_datasource_v1.dart';
import 'package:manga_easy_reading_history/src/historico/data/repositories/historic_repository_dart.dart';
import 'package:manga_easy_reading_history/src/historico/domain/repositories/historico_repo.dart';
import 'package:manga_easy_reading_history/src/historico/domain/repositories/library_repository_remote.dart';
import 'package:manga_easy_reading_history/src/historico/domain/usercases/sync_historic_case.dart';
import 'package:manga_easy_reading_history/src/historico/domain/usercases/sync_historic_v1_case.dart';
import 'package:manga_easy_reading_history/src/historico/presenter/controllers/historico_controller.dart';
import 'package:manga_easy_reading_history/src/historico/presenter/ui/pages/historico_page.dart';
import 'package:manga_easy_routes/manga_easy_routes.dart';

class HistoricoModule extends MicroApp {
  final di = GetIt.instance;
  @override
  Map<String, Widget> routers = {
    HistoricoPage.router: const HistoricoPage(),
  };

  @override
  void registerDependencies() {
    //datasorces
    di.registerFactory<HistoricDatasorce>(
      () => HistoricDatasorceV1(di(), di()),
    );
    //register repositores
    di.registerFactory<HistoricRepositoryRemote>(() => HistoricRepositoryDart(
          di(),
        ));
    di.registerFactory<HistoricRepositoryLocal>(() => HistoricRepositoryHive(
          di(),
          di(),
        ));
    //register cases
    di.registerFactory<SyncHistoricCase>(() => SyncHistoricV1Case(
          di(),
          di(),
          di(),
        ));
    //register controllers
    di.registerFactory(
      () => HistoricoController(
        historicoRepo: di(),
        mangaRepo: di(),
      ),
    );
  }
}
