// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetPlayerSettingsCollection on Isar {
  IsarCollection<PlayerSettings> get playerSettingss => getCollection();
}

const PlayerSettingsSchema = CollectionSchema(
  name: 'PlayerSettings',
  schema:
      '{"name":"PlayerSettings","idName":"id","properties":[{"name":"currentSongIndex","type":"Long"},{"name":"currentTheme","type":"String"},{"name":"isShuffleOn","type":"Bool"},{"name":"playlist","type":"StringList"},{"name":"repeatState","type":"Long"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'currentSongIndex': 0,
    'currentTheme': 1,
    'isShuffleOn': 2,
    'playlist': 3,
    'repeatState': 4
  },
  listProperties: {'playlist'},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _playerSettingsGetId,
  setId: _playerSettingsSetId,
  getLinks: _playerSettingsGetLinks,
  attachLinks: _playerSettingsAttachLinks,
  serializeNative: _playerSettingsSerializeNative,
  deserializeNative: _playerSettingsDeserializeNative,
  deserializePropNative: _playerSettingsDeserializePropNative,
  serializeWeb: _playerSettingsSerializeWeb,
  deserializeWeb: _playerSettingsDeserializeWeb,
  deserializePropWeb: _playerSettingsDeserializePropWeb,
  version: 3,
);

int? _playerSettingsGetId(PlayerSettings object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _playerSettingsSetId(PlayerSettings object, int id) {
  object.id = id;
}

List<IsarLinkBase> _playerSettingsGetLinks(PlayerSettings object) {
  return [];
}

void _playerSettingsSerializeNative(
    IsarCollection<PlayerSettings> collection,
    IsarRawObject rawObj,
    PlayerSettings object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.currentSongIndex;
  final _currentSongIndex = value0;
  final value1 = object.currentTheme;
  final _currentTheme = IsarBinaryWriter.utf8Encoder.convert(value1);
  dynamicSize += (_currentTheme.length) as int;
  final value2 = object.isShuffleOn;
  final _isShuffleOn = value2;
  final value3 = object.playlist;
  dynamicSize += (value3.length) * 8;
  final bytesList3 = <IsarUint8List>[];
  for (var str in value3) {
    final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
    bytesList3.add(bytes);
    dynamicSize += bytes.length as int;
  }
  final _playlist = bytesList3;
  final value4 = object.repeatState;
  final _repeatState = value4;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], _currentSongIndex);
  writer.writeBytes(offsets[1], _currentTheme);
  writer.writeBool(offsets[2], _isShuffleOn);
  writer.writeStringList(offsets[3], _playlist);
  writer.writeLong(offsets[4], _repeatState);
}

PlayerSettings _playerSettingsDeserializeNative(
    IsarCollection<PlayerSettings> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = PlayerSettings(
    currentSongIndex: reader.readLong(offsets[0]),
    currentTheme: reader.readString(offsets[1]),
    id: id,
    isShuffleOn: reader.readBool(offsets[2]),
    playlist: reader.readStringList(offsets[3]) ?? [],
    repeatState: reader.readLong(offsets[4]),
  );
  return object;
}

P _playerSettingsDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _playerSettingsSerializeWeb(
    IsarCollection<PlayerSettings> collection, PlayerSettings object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'currentSongIndex', object.currentSongIndex);
  IsarNative.jsObjectSet(jsObj, 'currentTheme', object.currentTheme);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'isShuffleOn', object.isShuffleOn);
  IsarNative.jsObjectSet(jsObj, 'playlist', object.playlist);
  IsarNative.jsObjectSet(jsObj, 'repeatState', object.repeatState);
  return jsObj;
}

PlayerSettings _playerSettingsDeserializeWeb(
    IsarCollection<PlayerSettings> collection, dynamic jsObj) {
  final object = PlayerSettings(
    currentSongIndex: IsarNative.jsObjectGet(jsObj, 'currentSongIndex') ??
        double.negativeInfinity,
    currentTheme: IsarNative.jsObjectGet(jsObj, 'currentTheme') ?? '',
    id: IsarNative.jsObjectGet(jsObj, 'id'),
    isShuffleOn: IsarNative.jsObjectGet(jsObj, 'isShuffleOn') ?? false,
    playlist: (IsarNative.jsObjectGet(jsObj, 'playlist') as List?)
            ?.map((e) => e ?? '')
            .toList()
            .cast<String>() ??
        [],
    repeatState:
        IsarNative.jsObjectGet(jsObj, 'repeatState') ?? double.negativeInfinity,
  );
  return object;
}

P _playerSettingsDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'currentSongIndex':
      return (IsarNative.jsObjectGet(jsObj, 'currentSongIndex') ??
          double.negativeInfinity) as P;
    case 'currentTheme':
      return (IsarNative.jsObjectGet(jsObj, 'currentTheme') ?? '') as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'isShuffleOn':
      return (IsarNative.jsObjectGet(jsObj, 'isShuffleOn') ?? false) as P;
    case 'playlist':
      return ((IsarNative.jsObjectGet(jsObj, 'playlist') as List?)
              ?.map((e) => e ?? '')
              .toList()
              .cast<String>() ??
          []) as P;
    case 'repeatState':
      return (IsarNative.jsObjectGet(jsObj, 'repeatState') ??
          double.negativeInfinity) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _playerSettingsAttachLinks(
    IsarCollection col, int id, PlayerSettings object) {}

extension PlayerSettingsQueryWhereSort
    on QueryBuilder<PlayerSettings, PlayerSettings, QWhere> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension PlayerSettingsQueryWhere
    on QueryBuilder<PlayerSettings, PlayerSettings, QWhereClause> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idNotEqualTo(
      int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idLessThan(
      int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension PlayerSettingsQueryFilter
    on QueryBuilder<PlayerSettings, PlayerSettings, QFilterCondition> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentSongIndexEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'currentSongIndex',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentSongIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'currentSongIndex',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentSongIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'currentSongIndex',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentSongIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'currentSongIndex',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'currentTheme',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'currentTheme',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'currentTheme',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'currentTheme',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'currentTheme',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'currentTheme',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'currentTheme',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'currentTheme',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      isShuffleOnEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isShuffleOn',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistAnyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'playlist',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistAnyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'playlist',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistAnyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'playlist',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistAnyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'playlist',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'playlist',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'playlist',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistAnyContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'playlist',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistAnyMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'playlist',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      repeatStateEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'repeatState',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      repeatStateGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'repeatState',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      repeatStateLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'repeatState',
      value: value,
    ));
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      repeatStateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'repeatState',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension PlayerSettingsQueryLinks
    on QueryBuilder<PlayerSettings, PlayerSettings, QFilterCondition> {}

extension PlayerSettingsQueryWhereSortBy
    on QueryBuilder<PlayerSettings, PlayerSettings, QSortBy> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByCurrentSongIndex() {
    return addSortByInternal('currentSongIndex', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByCurrentSongIndexDesc() {
    return addSortByInternal('currentSongIndex', Sort.desc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByCurrentTheme() {
    return addSortByInternal('currentTheme', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByCurrentThemeDesc() {
    return addSortByInternal('currentTheme', Sort.desc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByIsShuffleOn() {
    return addSortByInternal('isShuffleOn', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByIsShuffleOnDesc() {
    return addSortByInternal('isShuffleOn', Sort.desc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByRepeatState() {
    return addSortByInternal('repeatState', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByRepeatStateDesc() {
    return addSortByInternal('repeatState', Sort.desc);
  }
}

extension PlayerSettingsQueryWhereSortThenBy
    on QueryBuilder<PlayerSettings, PlayerSettings, QSortThenBy> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByCurrentSongIndex() {
    return addSortByInternal('currentSongIndex', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByCurrentSongIndexDesc() {
    return addSortByInternal('currentSongIndex', Sort.desc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByCurrentTheme() {
    return addSortByInternal('currentTheme', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByCurrentThemeDesc() {
    return addSortByInternal('currentTheme', Sort.desc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByIsShuffleOn() {
    return addSortByInternal('isShuffleOn', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByIsShuffleOnDesc() {
    return addSortByInternal('isShuffleOn', Sort.desc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByRepeatState() {
    return addSortByInternal('repeatState', Sort.asc);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByRepeatStateDesc() {
    return addSortByInternal('repeatState', Sort.desc);
  }
}

extension PlayerSettingsQueryWhereDistinct
    on QueryBuilder<PlayerSettings, PlayerSettings, QDistinct> {
  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByCurrentSongIndex() {
    return addDistinctByInternal('currentSongIndex');
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByCurrentTheme({bool caseSensitive = true}) {
    return addDistinctByInternal('currentTheme', caseSensitive: caseSensitive);
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByIsShuffleOn() {
    return addDistinctByInternal('isShuffleOn');
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByRepeatState() {
    return addDistinctByInternal('repeatState');
  }
}

extension PlayerSettingsQueryProperty
    on QueryBuilder<PlayerSettings, PlayerSettings, QQueryProperty> {
  QueryBuilder<PlayerSettings, int, QQueryOperations>
      currentSongIndexProperty() {
    return addPropertyNameInternal('currentSongIndex');
  }

  QueryBuilder<PlayerSettings, String, QQueryOperations>
      currentThemeProperty() {
    return addPropertyNameInternal('currentTheme');
  }

  QueryBuilder<PlayerSettings, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<PlayerSettings, bool, QQueryOperations> isShuffleOnProperty() {
    return addPropertyNameInternal('isShuffleOn');
  }

  QueryBuilder<PlayerSettings, List<String>, QQueryOperations>
      playlistProperty() {
    return addPropertyNameInternal('playlist');
  }

  QueryBuilder<PlayerSettings, int, QQueryOperations> repeatStateProperty() {
    return addPropertyNameInternal('repeatState');
  }
}
