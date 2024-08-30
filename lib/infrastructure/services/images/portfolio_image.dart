enum PortfolioImage {
  alSarayCountries(filename: "al_saray_countries.png"),
  alSarayHome(filename: "al_saray_home.png"),
  alSarayReports(filename: "al_saray_reports.png"),
  alSarayReportDetail(filename: "al_saray_report_detail.png"),
  alSarayTopics(filename: "al_saray_topics.png"),
  pureversity(filename: "pureversity.webp"),
  uaeStatEconomy(filename: "uae_stat_economy.png"),
  uaeStatHome(filename: "uae_stat_home.png");

  static const directoryPath = 'assets/images/portfolio';

  final String filename;

  String get path => '$directoryPath/$filename';

  const PortfolioImage({required this.filename});
}
