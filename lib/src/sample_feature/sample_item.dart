/// A placeholder class that represents an entity or model.
class SampleItem {
  final int id;
  final String title;
  final int itemTypeId;
  final int folderId;
  final DateTime dateAdded;
  final DateTime dateModified;
  final int sourceImportance;

  const SampleItem({
    required this.id,
    required this.title,
    required this.itemTypeId,
    required this.folderId,
    required this.dateAdded,
    required this.dateModified,
    required this.sourceImportance,
  });

  factory SampleItem.fromJson(Map<String, dynamic> json) {
    return SampleItem(
      id: json['id'] as int,
      title: json['title'] as String,
      itemTypeId: json['itemTypeId'] as int,
      folderId: json['folderId'] as int,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(json['dateAdded']),
      dateModified: DateTime.fromMillisecondsSinceEpoch(json['dateModified']),
      sourceImportance: json['sourceImportance'] as int,
    );
  }
}
