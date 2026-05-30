// lib/features/product/data/models/category_model.dart
// Field names match Medusa StoreProductCategory + storefront categories.ts usage:
//   fields: "*category_children, *parent_category, *parent_category.parent_category"

class CategoryModel {
  final String id;
  final String name;
  final String? nameAr;
  final String? handle;
  final String? description;
  final String? imageUrl;

  /// parent_category_id — from the flat field on the category object.
  /// Also readable from parent_category.id when expanded.
  final String? parentId;

  /// Nested children — populated when fields include *category_children
  final List<CategoryModel> children;

  const CategoryModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.handle,
    this.description,
    this.imageUrl,
    this.parentId,
    this.children = const [],
  });

  bool get isRoot => parentId == null;

  /// Returns the name in the given language code
  String localizedName(String lang) {
    if (lang == 'ar') return nameAr ?? name;
    return name;
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // parent_category_id is a flat field on the category object in Medusa v2.
    // When parent_category is expanded, also available as parent_category.id.
    // categories.ts uses: fields "*category_children, *parent_category"
    final parentCategoryObj = json['parent_category'] as Map<String, dynamic>?;
    final parentId =
        json['parent_category_id'] as String? ?? parentCategoryObj?['id'] as String?;

    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: (json['metadata'] as Map<String, dynamic>?)?['name_ar'] as String?,
      handle: json['handle'] as String?,
      description: json['description'] as String?,
      imageUrl: (json['metadata'] as Map<String, dynamic>?)?['image'] as String?,
      parentId: parentId,
      children: (json['category_children'] as List? ?? [])
          .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
