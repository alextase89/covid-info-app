import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  //
  static var _t = Translations("en_us") +
      {
        "en_us": "Loading World and Countries Information...",
        "es_ES": "Cargando información global y paises...",
      }
      +
      {
        "en_us": "WorldWide Details",
        "es_ES": "Detalles Globales",
      }
      +
      {
        "en_us": "Favourites",
        "es_ES": "Favoritos",
      }
      +
      {
        "en_us": "Countries",
        "es_ES": "Paises",
      }
      +
      {
        "en_us": "Continents",
        "es_ES": "Continentes",
      }
      +
      {
        "en_us": "Total cases",
        "es_ES": "Casos totales",
      }
      +
      {
        "en_us": "Cases",
        "es_ES": "Casos",
      }
      +
      {
        "en_us": "Today cases",
        "es_ES": "Casos hoy",
      }
      +
      {
        "en_us": "Recovered",
        "es_ES": "Recuperados",
      }
      +
      {
        "en_us": "Today recovered",
        "es_ES": "Recuperados hoy",
      }
      +
      {
        "en_us": "Deaths",
        "es_ES": "Fallecidos",
      }
      +
      {
        "en_us": "Today deaths",
        "es_ES": "Fallecidos hoy",
      }
      +
      {
        "en_us": "Historical totals daily",
        "es_ES": "Totales históricos diarios",
      }
      +
      {
        "en_us": "Historical totals",
        "es_ES": "Totales históricos",
      }
      +
      {
        "en_us": "%s was added to favourites.",
        "es_ES": "%s fue agregado a favoritos.",
      }
      +
      {
        "en_us": "%s was removed to favourites.",
        "es_ES": "%s fue eliminado de favoritos.",
      }
      +
      {
        "en_us": "Population",
        "es_ES": "Población",
      }
      +
      {
        "en_us": "Cases/Million",
        "es_ES": "Casos/Millón",
      }
      +
      {
        "en_us": "Active cases",
        "es_ES": "Casos activos",
      }
      +
      {
        "en_us": "Deaths/Million",
        "es_ES": "Facllecidos/Millón",
      }
      +
      {
        "en_us": "Critical/Million",
        "es_ES": "Críticos/Millón",
      }
      +
      {
        "en_us": "Tests/Million",
        "es_ES": "Pruebas/Millón",
      }
      +
      {
        "en_us": "Critical",
        "es_ES": "Críticos",
      }
      +
      {
        "en_us": "Tests",
        "es_ES": "Pruebas",
      }
      +
      {
        "en_us": "Remove",
        "es_ES": "Eliminar",
      }
      +
      {
        "en_us": "Search...",
        "es_ES": "Buscar...",
      }
      +
      {
        "en_us": "No data or connection available at this time.",
        "es_ES": "No hay datos o conexión disponibles en este momento",
      }
      +
      {
        "en_us": "No data available.",
        "es_ES": "No hay datos disponibles.",
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(int value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);

  Map<String, String> allVersions() => localizeAllVersions(this, _t);
}