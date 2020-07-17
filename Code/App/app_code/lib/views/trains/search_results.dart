import 'package:flutter/material.dart';
import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/blocs/train_search_bloc.dart';
import 'package:mtahackathon/utils/stateful_wrapper.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/views/partials/api_error.dart';
import 'package:mtahackathon/views/partials/loading.dart';
import 'package:mtahackathon/views/trains/train_schedule_list.dart';

class TrainSearchResult extends StatelessWidget {
  const TrainSearchResult({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulWrapper(
        onInit: () => _handleOnInit(context),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: StreamBuilder(
                stream: trainSearchBloc.queueListStream,
                builder: (context, snapshot) {
                  print(' hasData : ${snapshot.hasData}');
                  if (snapshot.hasData) {
                    print(' status : ${snapshot.data.status}');
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Loading(
                          loadingMessage: snapshot.data.message,
                        );
                        break;
                      case Status.COMPLETED:
                        return TrainScheduleList(
                            scheduleList: snapshot.data.data, bestQueue: trainSearchBloc.getBestQueue(snapshot.data.data));
                        break;
                      case Status.ERROR:
                        return ApiError(
                          errorMessage: snapshot.data.message,
                          onRetryPressed: () => trainSearchBloc.searchTrains(),
                        );
                        break;
                    }
                  }
                  return Container();
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Sort by best queue',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.sort,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                      color: Styles.appPrimaryColor,
                      onPressed: () {
                        trainSearchBloc.sortQueues();
                      },
                    ),
                    RaisedButton(
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Search trains',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                      color: Styles.appAccentColor,
                      onPressed: () {
                        trainSearchBloc.searchTrains();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOnInit(context) {
    Map<String, bool> params =
        ModalRoute.of(context).settings.arguments as Map<String, bool>;
    if (params != null && params['initiateSearch']) {
      Future.delayed(const Duration(milliseconds: 500), () {
        trainSearchBloc.searchTrains();
      });
    }
  }
}
