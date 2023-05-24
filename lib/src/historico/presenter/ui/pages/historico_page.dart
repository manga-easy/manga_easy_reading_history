import 'package:coffee_cup/coffe_cup.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga_easy_reading_history/src/historico/presenter/controllers/historico_controller.dart';
import 'package:manga_easy_routes/manga_easy_routes.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';
import 'package:manga_easy_themes/manga_easy_themes.dart';

class HistoricoPage extends StatefulWidget {
  static const router = '/historico';

  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final HistoricoController ct = GetIt.instance();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => ct.init(context));
    super.initState();
  }

  @override
  void dispose() {
    ct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_sharp,
                    color: ThemeService.of.backgroundText,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Historico',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: 45,
                ),
              ],
            ),
            Expanded(
              child: AnimatedBuilder(
                  animation: ct,
                  builder: (context, child) {
                    if (ct.state == PageStatus.loading) {
                      return const Loading();
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CoffeeText(
                                text:
                                    'Total de mangás ${ct.listHistorico.length}',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: ct.listHistorico.length,
                            itemBuilder: (context, index) {
                              Historico hist = ct.listHistorico[index];
                              if (!hist.isDeleted) {
                                return ListTile(
                                  onTap: () =>
                                      EasyNavigator.of(context).pushNamed(
                                    route: EasyRoutes.manga,
                                    arguments: {
                                      'manga': hist.manga,
                                    },
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  leading: CoffeeMangaCover(
                                    cover: hist.manga.capa,
                                    height: 100,
                                    width: 50,
                                    filtraImg: Global.filtraImg,
                                    headers: Global.header,
                                  ),
                                  title: Text(hist.manga.title),
                                  subtitle: Text(hist.capAtual != null
                                      ? 'Ultimo capitulo ${hist.capAtual!.title}'
                                      : 'não iniciado'),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline_sharp,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        ct.removeHist(hist.manga, index),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
