import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_reading_history/src/historico/data/datasources/history_datasource.dart';
import 'package:manga_easy_reading_history/src/historico/data/datasources/history_datasource_v1.dart';
import 'package:manga_easy_reading_history/src/historico/data/repositories/history_repository_v1.dart';
import 'package:manga_easy_reading_history/src/historico/domain/repositories/history_local_respository.dart';
import 'package:manga_easy_reading_history/src/historico/domain/repositories/history_repository.dart';
import 'package:manga_easy_reading_history/src/historico/domain/usercases/sync_history_case.dart';
import 'package:manga_easy_reading_history/src/historico/domain/usercases/sync_history_v1_case.dart';
import 'package:manga_easy_reading_history/src/historico/presenter/controllers/history_controller.dart';
import 'package:manga_easy_reading_history/src/historico/presenter/ui/pages/history_page.dart';
import 'package:manga_easy_routes/manga_easy_routes.dart';

class ReadingHistoryMicroApp extends MicroApp {
  final getIt = GetIt.instance;

  @override
  Map<String, Widget> routers = {
    HistoricoPage.router: const HistoricoPage(),
  };

  @override
  void registerDependencies() {
    //datasources
    getIt.registerFactory<HistoryDatasource>(
      () => HistoryDatasourceV1(getIt(), getIt()),
    );
    //register repositores
    getIt.registerFactory<HistoryRepositoryRemote>(
      () => HistoryRepositoryV1(
        getIt(),
      ),
    );
    getIt.registerFactory<HistoryRepositoryLocal>(
      () => HistoryRepositoryHive(
        getIt(),
        getIt(),
      ),
    );
    //register cases
    getIt.registerFactory<SyncHistoryCase>(
      () => SyncHistoryV1Case(
        getIt(),
        getIt(),
        getIt(),
      ),
    );
    //register controllers
    getIt.registerFactory(
      () => HistoryController(
        historicoRepo: getIt(),
        mangaRepo: getIt(),
      ),
    );
  }
}
