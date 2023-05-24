class HistoricFilter {
  final bool ordenar;
  final bool filterIsContinue;
  final bool orderUpdate;
  final String uniqueid;
  final int limit;
  final int offset;

  HistoricFilter({
    this.ordenar = false,
    this.filterIsContinue = false,
    this.orderUpdate = false,
    this.uniqueid = '',
    this.limit = 100,
    this.offset = 0,
  });
}
