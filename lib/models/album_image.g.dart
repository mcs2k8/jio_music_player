// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_image.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetAlbumImageCollection on Isar {
  IsarCollection<AlbumImage> get albumImages => this.collection();
}

const AlbumImageSchema = CollectionSchema(
  name: r'AlbumImage',
  id: 6118964688056151708,
  properties: {
    r'imageUrl': PropertySchema(
      id: 0,
      name: r'imageUrl',
      type: IsarType.string,
    )
  },
  estimateSize: _albumImageEstimateSize,
  serialize: _albumImageSerialize,
  deserialize: _albumImageDeserialize,
  deserializeProp: _albumImageDeserializeProp,
  idName: r'albumId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _albumImageGetId,
  getLinks: _albumImageGetLinks,
  attach: _albumImageAttach,
  version: '3.0.0',
);

int _albumImageEstimateSize(
  AlbumImage object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.imageUrl.length * 3;
  return bytesCount;
}

void _albumImageSerialize(
  AlbumImage object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.imageUrl);
}

AlbumImage _albumImageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlbumImage(
    albumId: id,
    imageUrl: reader.readString(offsets[0]),
  );
  return object;
}

P _albumImageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _albumImageGetId(AlbumImage object) {
  return object.albumId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _albumImageGetLinks(AlbumImage object) {
  return [];
}

void _albumImageAttach(IsarCollection<dynamic> col, Id id, AlbumImage object) {
  object.albumId = id;
}

extension AlbumImageQueryWhereSort
    on QueryBuilder<AlbumImage, AlbumImage, QWhere> {
  QueryBuilder<AlbumImage, AlbumImage, QAfterWhere> anyAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AlbumImageQueryWhere
    on QueryBuilder<AlbumImage, AlbumImage, QWhereClause> {
  QueryBuilder<AlbumImage, AlbumImage, QAfterWhereClause> albumIdEqualTo(
      Id albumId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: albumId,
        upper: albumId,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterWhereClause> albumIdNotEqualTo(
      Id albumId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: albumId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: albumId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: albumId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: albumId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterWhereClause> albumIdGreaterThan(
      Id albumId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: albumId, includeLower: include),
      );
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterWhereClause> albumIdLessThan(
      Id albumId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: albumId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterWhereClause> albumIdBetween(
    Id lowerAlbumId,
    Id upperAlbumId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerAlbumId,
        includeLower: includeLower,
        upper: upperAlbumId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AlbumImageQueryFilter
    on QueryBuilder<AlbumImage, AlbumImage, QFilterCondition> {
  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> albumIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'albumId',
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition>
      albumIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'albumId',
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> albumIdEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumId',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition>
      albumIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'albumId',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> albumIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'albumId',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> albumIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'albumId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> imageUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition>
      imageUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> imageUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> imageUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition>
      imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> imageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition>
      imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterFilterCondition>
      imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }
}

extension AlbumImageQueryObject
    on QueryBuilder<AlbumImage, AlbumImage, QFilterCondition> {}

extension AlbumImageQueryLinks
    on QueryBuilder<AlbumImage, AlbumImage, QFilterCondition> {}

extension AlbumImageQuerySortBy
    on QueryBuilder<AlbumImage, AlbumImage, QSortBy> {
  QueryBuilder<AlbumImage, AlbumImage, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterSortBy> sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }
}

extension AlbumImageQuerySortThenBy
    on QueryBuilder<AlbumImage, AlbumImage, QSortThenBy> {
  QueryBuilder<AlbumImage, AlbumImage, QAfterSortBy> thenByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterSortBy> thenByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<AlbumImage, AlbumImage, QAfterSortBy> thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }
}

extension AlbumImageQueryWhereDistinct
    on QueryBuilder<AlbumImage, AlbumImage, QDistinct> {
  QueryBuilder<AlbumImage, AlbumImage, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }
}

extension AlbumImageQueryProperty
    on QueryBuilder<AlbumImage, AlbumImage, QQueryProperty> {
  QueryBuilder<AlbumImage, int, QQueryOperations> albumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumId');
    });
  }

  QueryBuilder<AlbumImage, String, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }
}
