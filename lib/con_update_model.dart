class ConUpdateModel {
  final ConstructionTime? constructionTime;
  final List<Entries>? entries;
  final String? editedBy;

  ConUpdateModel({
    this.constructionTime,
    this.entries,
    this.editedBy,
  });

  ConUpdateModel.fromJson(Map<String, dynamic> json)
      : constructionTime = (json['ConstructionTime'] as Map<String,dynamic>?) != null ? ConstructionTime.fromJson(json['ConstructionTime'] as Map<String,dynamic>) : null,
        entries = (json['Entries'] as List?)?.map((dynamic e) => Entries.fromJson(e as Map<String,dynamic>)).toList(),
        editedBy = json['EditedBy'] as String?;

  Map<String, dynamic> toJson() => {
    'ConstructionTime' : constructionTime?.toJson(),
    'Entries' : entries?.map((e) => e.toJson()).toList(),
    'EditedBy' : editedBy
  };
}

class ConstructionTime {
  final String? startActual;
  final String? endActual;

  ConstructionTime({
    this.startActual,
    this.endActual,
  });

  ConstructionTime.fromJson(Map<String, dynamic> json)
      : startActual = json['StartActual'] as String?,
        endActual = json['EndActual'] as String?;

  Map<String, dynamic> toJson() => {
    'StartActual' : startActual,
    'EndActual' : endActual
  };
}

class Entries {
  final int? constructionTimeEntryTypeID;
  final int? durationActual;
  final dynamic predecessorActual;
  final String? successorActual;
  final String? startActual;
  final String? endActual;

  Entries({
    this.constructionTimeEntryTypeID,
    this.durationActual,
    this.predecessorActual,
    this.successorActual,
    this.startActual,
    this.endActual,
  });

  Entries.fromJson(Map<String, dynamic> json)
      : constructionTimeEntryTypeID = json['ConstructionTimeEntryTypeID'] as int?,
        durationActual = json['DurationActual'] as int?,
        predecessorActual = json['PredecessorActual'],
        successorActual = json['SuccessorActual'] as String?,
        startActual = json['StartActual'] as String?,
        endActual = json['EndActual'] as String?;

  Map<String, dynamic> toJson() => {
    'ConstructionTimeEntryTypeID' : constructionTimeEntryTypeID,
    'DurationActual' : durationActual,
    'PredecessorActual' : predecessorActual,
    'SuccessorActual' : successorActual,
    'StartActual' : startActual,
    'EndActual' : endActual
  };
}