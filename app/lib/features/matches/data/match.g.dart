// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMatchCollection on Isar {
  IsarCollection<Match> get matchs => this.collection();
}

const MatchSchema = CollectionSchema(
  name: r'Match',
  id: -4384922031457139852,
  properties: {
    r'attendance': PropertySchema(
      id: 0,
      name: r'attendance',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isSeeded': PropertySchema(
      id: 2,
      name: r'isSeeded',
      type: IsarType.bool,
    ),
    r'kickoffAtUtc': PropertySchema(
      id: 3,
      name: r'kickoffAtUtc',
      type: IsarType.dateTime,
    ),
    r'matchId': PropertySchema(
      id: 4,
      name: r'matchId',
      type: IsarType.string,
    ),
    r'matchStatus': PropertySchema(
      id: 5,
      name: r'matchStatus',
      type: IsarType.string,
    ),
    r'matchday': PropertySchema(
      id: 6,
      name: r'matchday',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 7,
      name: r'notes',
      type: IsarType.string,
    ),
    r'penaltyA': PropertySchema(
      id: 8,
      name: r'penaltyA',
      type: IsarType.long,
    ),
    r'penaltyB': PropertySchema(
      id: 9,
      name: r'penaltyB',
      type: IsarType.long,
    ),
    r'reminders': PropertySchema(
      id: 10,
      name: r'reminders',
      type: IsarType.longList,
    ),
    r'replayPlannedAt': PropertySchema(
      id: 11,
      name: r'replayPlannedAt',
      type: IsarType.dateTime,
    ),
    r'replayPlannerEnabled': PropertySchema(
      id: 12,
      name: r'replayPlannerEnabled',
      type: IsarType.bool,
    ),
    r'scoreA': PropertySchema(
      id: 13,
      name: r'scoreA',
      type: IsarType.long,
    ),
    r'scoreB': PropertySchema(
      id: 14,
      name: r'scoreB',
      type: IsarType.long,
    ),
    r'sourceText': PropertySchema(
      id: 15,
      name: r'sourceText',
      type: IsarType.string,
    ),
    r'sourceTimezone': PropertySchema(
      id: 16,
      name: r'sourceTimezone',
      type: IsarType.string,
    ),
    r'teamA': PropertySchema(
      id: 17,
      name: r'teamA',
      type: IsarType.string,
    ),
    r'teamB': PropertySchema(
      id: 18,
      name: r'teamB',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 19,
      name: r'title',
      type: IsarType.string,
    ),
    r'tournamentId': PropertySchema(
      id: 20,
      name: r'tournamentId',
      type: IsarType.string,
    ),
    r'userTimezone': PropertySchema(
      id: 21,
      name: r'userTimezone',
      type: IsarType.string,
    ),
    r'venueCity': PropertySchema(
      id: 22,
      name: r'venueCity',
      type: IsarType.string,
    ),
    r'venueIanaTimezone': PropertySchema(
      id: 23,
      name: r'venueIanaTimezone',
      type: IsarType.string,
    ),
    r'venueName': PropertySchema(
      id: 24,
      name: r'venueName',
      type: IsarType.string,
    ),
    r'winner': PropertySchema(
      id: 25,
      name: r'winner',
      type: IsarType.string,
    ),
    r'worldCupGroup': PropertySchema(
      id: 26,
      name: r'worldCupGroup',
      type: IsarType.string,
    ),
    r'worldCupRound': PropertySchema(
      id: 27,
      name: r'worldCupRound',
      type: IsarType.string,
    )
  },
  estimateSize: _matchEstimateSize,
  serialize: _matchSerialize,
  deserialize: _matchDeserialize,
  deserializeProp: _matchDeserializeProp,
  idName: r'id',
  indexes: {
    r'matchId': IndexSchema(
      id: -6517933327003962923,
      name: r'matchId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'matchId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'kickoffAtUtc': IndexSchema(
      id: 710411021220794938,
      name: r'kickoffAtUtc',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'kickoffAtUtc',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isSeeded': IndexSchema(
      id: -6327517920657248179,
      name: r'isSeeded',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isSeeded',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'tournamentId': IndexSchema(
      id: -716810079468899455,
      name: r'tournamentId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tournamentId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _matchGetId,
  getLinks: _matchGetLinks,
  attach: _matchAttach,
  version: '3.1.0+1',
);

int _matchEstimateSize(
  Match object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.attendance;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.matchId.length * 3;
  {
    final value = object.matchStatus;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.notes.length * 3;
  bytesCount += 3 + object.reminders.length * 8;
  {
    final value = object.sourceText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sourceTimezone.length * 3;
  bytesCount += 3 + object.teamA.length * 3;
  bytesCount += 3 + object.teamB.length * 3;
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.tournamentId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userTimezone.length * 3;
  {
    final value = object.venueCity;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.venueIanaTimezone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.venueName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.winner;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.worldCupGroup;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.worldCupRound;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _matchSerialize(
  Match object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.attendance);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeBool(offsets[2], object.isSeeded);
  writer.writeDateTime(offsets[3], object.kickoffAtUtc);
  writer.writeString(offsets[4], object.matchId);
  writer.writeString(offsets[5], object.matchStatus);
  writer.writeLong(offsets[6], object.matchday);
  writer.writeString(offsets[7], object.notes);
  writer.writeLong(offsets[8], object.penaltyA);
  writer.writeLong(offsets[9], object.penaltyB);
  writer.writeLongList(offsets[10], object.reminders);
  writer.writeDateTime(offsets[11], object.replayPlannedAt);
  writer.writeBool(offsets[12], object.replayPlannerEnabled);
  writer.writeLong(offsets[13], object.scoreA);
  writer.writeLong(offsets[14], object.scoreB);
  writer.writeString(offsets[15], object.sourceText);
  writer.writeString(offsets[16], object.sourceTimezone);
  writer.writeString(offsets[17], object.teamA);
  writer.writeString(offsets[18], object.teamB);
  writer.writeString(offsets[19], object.title);
  writer.writeString(offsets[20], object.tournamentId);
  writer.writeString(offsets[21], object.userTimezone);
  writer.writeString(offsets[22], object.venueCity);
  writer.writeString(offsets[23], object.venueIanaTimezone);
  writer.writeString(offsets[24], object.venueName);
  writer.writeString(offsets[25], object.winner);
  writer.writeString(offsets[26], object.worldCupGroup);
  writer.writeString(offsets[27], object.worldCupRound);
}

Match _matchDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Match();
  object.attendance = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.isSeeded = reader.readBool(offsets[2]);
  object.kickoffAtUtc = reader.readDateTime(offsets[3]);
  object.matchId = reader.readString(offsets[4]);
  object.matchStatus = reader.readStringOrNull(offsets[5]);
  object.matchday = reader.readLongOrNull(offsets[6]);
  object.notes = reader.readString(offsets[7]);
  object.penaltyA = reader.readLongOrNull(offsets[8]);
  object.penaltyB = reader.readLongOrNull(offsets[9]);
  object.reminders = reader.readLongList(offsets[10]) ?? [];
  object.replayPlannedAt = reader.readDateTimeOrNull(offsets[11]);
  object.replayPlannerEnabled = reader.readBool(offsets[12]);
  object.scoreA = reader.readLongOrNull(offsets[13]);
  object.scoreB = reader.readLongOrNull(offsets[14]);
  object.sourceText = reader.readStringOrNull(offsets[15]);
  object.sourceTimezone = reader.readString(offsets[16]);
  object.teamA = reader.readString(offsets[17]);
  object.teamB = reader.readString(offsets[18]);
  object.title = reader.readString(offsets[19]);
  object.tournamentId = reader.readStringOrNull(offsets[20]);
  object.userTimezone = reader.readString(offsets[21]);
  object.venueCity = reader.readStringOrNull(offsets[22]);
  object.venueIanaTimezone = reader.readStringOrNull(offsets[23]);
  object.venueName = reader.readStringOrNull(offsets[24]);
  object.winner = reader.readStringOrNull(offsets[25]);
  object.worldCupGroup = reader.readStringOrNull(offsets[26]);
  object.worldCupRound = reader.readStringOrNull(offsets[27]);
  return object;
}

P _matchDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongList(offset) ?? []) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _matchGetId(Match object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _matchGetLinks(Match object) {
  return [];
}

void _matchAttach(IsarCollection<dynamic> col, Id id, Match object) {
  object.id = id;
}

extension MatchByIndex on IsarCollection<Match> {
  Future<Match?> getByMatchId(String matchId) {
    return getByIndex(r'matchId', [matchId]);
  }

  Match? getByMatchIdSync(String matchId) {
    return getByIndexSync(r'matchId', [matchId]);
  }

  Future<bool> deleteByMatchId(String matchId) {
    return deleteByIndex(r'matchId', [matchId]);
  }

  bool deleteByMatchIdSync(String matchId) {
    return deleteByIndexSync(r'matchId', [matchId]);
  }

  Future<List<Match?>> getAllByMatchId(List<String> matchIdValues) {
    final values = matchIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'matchId', values);
  }

  List<Match?> getAllByMatchIdSync(List<String> matchIdValues) {
    final values = matchIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'matchId', values);
  }

  Future<int> deleteAllByMatchId(List<String> matchIdValues) {
    final values = matchIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'matchId', values);
  }

  int deleteAllByMatchIdSync(List<String> matchIdValues) {
    final values = matchIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'matchId', values);
  }

  Future<Id> putByMatchId(Match object) {
    return putByIndex(r'matchId', object);
  }

  Id putByMatchIdSync(Match object, {bool saveLinks = true}) {
    return putByIndexSync(r'matchId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMatchId(List<Match> objects) {
    return putAllByIndex(r'matchId', objects);
  }

  List<Id> putAllByMatchIdSync(List<Match> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'matchId', objects, saveLinks: saveLinks);
  }
}

extension MatchQueryWhereSort on QueryBuilder<Match, Match, QWhere> {
  QueryBuilder<Match, Match, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Match, Match, QAfterWhere> anyKickoffAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'kickoffAtUtc'),
      );
    });
  }

  QueryBuilder<Match, Match, QAfterWhere> anyIsSeeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSeeded'),
      );
    });
  }
}

extension MatchQueryWhere on QueryBuilder<Match, Match, QWhereClause> {
  QueryBuilder<Match, Match, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> matchIdEqualTo(String matchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'matchId',
        value: [matchId],
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> matchIdNotEqualTo(
      String matchId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matchId',
              lower: [],
              upper: [matchId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matchId',
              lower: [matchId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matchId',
              lower: [matchId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matchId',
              lower: [],
              upper: [matchId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> kickoffAtUtcEqualTo(
      DateTime kickoffAtUtc) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'kickoffAtUtc',
        value: [kickoffAtUtc],
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> kickoffAtUtcNotEqualTo(
      DateTime kickoffAtUtc) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kickoffAtUtc',
              lower: [],
              upper: [kickoffAtUtc],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kickoffAtUtc',
              lower: [kickoffAtUtc],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kickoffAtUtc',
              lower: [kickoffAtUtc],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kickoffAtUtc',
              lower: [],
              upper: [kickoffAtUtc],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> kickoffAtUtcGreaterThan(
    DateTime kickoffAtUtc, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'kickoffAtUtc',
        lower: [kickoffAtUtc],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> kickoffAtUtcLessThan(
    DateTime kickoffAtUtc, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'kickoffAtUtc',
        lower: [],
        upper: [kickoffAtUtc],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> kickoffAtUtcBetween(
    DateTime lowerKickoffAtUtc,
    DateTime upperKickoffAtUtc, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'kickoffAtUtc',
        lower: [lowerKickoffAtUtc],
        includeLower: includeLower,
        upper: [upperKickoffAtUtc],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> isSeededEqualTo(bool isSeeded) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isSeeded',
        value: [isSeeded],
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> isSeededNotEqualTo(
      bool isSeeded) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSeeded',
              lower: [],
              upper: [isSeeded],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSeeded',
              lower: [isSeeded],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSeeded',
              lower: [isSeeded],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSeeded',
              lower: [],
              upper: [isSeeded],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> tournamentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tournamentId',
        value: [null],
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> tournamentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tournamentId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> tournamentIdEqualTo(
      String? tournamentId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tournamentId',
        value: [tournamentId],
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> tournamentIdNotEqualTo(
      String? tournamentId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tournamentId',
              lower: [],
              upper: [tournamentId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tournamentId',
              lower: [tournamentId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tournamentId',
              lower: [tournamentId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tournamentId',
              lower: [],
              upper: [tournamentId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MatchQueryFilter on QueryBuilder<Match, Match, QFilterCondition> {
  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'attendance',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'attendance',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attendance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attendance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attendance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attendance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'attendance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'attendance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'attendance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'attendance',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attendance',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> attendanceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'attendance',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> isSeededEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSeeded',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> kickoffAtUtcEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kickoffAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> kickoffAtUtcGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kickoffAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> kickoffAtUtcLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kickoffAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> kickoffAtUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kickoffAtUtc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matchId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchId',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matchId',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'matchStatus',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'matchStatus',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matchStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matchStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matchStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matchStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matchStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matchStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matchStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matchStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchdayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'matchday',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchdayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'matchday',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchdayEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchday',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchdayGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matchday',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchdayLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matchday',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> matchdayBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matchday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'penaltyA',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'penaltyA',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyAEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'penaltyA',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyAGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'penaltyA',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyALessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'penaltyA',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyABetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'penaltyA',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'penaltyB',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'penaltyB',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyBEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'penaltyB',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyBGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'penaltyB',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyBLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'penaltyB',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> penaltyBBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'penaltyB',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminders',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminders',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminders',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminders',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminders',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminders',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminders',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminders',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminders',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> remindersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reminders',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> replayPlannedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'replayPlannedAt',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> replayPlannedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'replayPlannedAt',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> replayPlannedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replayPlannedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> replayPlannedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'replayPlannedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> replayPlannedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'replayPlannedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> replayPlannedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'replayPlannedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> replayPlannerEnabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replayPlannerEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scoreA',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scoreA',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreAEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scoreA',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreAGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scoreA',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreALessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scoreA',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreABetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scoreA',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scoreB',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scoreB',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreBEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scoreB',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreBGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scoreB',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreBLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scoreB',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> scoreBBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scoreB',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceText',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceText',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceText',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceText',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceTimezone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceTimezone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceTimezone',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> sourceTimezoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceTimezone',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamAEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamA',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamAGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teamA',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamALessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teamA',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamABetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teamA',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamAStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'teamA',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamAEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'teamA',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamAContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'teamA',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamAMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'teamA',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamAIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamA',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamAIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'teamA',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamB',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teamB',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teamB',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teamB',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'teamB',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'teamB',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'teamB',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'teamB',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamB',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> teamBIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'teamB',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tournamentId',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tournamentId',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tournamentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tournamentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tournamentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tournamentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tournamentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tournamentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tournamentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tournamentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tournamentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> tournamentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tournamentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userTimezone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userTimezone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userTimezone',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> userTimezoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userTimezone',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'venueCity',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'venueCity',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venueCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'venueCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'venueCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'venueCity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'venueCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'venueCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'venueCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'venueCity',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venueCity',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueCityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'venueCity',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueIanaTimezoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'venueIanaTimezone',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition>
      venueIanaTimezoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'venueIanaTimezone',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueIanaTimezoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venueIanaTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition>
      venueIanaTimezoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'venueIanaTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueIanaTimezoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'venueIanaTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueIanaTimezoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'venueIanaTimezone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueIanaTimezoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'venueIanaTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueIanaTimezoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'venueIanaTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueIanaTimezoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'venueIanaTimezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueIanaTimezoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'venueIanaTimezone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueIanaTimezoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venueIanaTimezone',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition>
      venueIanaTimezoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'venueIanaTimezone',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'venueName',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'venueName',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'venueName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'venueName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venueName',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> venueNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'venueName',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'winner',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'winner',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'winner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'winner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'winner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'winner',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'winner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'winner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'winner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'winner',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'winner',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'winner',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'worldCupGroup',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'worldCupGroup',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'worldCupGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'worldCupGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'worldCupGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'worldCupGroup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'worldCupGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'worldCupGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'worldCupGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'worldCupGroup',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'worldCupGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupGroupIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'worldCupGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'worldCupRound',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'worldCupRound',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'worldCupRound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'worldCupRound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'worldCupRound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'worldCupRound',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'worldCupRound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'worldCupRound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'worldCupRound',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'worldCupRound',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'worldCupRound',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> worldCupRoundIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'worldCupRound',
        value: '',
      ));
    });
  }
}

extension MatchQueryObject on QueryBuilder<Match, Match, QFilterCondition> {}

extension MatchQueryLinks on QueryBuilder<Match, Match, QFilterCondition> {}

extension MatchQuerySortBy on QueryBuilder<Match, Match, QSortBy> {
  QueryBuilder<Match, Match, QAfterSortBy> sortByAttendance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendance', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByAttendanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendance', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByIsSeeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeeded', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByIsSeededDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeeded', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByKickoffAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kickoffAtUtc', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByKickoffAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kickoffAtUtc', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByMatchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchId', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByMatchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchId', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByMatchStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchStatus', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByMatchStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchStatus', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByMatchday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchday', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByMatchdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchday', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByPenaltyA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyA', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByPenaltyADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyA', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByPenaltyB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyB', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByPenaltyBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyB', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByReplayPlannedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replayPlannedAt', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByReplayPlannedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replayPlannedAt', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByReplayPlannerEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replayPlannerEnabled', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByReplayPlannerEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replayPlannerEnabled', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByScoreA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreA', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByScoreADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreA', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByScoreB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreB', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByScoreBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreB', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortBySourceText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceText', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortBySourceTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceText', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortBySourceTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTimezone', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortBySourceTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTimezone', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByTeamA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamA', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByTeamADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamA', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByTeamB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamB', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByTeamBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamB', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByTournamentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tournamentId', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByTournamentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tournamentId', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByUserTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userTimezone', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByUserTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userTimezone', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByVenueCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueCity', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByVenueCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueCity', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByVenueIanaTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueIanaTimezone', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByVenueIanaTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueIanaTimezone', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByVenueName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueName', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByVenueNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueName', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByWinner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winner', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByWinnerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winner', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByWorldCupGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worldCupGroup', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByWorldCupGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worldCupGroup', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByWorldCupRound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worldCupRound', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByWorldCupRoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worldCupRound', Sort.desc);
    });
  }
}

extension MatchQuerySortThenBy on QueryBuilder<Match, Match, QSortThenBy> {
  QueryBuilder<Match, Match, QAfterSortBy> thenByAttendance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendance', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByAttendanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendance', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByIsSeeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeeded', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByIsSeededDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeeded', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByKickoffAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kickoffAtUtc', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByKickoffAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kickoffAtUtc', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByMatchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchId', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByMatchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchId', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByMatchStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchStatus', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByMatchStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchStatus', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByMatchday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchday', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByMatchdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchday', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByPenaltyA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyA', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByPenaltyADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyA', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByPenaltyB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyB', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByPenaltyBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyB', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByReplayPlannedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replayPlannedAt', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByReplayPlannedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replayPlannedAt', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByReplayPlannerEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replayPlannerEnabled', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByReplayPlannerEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replayPlannerEnabled', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByScoreA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreA', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByScoreADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreA', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByScoreB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreB', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByScoreBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreB', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenBySourceText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceText', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenBySourceTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceText', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenBySourceTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTimezone', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenBySourceTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTimezone', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByTeamA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamA', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByTeamADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamA', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByTeamB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamB', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByTeamBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamB', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByTournamentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tournamentId', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByTournamentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tournamentId', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByUserTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userTimezone', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByUserTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userTimezone', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByVenueCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueCity', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByVenueCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueCity', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByVenueIanaTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueIanaTimezone', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByVenueIanaTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueIanaTimezone', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByVenueName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueName', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByVenueNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueName', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByWinner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winner', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByWinnerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winner', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByWorldCupGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worldCupGroup', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByWorldCupGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worldCupGroup', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByWorldCupRound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worldCupRound', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByWorldCupRoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'worldCupRound', Sort.desc);
    });
  }
}

extension MatchQueryWhereDistinct on QueryBuilder<Match, Match, QDistinct> {
  QueryBuilder<Match, Match, QDistinct> distinctByAttendance(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attendance', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByIsSeeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSeeded');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByKickoffAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kickoffAtUtc');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByMatchId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByMatchStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matchStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByMatchday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matchday');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByPenaltyA() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'penaltyA');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByPenaltyB() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'penaltyB');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminders');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByReplayPlannedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'replayPlannedAt');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByReplayPlannerEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'replayPlannerEnabled');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByScoreA() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoreA');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByScoreB() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoreB');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctBySourceText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctBySourceTimezone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceTimezone',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByTeamA(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamA', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByTeamB(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamB', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByTournamentId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tournamentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByUserTimezone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userTimezone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByVenueCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'venueCity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByVenueIanaTimezone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'venueIanaTimezone',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByVenueName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'venueName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByWinner(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'winner', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByWorldCupGroup(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'worldCupGroup',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByWorldCupRound(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'worldCupRound',
          caseSensitive: caseSensitive);
    });
  }
}

extension MatchQueryProperty on QueryBuilder<Match, Match, QQueryProperty> {
  QueryBuilder<Match, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> attendanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attendance');
    });
  }

  QueryBuilder<Match, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Match, bool, QQueryOperations> isSeededProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSeeded');
    });
  }

  QueryBuilder<Match, DateTime, QQueryOperations> kickoffAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kickoffAtUtc');
    });
  }

  QueryBuilder<Match, String, QQueryOperations> matchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matchId');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> matchStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matchStatus');
    });
  }

  QueryBuilder<Match, int?, QQueryOperations> matchdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matchday');
    });
  }

  QueryBuilder<Match, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Match, int?, QQueryOperations> penaltyAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'penaltyA');
    });
  }

  QueryBuilder<Match, int?, QQueryOperations> penaltyBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'penaltyB');
    });
  }

  QueryBuilder<Match, List<int>, QQueryOperations> remindersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminders');
    });
  }

  QueryBuilder<Match, DateTime?, QQueryOperations> replayPlannedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'replayPlannedAt');
    });
  }

  QueryBuilder<Match, bool, QQueryOperations> replayPlannerEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'replayPlannerEnabled');
    });
  }

  QueryBuilder<Match, int?, QQueryOperations> scoreAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoreA');
    });
  }

  QueryBuilder<Match, int?, QQueryOperations> scoreBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoreB');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> sourceTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceText');
    });
  }

  QueryBuilder<Match, String, QQueryOperations> sourceTimezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceTimezone');
    });
  }

  QueryBuilder<Match, String, QQueryOperations> teamAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamA');
    });
  }

  QueryBuilder<Match, String, QQueryOperations> teamBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamB');
    });
  }

  QueryBuilder<Match, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> tournamentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tournamentId');
    });
  }

  QueryBuilder<Match, String, QQueryOperations> userTimezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userTimezone');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> venueCityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'venueCity');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> venueIanaTimezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'venueIanaTimezone');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> venueNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'venueName');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> winnerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'winner');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> worldCupGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'worldCupGroup');
    });
  }

  QueryBuilder<Match, String?, QQueryOperations> worldCupRoundProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'worldCupRound');
    });
  }
}
