import 'package:covid/model/classes.dart';
import 'package:covid/screen/common/loading.dart';
import 'package:covid/screen/country_details.dart';
import 'package:covid/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid/utils/http.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavCountryList extends StatefulWidget {
  FavCountryList();

  @override
  _FavCountryListSate createState() => _FavCountryListSate();
}

class _FavCountryListSate extends State<FavCountryList> {
  SharedPreferences _prefs;
  var _loadingInProgress = false;
  List<CountryInfo> _suggestions = [];
  List<CountryInfo> _newDataList = [];
  TextEditingController _textController = TextEditingController();
  var _isSearchVisible = false;
  List<String> _favorites = [];

  _FavCountryListSate();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _updateCountries();
    _loadingInProgress = true;
  }

  void _loadPreferences() async{
    _prefs = await SharedPreferences.getInstance();
    _favorites = (_prefs.getStringList("country_fav") ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Visibility (
            visible: !_isSearchVisible,
            child: Text('Favourite Countries', style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
            replacement: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Search Here...',
                ),
                onChanged: onItemChanged,
              ),
            ),
        ),
        actions: <Widget>[
          Visibility (
            visible: !_isSearchVisible,
            child: IconButton(icon: Icon(Icons.search), onPressed: () {
                setState(() {
                  _isSearchVisible = true;
                });
              },
            ),
            replacement: IconButton(icon: Icon(Icons.clear), onPressed: () {
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
                        child: _buildRow(_newDataList[index]),
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

  Widget _buildRow(CountryInfo country) {
    return InkWell(
      onTap: (){
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
                    trailing: Icon(Icons.arrow_forward_ios )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _seeCountryDetails(CountryInfo c){
    return Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return new CountryDetails(c);
            }
        ),
    );
  }

  void _updateCountries() async {
    Response response = await restClient.get(COUNTRY_SERVICE_URL);
    if (response.statusCode == 200) {
      _suggestions = (response.data as List)
          .map((json) => CountryInfo.fromJson(json))
          .where((country) => country.code != null && country.name != null && _favorites.contains(country.code))
          .toList();
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

  void _fillList(){
    _newDataList.clear();
    _newDataList.addAll(_suggestions);
    _textController.clear();
  }
}