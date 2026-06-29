import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../../router/app_router.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../providers/social_providers.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Form keys for validation
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();

  // Text controllers
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _slugController = TextEditingController();
  final _descController = TextEditingController();

  bool _isPrivate = false;

  @override
  void initState() {
    super.initState();
    // Auto-generate slug from name as user types
    _nameController.addListener(() {
      final slug = _nameController.text
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-zA-Z0-9\s-]'), '')
          .replaceAll(RegExp(r'\s+'), '-')
          .replaceAll(RegExp(r'-+'), '-');
      _slugController.text = slug;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _titleController.dispose();
    _slugController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_step1Key.currentState?.validate() ?? false) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentStep == 1) {
      if (_step2Key.currentState?.validate() ?? false) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submit() async {
    if (!(_step3Key.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final title = _titleController.text.trim();
      final description = _descController.text.trim().isEmpty ? null : _descController.text.trim();

      // We call the repository to create the community.
      // Note: Backend endpoint also creates slug. We pass slug if needed or backend derives it from name.
      // Since our new endpoint supports name, title, description, isPrivate, it generates slug internally.
      // But we also validate uniqueness.
      final repo = ref.read(socialRepositoryProvider);
      final community = await repo.createCommunity(
        name: name,
        title: title,
        description: description,
        isPrivate: _isPrivate,
      );

      // Refresh communities provider
      ref.invalidate(communitiesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'تم إنشاء مجتمع ${community.title} بنجاح!'
                  : 'Community ${community.title} created successfully!',
            ),
            backgroundColor: context.colors.success,
          ),
        );

        // Close wizard & open the new community
        Navigator.of(context).pop();
        context.pushRoute(CommunityRoute(communitySlug: community.slug));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('AppException:', '').trim()),
            backgroundColor: context.colors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(isAr ? 'إنشاء مجتمع جديد' : 'Create a Community'),
        elevation: 0,
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildStepIndicator(isAr, colors),
            const SizedBox(height: 24),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (step) {
                  setState(() => _currentStep = step);
                },
                children: [
                  _buildStep1(isAr, colors),
                  _buildStep2(isAr, colors),
                  _buildStep3(isAr, colors),
                ],
              ),
            ),
            _buildBottomBar(isAr, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(bool isAr, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildStepCircle(0, isAr ? '١' : '1', isAr ? 'الاسم' : 'Name', colors),
          _buildStepDivider(0, colors),
          _buildStepCircle(1, isAr ? '٢' : '2', isAr ? 'الرابط والخصوصية' : 'Slug & Privacy', colors),
          _buildStepDivider(1, colors),
          _buildStepCircle(2, isAr ? '٣' : '3', isAr ? 'الوصف' : 'Description', colors),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index, String number, String label, AppColors colors) {
    final isActive = _currentStep == index;
    final isCompleted = _currentStep > index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? colors.success
                : isActive
                    ? colors.primary
                    : colors.surfaceVariant,
            border: Border.all(
              color: isActive ? colors.primaryLight : colors.border,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    number,
                    style: TextStyle(
                      color: isActive || isCompleted ? Colors.white : colors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isActive ? colors.textPrimary : colors.textMuted,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(int index, AppColors colors) {
    final isCompleted = _currentStep > index;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 2,
          color: isCompleted ? colors.success : colors.border,
        ),
      ),
    );
  }

  Widget _buildStep1(bool isAr, AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _step1Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'اختر اسماً وموضوعاً لمجتمعك' : 'Choose a Name and Title',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isAr
                  ? 'الاسم يجب أن يكون فريداً وبالأحرف الإنجليزية، وهو ما سيظهر في رابط المجتمع (مثل r/waslaq).'
                  : 'The name must be unique and alphanumeric, used in the community URL (e.g. r/waslaq).',
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: isAr ? 'اسم المجتمع (رابط)' : 'Community Name (URL identifier)',
                hintText: 'e.g. gaminghub',
                prefixText: 'r/',
                prefixStyle: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return isAr ? 'الاسم يجب أن لا يقل عن ٣ أحرف' : 'Name must be at least 3 characters';
                }
                if (value.trim().contains(' ')) {
                  return isAr ? 'الاسم لا يمكن أن يحتوي على فراغات' : 'Name cannot contain spaces';
                }
                if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(value)) {
                  return isAr
                      ? 'الاسم يمكن أن يحتوي على أحرف وأرقام وشرطات فقط'
                      : 'Name can only contain letters, numbers, hyphens, and underscores';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: isAr ? 'عنوان المجتمع المعروض' : 'Community Display Title',
                hintText: isAr ? 'مثل: عشاق الألعاب' : 'e.g. Gaming Hub',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return isAr ? 'العنوان يجب أن لا يقل عن ٣ أحرف' : 'Title must be at least 3 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(bool isAr, AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _step2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'الرابط والخصوصية' : 'Slug & Privacy Settings',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isAr
                  ? 'تحقق من الرابط الذي سيتم إنشاؤه، واختر ما إذا كان هذا المجتمع عاماً أم خاصاً.'
                  : 'Verify the generated slug and choose the privacy level of your community.',
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _slugController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: isAr ? 'الرابط المولد (Slug)' : 'Generated Slug',
                prefixText: 'waslaq.com/r/',
                prefixStyle: TextStyle(color: colors.textMuted),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: colors.surfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              isAr ? 'نوع المجتمع' : 'Community Type',
              style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => setState(() => _isPrivate = false),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: !_isPrivate ? colors.primary : colors.border,
                    width: !_isPrivate ? 2 : 1,
                  ),
                  color: !_isPrivate ? colors.primary.withValues(alpha: 0.05) : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Icon(Icons.public, color: !_isPrivate ? colors.primary : colors.textMuted, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'مجتمع عام' : 'Public Community',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr
                                ? 'يمكن لأي شخص رؤية المنشورات والنشر والتفاعل.'
                                : 'Anyone can view posts, submit new posts, and interact.',
                            style: TextStyle(color: colors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Radio<bool>(
                      value: false,
                      groupValue: _isPrivate,
                      onChanged: (val) {
                        if (val != null) setState(() => _isPrivate = val);
                      },
                      activeColor: colors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => setState(() => _isPrivate = true),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isPrivate ? colors.primary : colors.border,
                    width: _isPrivate ? 2 : 1,
                  ),
                  color: _isPrivate ? colors.primary.withValues(alpha: 0.05) : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: _isPrivate ? colors.primary : colors.textMuted, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'مجتمع خاص' : 'Private Community',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr
                                ? 'الأعضاء الموافق عليهم فقط يمكنهم رؤية المحتوى والمشاركة.'
                                : 'Only approved members can view the content and participate.',
                            style: TextStyle(color: colors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Radio<bool>(
                      value: true,
                      groupValue: _isPrivate,
                      onChanged: (val) {
                        if (val != null) setState(() => _isPrivate = val);
                      },
                      activeColor: colors.primary,
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

  Widget _buildStep3(bool isAr, AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _step3Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'أضف وصفاً لمجتمعك' : 'Add a Description',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isAr
                  ? 'صف للناس طبيعة هذا المجتمع وما يهدف إليه. هذا الحقل اختياري ولكن يوصى به بشدة.'
                  : 'Describe what your community is about. This is optional but highly recommended.',
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _descController,
              maxLines: 5,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: isAr ? 'الوصف' : 'Description',
                hintText: isAr ? 'أدخل وصفاً هنا...' : 'Enter community description...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isAr, AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          if (_currentStep > 0)
            OutlinedButton(
              onPressed: _isLoading ? null : _prevStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: colors.border),
              ),
              child: Text(
                isAr ? 'السابق' : 'Back',
                style: TextStyle(color: colors.textPrimary),
              ),
            )
          else
            const SizedBox.shrink(),

          // Forward / Submit Button
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: _currentStep > 0 ? (isAr ? 0 : 16) : 0,
                right: _currentStep > 0 ? (isAr ? 16 : 0) : 0,
              ),
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (_currentStep == 2 ? _submit : _nextStep),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        _currentStep == 2
                            ? (isAr ? 'إنشاء المجتمع' : 'Create Community')
                            : (isAr ? 'التالي' : 'Next'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
