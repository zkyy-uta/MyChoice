import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';

/// MF-04 — add, complete, and save choices for comparison.
class Mf04PublicHomeCatalogScreen extends StatefulWidget {
  const Mf04PublicHomeCatalogScreen({super.key, this.isPremium = false});

  final bool isPremium;

  @override
  State<Mf04PublicHomeCatalogScreen> createState() =>
      _Mf04PublicHomeCatalogScreenState();
}

class _Mf04PublicHomeCatalogScreenState
    extends State<Mf04PublicHomeCatalogScreen> {
  static const _savedChoicesKey = 'mf04_saved_choices';
  static const _categories = <_CatalogCategory>[
    _CatalogCategory(
      'Technology',
      Icons.devices_rounded,
      'Laptop, phone, tablet',
      ['Laptop', 'Smartphone', 'Tablet', 'Monitor', 'PC'],
    ),
    _CatalogCategory(
      'Education',
      Icons.school_rounded,
      'University, course, major',
      ['University', 'Course', 'Major', 'Certification', 'Bootcamp'],
    ),
    _CatalogCategory(
      'Fashion',
      Icons.checkroom_rounded,
      'Clothing and accessories',
      ['Clothing', 'Shoes', 'Bags', 'Accessories'],
    ),
    _CatalogCategory(
      'Daily Life',
      Icons.shopping_bag_rounded,
      'Everyday choices',
      ['Food', 'Transportation', 'Household items', 'Subscriptions'],
    ),
  ];

  static const _detailFields = ['Informasi utama', 'Harga', 'Catatan'];
  List<_Choice> _savedChoices = [];
  bool _isLoading = true;

  int get _maxChoices => widget.isPremium ? 10 : 3;

  @override
  void initState() {
    super.initState();
    _loadSavedChoices();
  }

  Future<void> _loadSavedChoices() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedJson = preferences.getString(_savedChoicesKey);
      final decoded = savedJson == null
          ? <dynamic>[]
          : jsonDecode(savedJson) as List<dynamic>;
      if (!mounted) return;
      setState(() {
        _savedChoices = decoded
            .map((item) => _Choice.fromJson(item as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage('Pilihan tersimpan gagal dimuat: $error');
    }
  }

  Future<void> _saveChoices(List<_Choice> choices) async {
    final category = choices.first.category;
    final mergedChoices = [
      ..._savedChoices.where((choice) => choice.category != category),
      ...choices,
    ];
    if (mergedChoices.length > _maxChoices) {
      _showMessage(
        '${widget.isPremium ? 'Premium' : 'Basic'} maksimal $_maxChoices pilihan.',
      );
      return;
    }
    final incompleteChoices = mergedChoices.where(
      (choice) => !choice.isComplete,
    );
    if (incompleteChoices.isNotEmpty) {
      _showMessage(
        'Lengkapi atau tandai data yang tidak tersedia pada setiap pilihan.',
      );
      return;
    }

    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(
        _savedChoicesKey,
        jsonEncode(mergedChoices.map((choice) => choice.toJson()).toList()),
      );
      if (!saved) {
        throw StateError('Penyimpanan lokal tidak berhasil.');
      }
      if (!mounted) return;
      setState(() => _savedChoices = mergedChoices);
      _showMessage(
        '${mergedChoices.length} pilihan disimpan untuk dianalisis.',
      );
    } catch (error) {
      if (!mounted) return;
      _showMessage('Pilihan gagal disimpan: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openCategory(_CatalogCategory category) async {
    final otherChoiceCount = _savedChoices
        .where((choice) => choice.category != category.name)
        .length;
    final selected = await showModalBottomSheet<List<_Choice>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _ChoiceSelectionSheet(
        category: category,
        maxChoices: _maxChoices,
        otherChoiceCount: otherChoiceCount,
        isPremium: widget.isPremium,
        detailFields: _detailFields,
        initialChoices: _savedChoices
            .where((choice) => choice.category == category.name)
            .toList(),
      ),
    );
    if (selected != null && mounted) {
      await _saveChoices(selected);
    }
  }

  Future<void> _editSavedChoice(_Choice choice) async {
    final updated = await _showChoiceDetailsDialog(
      context,
      choice,
      _detailFields,
    );
    if (updated == null) return;
    final updatedChoices = _savedChoices
        .map((saved) => saved.id == choice.id ? updated : saved)
        .toList();
    await _persistSavedChoices(updatedChoices);
  }

  Future<void> _removeSavedChoice(_Choice choice) async {
    final updatedChoices = _savedChoices
        .where((saved) => saved.id != choice.id)
        .toList();
    await _persistSavedChoices(updatedChoices);
  }

  Future<void> _persistSavedChoices(List<_Choice> choices) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(
        _savedChoicesKey,
        jsonEncode(choices.map((choice) => choice.toJson()).toList()),
      );
      if (!saved) {
        throw StateError('Penyimpanan lokal tidak berhasil.');
      }
      if (mounted) setState(() => _savedChoices = choices);
    } catch (error) {
      if (mounted) _showMessage('Perubahan pilihan gagal disimpan: $error');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.surfaceLight,
    appBar: AppBar(
      title: const Text('MyChoice'),
      backgroundColor: Colors.transparent,
    ),
    body: Container(
      decoration: const BoxDecoration(
        gradient: AppColors.softGradientBackground,
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppColors.backgroundGradient,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Make a better choice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pilih alternatif dari katalog atau tambahkan pilihan sendiri.',
                  style: TextStyle(color: Colors.white, height: 1.4),
                ),
                const SizedBox(height: 12),
                Text(
                  '${widget.isPremium ? 'Premium' : 'Basic'} · '
                  'maksimal $_maxChoices pilihan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pilih kategori',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPurple,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tambahkan pilihan yang ingin dibandingkan.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          ..._categories.map(
            (category) => Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: AppColors.border),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary20,
                  child: Icon(category.icon, color: AppColors.primaryDark),
                ),
                title: Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(category.description),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _openCategory(category),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pilihan tersimpan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPurple,
                    ),
                  ),
                ),
                Text('${_savedChoices.length}/$_maxChoices'),
              ],
            ),
            const SizedBox(height: 8),
            if (_savedChoices.isEmpty)
              const Text(
                'Pilihan yang disimpan untuk dianalisis akan muncul di sini.',
                style: TextStyle(color: AppColors.textSecondary),
              )
            else
              ..._savedChoices.map(
                (choice) => Card(
                  color: Colors.white,
                  elevation: 0,
                  child: ListTile(
                    title: Text(choice.name),
                    subtitle: Text(
                      '${choice.category} · ${choice.completionLabel}',
                    ),
                    trailing: Wrap(
                      spacing: 0,
                      children: [
                        IconButton(
                          tooltip: 'Lengkapi data',
                          onPressed: () => _editSavedChoice(choice),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Hapus pilihan',
                          onPressed: () => _removeSavedChoice(choice),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: const Icon(Icons.login_rounded),
            label: const Text('Log in'),
          ),
        ],
      ),
    ),
  );
}

class _ChoiceSelectionSheet extends StatefulWidget {
  const _ChoiceSelectionSheet({
    required this.category,
    required this.maxChoices,
    required this.otherChoiceCount,
    required this.isPremium,
    required this.detailFields,
    required this.initialChoices,
  });

  final _CatalogCategory category;
  final int maxChoices;
  final int otherChoiceCount;
  final bool isPremium;
  final List<String> detailFields;
  final List<_Choice> initialChoices;

  @override
  State<_ChoiceSelectionSheet> createState() => _ChoiceSelectionSheetState();
}

class _ChoiceSelectionSheetState extends State<_ChoiceSelectionSheet> {
  late final List<_Choice> _choices = List.of(widget.initialChoices);

  Future<void> _showLimitNotice() => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary20,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Batas pilihan tercapai',
              style: TextStyle(
                color: AppColors.textPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        widget.isPremium
            ? 'Paket Premium maksimal ${widget.maxChoices} opsi.'
            : 'Paket Basic maksimal ${widget.maxChoices} opsi. '
                  'Upgrade ke Premium untuk memilih hingga 10 opsi.',
        style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Tutup'),
        ),
        if (!widget.isPremium)
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGradient,
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushNamed('/profile/premium-plan');
            },
            child: const Text('Lihat Premium'),
          ),
      ],
    ),
  );

  void _addChoice(_Choice choice) {
    if (widget.otherChoiceCount + _choices.length >= widget.maxChoices) {
      _showLimitNotice();
      return;
    }
    if (_choices.any(
      (item) => item.name.toLowerCase() == choice.name.toLowerCase(),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilihan tersebut sudah ditambahkan.')),
      );
      return;
    }
    setState(() => _choices.add(choice));
  }

  void _toggleCatalogChoice(String name) {
    final existingIndex = _choices.indexWhere(
      (choice) =>
          choice.name.toLowerCase() == name.toLowerCase() &&
          choice.category == widget.category.name,
    );
    if (existingIndex != -1) {
      setState(() => _choices.removeAt(existingIndex));
      return;
    }
    _addChoice(
      _Choice(
        id: '${widget.category.name}-$name',
        name: name,
        category: widget.category.name,
        details: const {},
        unavailableFields: const {},
      ),
    );
  }

  Future<void> _addManualChoice() async {
    final choice = await _showManualChoiceDialog(
      context,
      widget.category.name,
      widget.detailFields,
    );
    if (choice != null) _addChoice(choice);
  }

  Future<void> _editChoice(_Choice choice) async {
    final updated = await _showChoiceDetailsDialog(
      context,
      choice,
      widget.detailFields,
    );
    if (updated == null) return;
    setState(() {
      final index = _choices.indexWhere((item) => item.id == choice.id);
      if (index != -1) _choices[index] = updated;
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        8,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.category.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(widget.category.description),
          const SizedBox(height: 20),
          Text(
            'Pilihan dibandingkan '
            '(${widget.otherChoiceCount + _choices.length}/${widget.maxChoices})',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...widget.category.options.map((option) {
            final isSelected = _choices.any(
              (item) =>
                  item.category == widget.category.name &&
                  item.name.toLowerCase() == option.toLowerCase(),
            );
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(option),
              value: isSelected,
              onChanged: (_) => _toggleCatalogChoice(option),
            );
          }),
          OutlinedButton.icon(
            onPressed: _addManualChoice,
            icon: const Icon(Icons.add),
            label: const Text('Tambah pilihan manual'),
          ),
          if (_choices.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Lengkapi informasi pilihan atau tandai yang tidak tersedia:',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            ..._choices.map(
              (choice) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(choice.name),
                subtitle: Text(choice.completionLabel),
                trailing: Wrap(
                  spacing: 0,
                  children: [
                    IconButton(
                      tooltip: 'Lengkapi informasi',
                      onPressed: () => _editChoice(choice),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      tooltip: 'Hapus pilihan',
                      onPressed: () => setState(() => _choices.remove(choice)),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _choices.isEmpty
                  ? null
                  : () {
                      if (_choices.length > widget.maxChoices) {
                        _showLimitNotice();
                        return;
                      }
                      if (_choices.any((choice) => !choice.isComplete)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Lengkapi atau tandai data yang tidak tersedia '
                              'pada setiap pilihan.',
                            ),
                          ),
                        );
                        return;
                      }
                      Navigator.pop(context, List<_Choice>.of(_choices));
                    },
              child: const Text('Simpan pilihan'),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<_Choice?> _showManualChoiceDialog(
  BuildContext context,
  String category,
  List<String> detailFields,
) async {
  final nameController = TextEditingController();
  final informationController = TextEditingController();
  try {
    return await showDialog<_Choice>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tambah pilihan manual'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nama pilihan'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: informationController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Informasi yang kamu ketahui (opsional)',
                  hintText: 'Tuliskan hanya informasi yang kamu berikan',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Informasi kosong dapat dilengkapi atau ditandai tidak tersedia '
                'setelah pilihan ditambahkan.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(
                dialogContext,
                _Choice(
                  id: '$category-${DateTime.now().microsecondsSinceEpoch}',
                  name: name,
                  category: category,
                  details: {
                    if (informationController.text.trim().isNotEmpty)
                      detailFields.first: informationController.text.trim(),
                  },
                  unavailableFields: const {},
                ),
              );
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  } finally {
    nameController.dispose();
    informationController.dispose();
  }
}

Future<_Choice?> _showChoiceDetailsDialog(
  BuildContext context,
  _Choice choice,
  List<String> detailFields,
) async {
  final controllers = {
    for (final field in detailFields)
      field: TextEditingController(text: choice.details[field] ?? ''),
  };
  final unavailableFields = Set<String>.of(choice.unavailableFields);
  try {
    return await showDialog<_Choice>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Informasi: ${choice.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: detailFields.map((field) {
                final unavailable = unavailableFields.contains(field);
                return Column(
                  children: [
                    TextField(
                      controller: controllers[field],
                      enabled: !unavailable,
                      decoration: InputDecoration(
                        labelText: field,
                        hintText: 'Isi data atau tandai tidak tersedia',
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Tandai tidak tersedia'),
                      value: unavailable,
                      onChanged: (checked) => setDialogState(() {
                        if (checked ?? false) {
                          unavailableFields.add(field);
                          controllers[field]!.clear();
                        } else {
                          unavailableFields.remove(field);
                        }
                      }),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final details = {
                  for (final field in detailFields)
                    if (controllers[field]!.text.trim().isNotEmpty &&
                        !unavailableFields.contains(field))
                      field: controllers[field]!.text.trim(),
                };
                Navigator.pop(
                  dialogContext,
                  choice.copyWith(
                    details: details,
                    unavailableFields: unavailableFields,
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  } finally {
    for (final controller in controllers.values) {
      controller.dispose();
    }
  }
}

class _CatalogCategory {
  const _CatalogCategory(this.name, this.icon, this.description, this.options);

  final String name;
  final IconData icon;
  final String description;
  final List<String> options;
}

class _Choice {
  const _Choice({
    required this.id,
    required this.name,
    required this.category,
    required this.details,
    required this.unavailableFields,
  });

  final String id;
  final String name;
  final String category;
  final Map<String, String> details;
  final Set<String> unavailableFields;

  bool get isComplete => details.keys
      .toSet()
      .union(unavailableFields)
      .containsAll(const {'Informasi utama', 'Harga', 'Catatan'});

  String get completionLabel {
    final completedCount = details.keys
        .toSet()
        .union(unavailableFields)
        .where(const {'Informasi utama', 'Harga', 'Catatan'}.contains)
        .length;
    return isComplete ? 'Data lengkap' : '$completedCount/3 data terisi';
  }

  _Choice copyWith({
    Map<String, String>? details,
    Set<String>? unavailableFields,
  }) => _Choice(
    id: id,
    name: name,
    category: category,
    details: details ?? this.details,
    unavailableFields: unavailableFields ?? this.unavailableFields,
  );

  Map<String, Object> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'details': details,
    'unavailableFields': unavailableFields.toList(),
  };

  factory _Choice.fromJson(Map<String, dynamic> json) => _Choice(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    details: (json['details'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, value as String),
    ),
    unavailableFields: Set<String>.from(
      json['unavailableFields'] as List<dynamic>,
    ),
  );
}
