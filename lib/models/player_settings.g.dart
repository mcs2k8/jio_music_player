// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetPlayerSettingsCollection on Isar {
  IsarCollection<PlayerSettings> get playerSettings => this.collection();
}

const PlayerSettingsSchema = CollectionSchema(
  name: r'PlayerSettings',
  id: 5441166910175932327,
  properties: {
    r'albumIdsToRemove': PropertySchema(
      id: 0,
      name: r'albumIdsToRemove',
      type: IsarType.longList,
    ),
    r'artistIdsToRemove': PropertySchema(
      id: 1,
      name: r'artistIdsToRemove',
      type: IsarType.longList,
    ),
    r'currentSongIndex': PropertySchema(
      id: 2,
      name: r'currentSongIndex',
      type: IsarType.long,
    ),
    r'currentTheme': PropertySchema(
      id: 3,
      name: r'currentTheme',
      type: IsarType.string,
    ),
    r'foldersToRemove': PropertySchema(
      id: 4,
      name: r'foldersToRemove',
      type: IsarType.stringList,
    ),
    r'isEqualizerOn': PropertySchema(
      id: 5,
      name: r'isEqualizerOn',
      type: IsarType.bool,
    ),
    r'isShuffleOn': PropertySchema(
      id: 6,
      name: r'isShuffleOn',
      type: IsarType.bool,
    ),
    r'isSyncToCloudOn': PropertySchema(
      id: 7,
      name: r'isSyncToCloudOn',
      type: IsarType.bool,
    ),
    r'playlist': PropertySchema(
      id: 8,
      name: r'playlist',
      type: IsarType.stringList,
    ),
    r'repeatState': PropertySchema(
      id: 9,
      name: r'repeatState',
      type: IsarType.long,
    ),
    r'songIdsToRemove': PropertySchema(
      id: 10,
      name: r'songIdsToRemove',
      type: IsarType.longList,
    ),
    r'updatePlayerColorAutomatically': PropertySchema(
      id: 11,
      name: r'updatePlayerColorAutomatically',
      type: IsarType.bool,
    ),
    r'visualisationStyle': PropertySchema(
      id: 12,
      name: r'visualisationStyle',
      type: IsarType.byte,
      enumMap: _PlayerSettingsvisualisationStyleEnumValueMap,
    )
  },
  estimateSize: _playerSettingsEstimateSize,
  serialize: _playerSettingsSerialize,
  deserialize: _playerSettingsDeserialize,
  deserializeProp: _playerSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _playerSettingsGetId,
  getLinks: _playerSettingsGetLinks,
  attach: _playerSettingsAttach,
  version: '3.0.0',
);

int _playerSettingsEstimateSize(
  PlayerSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumIdsToRemove.length * 8;
  bytesCount += 3 + object.artistIdsToRemove.length * 8;
  bytesCount += 3 + object.currentTheme.length * 3;
  bytesCount += 3 + object.foldersToRemove.length * 3;
  {
    for (var i = 0; i < object.foldersToRemove.length; i++) {
      final value = object.foldersToRemove[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.playlist.length * 3;
  {
    for (var i = 0; i < object.playlist.length; i++) {
      final value = object.playlist[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.songIdsToRemove.length * 8;
  return bytesCount;
}

void _playerSettingsSerialize(
  PlayerSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.albumIdsToRemove);
  writer.writeLongList(offsets[1], object.artistIdsToRemove);
  writer.writeLong(offsets[2], object.currentSongIndex);
  writer.writeString(offsets[3], object.currentTheme);
  writer.writeStringList(offsets[4], object.foldersToRemove);
  writer.writeBool(offsets[5], object.isEqualizerOn);
  writer.writeBool(offsets[6], object.isShuffleOn);
  writer.writeBool(offsets[7], object.isSyncToCloudOn);
  writer.writeStringList(offsets[8], object.playlist);
  writer.writeLong(offsets[9], object.repeatState);
  writer.writeLongList(offsets[10], object.songIdsToRemove);
  writer.writeBool(offsets[11], object.updatePlayerColorAutomatically);
  writer.writeByte(offsets[12], object.visualisationStyle.index);
}

PlayerSettings _playerSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlayerSettings(
    albumIdsToRemove: reader.readLongList(offsets[0]) ?? [],
    artistIdsToRemove: reader.readLongList(offsets[1]) ?? [],
    currentSongIndex: reader.readLong(offsets[2]),
    currentTheme: reader.readString(offsets[3]),
    foldersToRemove: reader.readStringList(offsets[4]) ?? [],
    id: id,
    isEqualizerOn: reader.readBool(offsets[5]),
    isShuffleOn: reader.readBool(offsets[6]),
    isSyncToCloudOn: reader.readBool(offsets[7]),
    playlist: reader.readStringList(offsets[8]) ?? [],
    repeatState: reader.readLong(offsets[9]),
    songIdsToRemove: reader.readLongList(offsets[10]) ?? [],
    updatePlayerColorAutomatically: reader.readBool(offsets[11]),
    visualisationStyle: _PlayerSettingsvisualisationStyleValueEnumMap[
            reader.readByteOrNull(offsets[12])] ??
        VisualisationType.vinyl,
  );
  return object;
}

P _playerSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringList(offset) ?? []) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLongList(offset) ?? []) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (_PlayerSettingsvisualisationStyleValueEnumMap[
              reader.readByteOrNull(offset)] ??
          VisualisationType.vinyl) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PlayerSettingsvisualisationStyleEnumValueMap = {
  'vinyl': 0,
  'casette': 1,
  'gameboy': 2,
  'nokia': 3,
};
const _PlayerSettingsvisualisationStyleValueEnumMap = {
  0: VisualisationType.vinyl,
  1: VisualisationType.casette,
  2: VisualisationType.gameboy,
  3: VisualisationType.nokia,
};

Id _playerSettingsGetId(PlayerSettings object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _playerSettingsGetLinks(PlayerSettings object) {
  return [];
}

void _playerSettingsAttach(
    IsarCollection<dynamic> col, Id id, PlayerSettings object) {
  object.id = id;
}

extension PlayerSettingsQueryWhereSort
    on QueryBuilder<PlayerSettings, PlayerSettings, QWhere> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlayerSettingsQueryWhere
    on QueryBuilder<PlayerSettings, PlayerSettings, QWhereClause> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterWhereClause> idBetween(
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
}

extension PlayerSettingsQueryFilter
    on QueryBuilder<PlayerSettings, PlayerSettings, QFilterCondition> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumIdsToRemove',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'albumIdsToRemove',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'albumIdsToRemove',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'albumIdsToRemove',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIdsToRemove',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIdsToRemove',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIdsToRemove',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIdsToRemove',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIdsToRemove',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      albumIdsToRemoveLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIdsToRemove',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistIdsToRemove',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'artistIdsToRemove',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'artistIdsToRemove',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'artistIdsToRemove',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artistIdsToRemove',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artistIdsToRemove',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artistIdsToRemove',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artistIdsToRemove',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artistIdsToRemove',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      artistIdsToRemoveLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artistIdsToRemove',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentSongIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentSongIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentSongIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentSongIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentSongIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentSongIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentSongIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentSongIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentTheme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentTheme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTheme',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      currentThemeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentTheme',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foldersToRemove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foldersToRemove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foldersToRemove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foldersToRemove',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'foldersToRemove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'foldersToRemove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'foldersToRemove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'foldersToRemove',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foldersToRemove',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'foldersToRemove',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foldersToRemove',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foldersToRemove',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foldersToRemove',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foldersToRemove',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foldersToRemove',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      foldersToRemoveLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foldersToRemove',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
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

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      idLessThan(
    Id? value, {
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

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      isEqualizerOnEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEqualizerOn',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      isShuffleOnEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isShuffleOn',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      isSyncToCloudOnEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSyncToCloudOn',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playlist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playlist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playlist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playlist',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playlist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playlist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playlist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playlist',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playlist',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playlist',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playlist',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playlist',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playlist',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playlist',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playlist',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      playlistLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playlist',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      repeatStateEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatState',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      repeatStateGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeatState',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      repeatStateLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeatState',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      repeatStateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeatState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'songIdsToRemove',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'songIdsToRemove',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'songIdsToRemove',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'songIdsToRemove',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songIdsToRemove',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songIdsToRemove',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songIdsToRemove',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songIdsToRemove',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songIdsToRemove',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      songIdsToRemoveLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songIdsToRemove',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      updatePlayerColorAutomaticallyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatePlayerColorAutomatically',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      visualisationStyleEqualTo(VisualisationType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visualisationStyle',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      visualisationStyleGreaterThan(
    VisualisationType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'visualisationStyle',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      visualisationStyleLessThan(
    VisualisationType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'visualisationStyle',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterFilterCondition>
      visualisationStyleBetween(
    VisualisationType lower,
    VisualisationType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'visualisationStyle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlayerSettingsQueryObject
    on QueryBuilder<PlayerSettings, PlayerSettings, QFilterCondition> {}

extension PlayerSettingsQueryLinks
    on QueryBuilder<PlayerSettings, PlayerSettings, QFilterCondition> {}

extension PlayerSettingsQuerySortBy
    on QueryBuilder<PlayerSettings, PlayerSettings, QSortBy> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByCurrentSongIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSongIndex', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByCurrentSongIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSongIndex', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByCurrentTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTheme', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByCurrentThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTheme', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByIsEqualizerOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEqualizerOn', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByIsEqualizerOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEqualizerOn', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByIsShuffleOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShuffleOn', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByIsShuffleOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShuffleOn', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByIsSyncToCloudOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncToCloudOn', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByIsSyncToCloudOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncToCloudOn', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByRepeatState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatState', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByRepeatStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatState', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByUpdatePlayerColorAutomatically() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatePlayerColorAutomatically', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByUpdatePlayerColorAutomaticallyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatePlayerColorAutomatically', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByVisualisationStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualisationStyle', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      sortByVisualisationStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualisationStyle', Sort.desc);
    });
  }
}

extension PlayerSettingsQuerySortThenBy
    on QueryBuilder<PlayerSettings, PlayerSettings, QSortThenBy> {
  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByCurrentSongIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSongIndex', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByCurrentSongIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentSongIndex', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByCurrentTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTheme', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByCurrentThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTheme', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByIsEqualizerOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEqualizerOn', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByIsEqualizerOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEqualizerOn', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByIsShuffleOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShuffleOn', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByIsShuffleOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShuffleOn', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByIsSyncToCloudOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncToCloudOn', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByIsSyncToCloudOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncToCloudOn', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByRepeatState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatState', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByRepeatStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatState', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByUpdatePlayerColorAutomatically() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatePlayerColorAutomatically', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByUpdatePlayerColorAutomaticallyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatePlayerColorAutomatically', Sort.desc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByVisualisationStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualisationStyle', Sort.asc);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QAfterSortBy>
      thenByVisualisationStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualisationStyle', Sort.desc);
    });
  }
}

extension PlayerSettingsQueryWhereDistinct
    on QueryBuilder<PlayerSettings, PlayerSettings, QDistinct> {
  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByAlbumIdsToRemove() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumIdsToRemove');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByArtistIdsToRemove() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistIdsToRemove');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByCurrentSongIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentSongIndex');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByCurrentTheme({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentTheme', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByFoldersToRemove() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foldersToRemove');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByIsEqualizerOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEqualizerOn');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByIsShuffleOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isShuffleOn');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByIsSyncToCloudOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSyncToCloudOn');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct> distinctByPlaylist() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playlist');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByRepeatState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatState');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctBySongIdsToRemove() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'songIdsToRemove');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByUpdatePlayerColorAutomatically() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatePlayerColorAutomatically');
    });
  }

  QueryBuilder<PlayerSettings, PlayerSettings, QDistinct>
      distinctByVisualisationStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'visualisationStyle');
    });
  }
}

extension PlayerSettingsQueryProperty
    on QueryBuilder<PlayerSettings, PlayerSettings, QQueryProperty> {
  QueryBuilder<PlayerSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlayerSettings, List<int>, QQueryOperations>
      albumIdsToRemoveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumIdsToRemove');
    });
  }

  QueryBuilder<PlayerSettings, List<int>, QQueryOperations>
      artistIdsToRemoveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistIdsToRemove');
    });
  }

  QueryBuilder<PlayerSettings, int, QQueryOperations>
      currentSongIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentSongIndex');
    });
  }

  QueryBuilder<PlayerSettings, String, QQueryOperations>
      currentThemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentTheme');
    });
  }

  QueryBuilder<PlayerSettings, List<String>, QQueryOperations>
      foldersToRemoveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foldersToRemove');
    });
  }

  QueryBuilder<PlayerSettings, bool, QQueryOperations> isEqualizerOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEqualizerOn');
    });
  }

  QueryBuilder<PlayerSettings, bool, QQueryOperations> isShuffleOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isShuffleOn');
    });
  }

  QueryBuilder<PlayerSettings, bool, QQueryOperations>
      isSyncToCloudOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSyncToCloudOn');
    });
  }

  QueryBuilder<PlayerSettings, List<String>, QQueryOperations>
      playlistProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playlist');
    });
  }

  QueryBuilder<PlayerSettings, int, QQueryOperations> repeatStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatState');
    });
  }

  QueryBuilder<PlayerSettings, List<int>, QQueryOperations>
      songIdsToRemoveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'songIdsToRemove');
    });
  }

  QueryBuilder<PlayerSettings, bool, QQueryOperations>
      updatePlayerColorAutomaticallyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatePlayerColorAutomatically');
    });
  }

  QueryBuilder<PlayerSettings, VisualisationType, QQueryOperations>
      visualisationStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'visualisationStyle');
    });
  }
}
