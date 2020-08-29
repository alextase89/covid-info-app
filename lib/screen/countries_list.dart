import 'package:covid/model/classes.dart';
import 'package:covid/screen/common/loading.dart';
import 'package:covid/screen/information_details.dart';
import 'package:covid/utils/constants.dart';
import 'package:covid/utils/sprintf.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid/utils/http.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/main.i18n.dart';


class CountryList extends StatefulWidget {
  final bool isFav;

  CountryList({this.isFav});

  @override
  _CountryListSate createState() => _CountryListSate(isFav: this.isFav);
}

class _CountryListSate extends State<CountryList> {
  SharedPreferences _prefs;
  var _loadingInProgress = false;
  List<String> countryCodes;
  List<CountryInfo> _suggestions = [];
  List<CountryInfo> _newDataList = [];
  TextEditingController _textController = TextEditingController();
  var _isSearchVisible = false;
  final bool isFav;

  _CountryListSate({this.isFav});

  @override
  void initState() {
    super.initState();
    _loadingInProgress = true;
    _loadDataAndPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Visibility(
          visible: !_isSearchVisible,
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Icon(FontAwesomeIcons.globeAmericas)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
              ),
              Container(
                  child: Text(
                      !this.isFav
                          ? 'Countries'.i18n
                          : 'Favourites'.i18n,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center))
            ],
          ),
          replacement: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              autofocus: true,
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Search...'.i18n,
              ),
              onChanged: onItemChanged,
            ),
          ),
        ),
        actions: <Widget>[
          Visibility(
            visible: !_isSearchVisible,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchVisible = true;
                });
              },
            ),
            replacement: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _isSearchVisible = false;
                  _fillList();
                });
              },
            ),
          ),
        ],
      ),
      body: _loadingInProgress ? new LoadingListPage() : _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: _newDataList.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 575),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: this.isFav
                            ? _buildSlidableRow(context, index)
                            : _rowContent(context, _newDataList[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidableRow(BuildContext context, int index) {
    CountryInfo country = _newDataList[index];
    return Slidable(
      key: Key(country.code),
      direction: Axis.horizontal,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) => _removeFromFavourites(context, country)
      ),
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: _rowContent(context, country),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Remove'.i18n,
          color: Colors.red,
          icon: FontAwesomeIcons.trash,
          onTap: () => _removeFromFavourites(context, country),
        ),
      ],
      secondaryActions: <Widget>[
        Card(
          child: IconSlideAction(
            caption: 'Remove'.i18n,
            color: Colors.red,
            icon: FontAwesomeIcons.trash,
            onTap: () => _removeFromFavourites(context, country),
          ),
        ),
      ],
    );
  }

  Widget _rowContent(BuildContext context, CountryInfo country) {
    return InkWell(
      onTap: () {
        setState(() {
          _seeCountryDetails(country);
        });
      },
      child: Card(
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0),
            ),
            Container(
              width: 48.0,
              height: 50.0,
              child: Image.asset(
                  'icons/flags/png/2.5x/' + country.code + '.png',
                  package: 'country_icons'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  ListTile(
                      title: Text(
                        country.name,
                        style: TextStyle(fontSize: 23.0),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text(
              text,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            backgroundColor: Colors.red,
        )
    );
  }

  void _removeFromFavourites(BuildContext context, CountryInfo countryInfo){
    setState(() {
      _newDataList.remove(countryInfo);
      _suggestions.remove(countryInfo);
      countryCodes.remove(countryInfo.code);
      _prefs.setStringList("country_fav", countryCodes);
    });
    _showSnackBar(context, "%s was removed to favourites.".i18n.fill([countryInfo.name]));
  }

  _seeCountryDetails(CountryInfo c) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
        return new InformationDetails(isWorldWide: false, countryInfo: c);
      }),
    );
  }

  void _loadDataAndPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    this.countryCodes = _prefs.getStringList("country_fav") ?? [];
    if(!this.isFav || (this.isFav && this.countryCodes.isNotEmpty)) {
      Response response = await restClient.get(_countriesServiceUrl());
      if (response.statusCode == 200) {
        if (this.isFav && this.countryCodes.length == 1) {
          _suggestions = [CountryInfo.fromJson(response.data)];
        } else {
          _suggestions = (response.data as List)
              .map((json) => CountryInfo.fromJson(json))
              .where((country) => country.code != null && country.name != null)
              .toList();
        }
      }
    }
    setState(() {
      _newDataList.addAll(_suggestions);
      _loadingInProgress = false;
    });
  }

  onItemChanged(String value) {
    _newDataList.clear();
    _newDataList.addAll(_suggestions);
    setState(() {
      _newDataList = _suggestions
          .where((country) =>
              country.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _fillList() {
    _newDataList.clear();
    _newDataList.addAll(_suggestions);
    _textController.clear();
  }

  String _countriesServiceUrl() {
    if (this.isFav && this.countryCodes != null && this.countryCodes.isNotEmpty) {
      String codes = this.countryCodes.join(",");
      return sprintf(COUNTRY_MULTIPLE_SERVICE_URL, [codes]);
    }
    return COUNTRY_SERVICE_URL;
  }
}
