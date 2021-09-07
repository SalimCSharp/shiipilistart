

import 'package:flutter/material.dart';
import 'map_provider.dart';
import 'package:provider/provider.dart';

class AddressSearch extends SearchDelegate {

  final sessionToken;
  AddressSearch(this.sessionToken);


  @override
  List<Widget> buildActions(BuildContext context) {

    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {

    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return FutureBuilder<List<Suggestion>>(
      future: query == ""
          ? null
          : Provider.of<MapProvider>(context).fetchSuggestions(
          query, Localizations.localeOf(context).languageCode,sessionToken),

      builder: (context, snapshot) => query == ''
          ? Container(
            padding: EdgeInsets.all(16.0),
            child: Text('Enter your address'),
           )
           : snapshot.hasData
           ? ListView.builder(

              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                 title:
                   Text((snapshot.data![index]).description),
                      onTap: () {
                         close(context, snapshot.data![index]);
                       },
                trailing: Icon(
                  Icons.subdirectory_arrow_left_rounded,
                  color: Colors.grey,
                ) ,
        ),
        itemCount: snapshot.data!.length,

      )
          : Container(child: Center(child: CircularProgressIndicator())),
    );
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }

  // final sessionToken;
  // AddressSearch(this.sessionToken);


}