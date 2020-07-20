import 'package:flutter/material.dart';
import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/blocs/saved_routes_bloc.dart';
import 'package:mtahackathon/blocs/train_search_bloc.dart';
import 'package:mtahackathon/models/saved_route.dart';
import 'package:mtahackathon/utils/stateful_wrapper.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/views/partials/api_error.dart';
import 'package:mtahackathon/views/partials/loading.dart';

class SavedRoutes extends StatelessWidget {
  const SavedRoutes({Key key, this.onTap}) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Text(
              'Select from Saved routes',
              style: TextStyle(
                  color: Styles.greenHeader,
                  fontSize: 22,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: StatefulWrapper(
              onInit: _handleOnInit,
              child: StreamBuilder(
                stream: savedRouteBloc.savedRoutesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Loading(
                          loadingMessage: snapshot.data.message,
                        );
                        break;
                      case Status.COMPLETED:
                        return _getSavedRoutesList(context, snapshot.data.data);
                        break;
                      case Status.ERROR:
                        return ApiError(
                          errorMessage: snapshot.data.message,
                          onRetryPressed: () => savedRouteBloc.getSavedRoutes(),
                        );
                        break;
                    }
                  }
                  return Container();
                },
              ),
            ),
          ),
//          Expanded(
//            flex: 1,
//            child: Padding(
//              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  RaisedButton(
//                    child: Row(
//                      children: <Widget>[
//                        Text(
//                          'Add to saved routes',
//                          style: TextStyle(color: Colors.white),
//                        ),
//                        SizedBox(width: 8),
//                        Icon(
//                          Icons.save,
//                          color: Colors.white,
//                          size: 24,
//                        ),
//                      ],
//                    ),
//                    color: Styles.appPrimaryColor,
//                    onPressed: () {
//                      Navigator.popAndPushNamed(context, '/saved_routes');
//                    },
//                  ),
//                  RaisedButton(
//                    child: Row(
//                      children: <Widget>[
//                        Text(
//                          'Search trains',
//                          style: TextStyle(color: Colors.white),
//                        ),
//                        SizedBox(width: 8),
//                        Icon(
//                          Icons.search,
//                          color: Colors.white,
//                          size: 24,
//                        ),
//                      ],
//                    ),
//                    color: Styles.appAccentColor,
//                    onPressed: () {
//                      Navigator.popAndPushNamed(context, '/search_results',
//                          arguments: {'initiateSearch': true});
//                    },
//                  ),
//                ],
//              ),
//            ),
//          ),
        ],
      ),
    );
  }

  Widget _getSavedRoutesList(BuildContext context, List<SavedRoute> list) {
    if (list != null && list.isNotEmpty) {
      return Center(
        child: Text('No saved routes found.'),
      );
//      return Column(
//        // mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Expanded(
//            child: Column(
//              children: <Widget>[
//                Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: Padding(
//                        padding:
//                            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
//                        child: Text(
//                          'From',
//                          style: TextStyle(
//                              fontWeight: FontWeight.w500, color: Colors.black),
//                        ),
//                      ),
//                    ),
//                    Expanded(
//                      child: Padding(
//                        padding:
//                            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
//                        child: Text(
//                          'To',
//                          style: TextStyle(
//                              fontWeight: FontWeight.w500, color: Colors.black),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//                Divider(
//                  thickness: 3,
//                  color: Styles.greenHeader,
//                ),
//                ListView.separated(
//                  shrinkWrap: true,
//                  itemCount: list.length,
//                  padding: EdgeInsets.only(top: 4.0),
//                  scrollDirection: Axis.vertical,
//                  itemBuilder: (context, index) {
//                    return Padding(
//                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
//                      child: _getListItem(context, list[index]),
//                    );
//                  },
//                  separatorBuilder: (context, index) => Divider(
//                    thickness: 1,
//                    color: Styles.greenHeader,
//                    height: 4,
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ],
//      );
    } else {
      return Center(
        child: Text('No saved routes found.'),
      );
    }
  }

  Widget _getListItem(BuildContext context, SavedRoute route) {
    return InkWell(
      splashColor: Theme.of(context).primaryColorLight,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.radio_button_checked,
                    color: Styles.appPrimaryColor,
                    size: 18,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    '${route.fromStation}',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 32),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Color(Styles.redColor),
                    size: 18,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    '${route.toStation}',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        // trainSearchBloc.setSavedStations(route.fromStation, route.toStation);
        Navigator.popAndPushNamed(context, '/search_results',
            arguments: {'initiateSearch': true});
        // trainSearchBloc.searchTrains();
      },
    );
  }

  void _handleOnInit() {
    Future.delayed(const Duration(milliseconds: 500), () {
      savedRouteBloc.getSavedRoutes();
    });
  }
}
