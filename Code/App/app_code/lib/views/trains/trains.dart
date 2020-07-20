import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/blocs/train_search_bloc.dart';
import 'package:mtahackathon/models/Queue.dart';
import 'package:mtahackathon/models/location.dart';
import 'package:mtahackathon/models/train_schedule.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';
import 'package:mtahackathon/views/home/Home.dart';
import 'package:mtahackathon/views/partials/api_error.dart';
import 'package:mtahackathon/views/partials/drawer.dart';
import 'package:mtahackathon/views/partials/loading.dart';
import 'package:mtahackathon/views/trains/location_search.dart';
import 'package:mtahackathon/views/trains/saved_routes.dart';
import 'package:mtahackathon/views/trains/search_results.dart';
import 'package:mtahackathon/views/trains/train_schedule_details.dart';

class TrainsView extends StatefulWidget {
  const TrainsView({Key key, this.fragment}) : super(key: key);

  final Fragment fragment;

  @override
  _TrainsViewState createState() => _TrainsViewState();
}

class _TrainsViewState extends State<TrainsView> {

  GlobalKey fromKey = new GlobalKey<AutoCompleteTextFieldState<Location>>();
  GlobalKey toKey = new GlobalKey<AutoCompleteTextFieldState<Location>>();

  var selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    trainSearchBloc.getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
//      body: StreamBuilder(
//        stream: trainSearchBloc.locationsStream,
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            switch (snapshot.data.status) {
//              case Status.LOADING:
//                return Loading(
//                  loadingMessage: snapshot.data.message,
//                );
//                break;
//              case Status.COMPLETED:
//                return _getMainBodyContent(context);
//                break;
//              case Status.ERROR:
//                return ApiError(
//                  errorMessage: snapshot.data.message,
//                  onRetryPressed: () => trainSearchBloc.getLocations(),
//                );
//                break;
//            }
//          }
//          return Container();
//        },
//      ),
    body: _getMainBodyContent(context),
    );
  }

  Widget _getMainBodyContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.maxFinite,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _getFromFormField(),
                SizedBox(
                  height: 16,
                  width: double.maxFinite,
                ),
                _getToFormField(),
                SizedBox(
                  height: 16,
                  width: double.maxFinite,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.date_range,
                          color: Colors.white,
                        ),
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () => _selectDate(context),
                              child: StreamBuilder<DateTime>(
                                initialData: DateTime.now(),
                                  stream: trainSearchBloc.date,
                                builder: (context, snapshot) {
                                  return Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${TimeUtils.getDateStamp(snapshot.data.toString())}',
                                        style: TextStyle(
                                            color: Colors.black
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),

                                  );
                                }
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.watch,
                                  color: Colors.white,
                                ),
                              )),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () => _selectTime(context),
                              child: StreamBuilder<TimeOfDay>(
                                stream: trainSearchBloc.time,
                                initialData: TimeOfDay.now(),
                                builder: (context, snapshot) {
                                  return Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${snapshot.data.format(context)}',
                                        style: TextStyle(
                                            color: Colors.black
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),

                                  );
                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                      flex: 8,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                  width: double.maxFinite,
                ),
              ],
            ),
          ),
        ),
        Expanded(
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  // Define the default brightness and colors
                  // brightness: Brightness.dark,
                  primaryColor: Styles.appPrimaryColor,
                  accentColor: Styles.appAccentColor,
                  brightness: Brightness.light,

                  // for drawer color
                  canvasColor: Styles.appCanvasColor,

                  // Define the default font family.
                  fontFamily: 'Montserrat',

                  // Define the default TextTheme. Use this to specify the default
                  // text styling for headlines, titles, bodies of text, and more.
                  textTheme: Styles.appTextTheme,
                ),
                initialRoute: '/search_results',
                routes: {
              '/saved_routes': (context) => SavedRoutes(),
              '/search_results': (context) => TrainSearchResult(),
              '/schedule_details': (context) => TrainScheduleDetails(queue: _getTrainSchedule(context), bestQueue: _getBestQueue(context),),
            })),
      ],
    );
  }

  Queue _getTrainSchedule(context) {
    Map<String, Queue> param = ModalRoute.of(context).settings.arguments as Map<String, Queue>;
    return param['selectedSchedule'];
  }

  Queue _getBestQueue(context) {
    Map<String, Queue> param = ModalRoute.of(context).settings.arguments as Map<String, Queue>;
    return param['bestSchedule'];
  }

  Widget _getFromFormField() {
    return StreamBuilder<Location>(
        stream: trainSearchBloc.from,
      builder: (context, snapshot) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'From:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              flex: 2,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: FlatButton(
                  color: Colors.white,
                  child: StreamBuilder<Location>(
                      initialData: Location()..address = "",
                      stream: trainSearchBloc.from,
                      builder: (context, snapshot) {
                        return Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${snapshot.data?.address ?? ""}',
                                style: TextStyle(
                                    color: Colors.black
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),

                        );
                      }
                  ),
                  onPressed: () async {
                    trainSearchBloc.changeFrom(await showSearch(context: context, delegate: LocationSearchPage()));
                  },
                ),
              ),







//              child: AutoCompleteTextField<Location>(
//                key: fromKey,
//                decoration: InputDecoration(
//                  isDense: true,
//                  contentPadding: EdgeInsets.all(10),
//                  //contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
//                  errorText: snapshot.error,
//                    filled: true,
//                    fillColor: Colors.white,
//                ),
//                itemSubmitted: trainSearchBloc.changeFrom,
//                controller: trainSearchBloc.fromTextEditController,
//                itemFilter: (item, query) {
//                  print('query $query');
//                  return item.address
//                      .toLowerCase()
//                      .startsWith(query.toLowerCase());
//                },
//                itemSorter: (a, b) {
//                  return a.address.compareTo(b.address);
//                },
//                itemBuilder: (context, item) {
//                  // ui for the autocompelete row
//                  return row(item);
//                },
//                clearOnSubmit: false,
//                suggestions: trainSearchBloc.locations,
//              ),
              flex: 8,
            ),
            SizedBox(
              width: 16,
            ),
          ],
        );
      }
    );
  }

  Widget _getToFormField() {
    return StreamBuilder<Location>(
      stream: trainSearchBloc.to,
      builder: (context, snapshot) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'To:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              flex: 2,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: FlatButton(
                  color: Colors.white,
                  child: StreamBuilder<Location>(
                      initialData: Location()..address = "",
                      stream: trainSearchBloc.to,
                      builder: (context, snapshot) {
                        return Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${snapshot.data?.address ?? ""}',
                                style: TextStyle(
                                    color: Colors.black
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),

                        );
                      }
                  ),
                  onPressed: () async {
                    trainSearchBloc.changeTo(await showSearch(context: context, delegate: LocationSearchPage()));
                  },
                ),
              ),
              flex: 8,
            ),
            SizedBox(
              width: 16,
            ),
          ],
        );
      }
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    trainSearchBloc.changeDate(DateTime.now());
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: _getFirstDate(),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                  primary: Styles.appPrimaryColor,
                  secondary: Styles.appAccentColor
              ),
            ),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate)
      trainSearchBloc.changeDate(picked);
  }

  DateTime _getFirstDate() {
    DateTime today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  Future<void> _selectTime(BuildContext context) async {
    trainSearchBloc.changeTime.call(TimeOfDay.now());
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (picked != null) trainSearchBloc.changeTime.call(picked);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
