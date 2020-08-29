import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  //
  static var _t = Translations("en_us") +
      {
        "en_us": "Loading World and Countries Information...",
        "es_uy": "Cargando información global y paises...",
      }
      +
      {
        "en_us": "WorldWide Details",
        "es_uy": "Detalles Globales",
      }
      +
      {
        "en_us": "Favourites",
        "es_uy": "Favoritos",
      }
      +
      {
        "en_us": "Countries",
        "es_uy": "Paises",
      }
      +
      {
        "en_us": "Continents",
        "es_uy": "Continentes",
      }
      +
      {
        "en_us": "Total cases",
        "es_uy": "Casos totales",
      }
      +
      {
        "en_us": "Cases",
        "es_uy": "Casos",
      }
      +
      {
        "en_us": "Today cases",
        "es_uy": "Casos hoy",
      }
      +
      {
        "en_us": "Recovered",
        "es_uy": "Recuperados",
      }
      +
      {
        "en_us": "Today recovered",
        "es_uy": "Recuperados hoy",
      }
      +
      {
        "en_us": "Deaths",
        "es_uy": "Fallecidos",
      }
      +
      {
        "en_us": "Today deaths",
        "es_uy": "Fallecidos hoy",
      }
      +
      {
        "en_us": "Historical totals daily",
        "es_uy": "Totales históricos diarios",
      }
      +
      {
        "en_us": "Historical totals",
        "es_uy": "Totales históricos",
      }
      +
      {
        "en_us": "%s was added to favourites.",
        "es_uy": "%s fue agregado a favoritos.",
      }
      +
      {
        "en_us": "%s was removed to favourites.",
        "es_uy": "%s fue eliminado de favoritos.",
      }
      +
      {
        "en_us": "Population",
        "es_uy": "Población",
      }
      +
      {
        "en_us": "Cases/Million",
        "es_uy": "Casos/Millón",
      }
      +
      {
        "en_us": "Active cases",
        "es_uy": "Casos activos",
      }
      +
      {
        "en_us": "Deaths/Million",
        "es_uy": "Facllecidos/Millón",
      }
      +
      {
        "en_us": "Critical/Million",
        "es_uy": "Críticos/Millón",
      }
      +
      {
        "en_us": "Tests/Million",
        "es_uy": "Pruebas/Millón",
      }
      +
      {
        "en_us": "Critical",
        "es_uy": "Críticos",
      }
      +
      {
        "en_us": "Tests",
        "es_uy": "Pruebas",
      }
      +
      {
        "en_us": "Remove",
        "es_uy": "Eliminar",
      }
      +
      {
        "en_us": "Search...",
        "es_uy": "Buscar...",
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(int value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);

  Map<String, String> allVersions() => localizeAllVersions(this, _t);
}