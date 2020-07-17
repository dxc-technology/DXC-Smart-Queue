import 'package:flutter/material.dart';
import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/blocs/train_search_bloc.dart';
import 'package:mtahackathon/models/location.dart';

class LocationSearchPage extends SearchDelegate<Location> {


  LocationSearchPage();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {
        query = "";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
      close(context, null);
    });
  }

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    trainSearchBloc.filterLocations(query);
    return resultsStreamBuilder();
  }

  Widget resultsStreamBuilder() {
    return StreamBuilder(
      stream: trainSearchBloc.locationsSearchStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(child: CircularProgressIndicator());
              break;
            case Status.COMPLETED:
              return buildList(snapshot);
              break;
            case Status.ERROR:
              return Text(snapshot.error.toString());
              break;
          }
        }
        return Container();
      },
    );
  }

  Widget buildList(AsyncSnapshot<ApiResponse<List<Location>>> snapshot) {
    if (snapshot.data.data.length == 0) {
      return Center(
        child: Text(
          'No results found for \"$query\"',
          style: TextStyle(
              fontSize: 16.0
          ),
        ),
      );
    } else {
      return Scrollbar(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: snapshot.data.data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child:  Container(
                child:  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    snapshot.data.data[index].address,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ),
              ),
              onTap: () {
                close(context, snapshot.data.data.elementAt(index));
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      );
    }
  }
}