class TrainSchedule {

  int id;

  String arrivalStation;

  String departureStation;

  String etaMillis;

  String queueOpenMillis;

  String queueCloseMillis;

  String queueOccupancyPercentage;

  String trainOccupancyPercentage;

  String trainId;

  num pointsWorth;

  TrainSchedule(
      {this.id,
        this.arrivalStation,
        this.departureStation,
        this.etaMillis,
        this.queueOpenMillis,
        this.queueCloseMillis,
        this.queueOccupancyPercentage,
        this.trainOccupancyPercentage,
        this.trainId,
        this.pointsWorth});

  TrainSchedule.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }

}