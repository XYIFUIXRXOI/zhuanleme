import 'package:flutter/material.dart';

import '../models/wheel_data.dart';
import '../models/wheel_type.dart';
import '../services/wheel_config_controller.dart';
import '../theme/app_colors.dart';

class HomeConfigDrawer extends StatelessWidget {
  const HomeConfigDrawer({super.key, required this.controller});

  final WheelConfigController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.tune_rounded, color: AppColors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '\u8f6c\u76d8\u914d\u7f6e',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\u5728\u8fd9\u91cc\u7ef4\u62a4\u9996\u9875\u8f6c\u76d8\u5185\u5bb9\uff0c\u4fee\u6539\u540e\u76f4\u63a5\u751f\u6548\u3002',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  _ConfigSection(
                    data: controller.food,
                    onEdit: (int index) => _showEditDialog(
                      context,
                      type: WheelType.food,
                      index: index,
                      initialValue: controller.food.options[index].title,
                    ),
                    onAdd: () =>
                        _showCreateDialog(context, type: WheelType.food),
                    onDelete: (int index) => controller.removeOption(
                      type: WheelType.food,
                      index: index,
                    ),
                    onReset: () => controller.resetType(WheelType.food),
                  ),
                  const SizedBox(height: 14),
                  _ConfigSection(
                    data: controller.time,
                    onEdit: (int index) => _showEditDialog(
                      context,
                      type: WheelType.time,
                      index: index,
                      initialValue: controller.time.options[index].title,
                    ),
                    onAdd: () =>
                        _showCreateDialog(context, type: WheelType.time),
                    onDelete: (int index) => controller.removeOption(
                      type: WheelType.time,
                      index: index,
                    ),
                    onReset: () => controller.resetType(WheelType.time),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context, {
    required WheelType type,
    required int index,
    required String initialValue,
  }) async {
    final TextEditingController textController = TextEditingController(
      text: initialValue,
    );

    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceMuted,
          title: const Text('\u4fee\u6539\u9009\u9879'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '\u8f93\u5165\u65b0\u5185\u5bb9',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('\u53d6\u6d88'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(textController.text.trim()),
              child: const Text('\u4fdd\u5b58'),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) {
      return;
    }

    controller.updateOptionTitle(type: type, index: index, title: result);
  }

  Future<void> _showCreateDialog(
    BuildContext context, {
    required WheelType type,
  }) async {
    final TextEditingController textController = TextEditingController();

    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceMuted,
          title: const Text('\u65b0\u589e\u9009\u9879'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '\u8f93\u5165\u8981\u6dfb\u52a0\u7684\u5185\u5bb9',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('\u53d6\u6d88'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(textController.text.trim()),
              child: const Text('\u6dfb\u52a0'),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) {
      return;
    }

    controller.addOption(type: type, title: result);
  }
}

class _ConfigSection extends StatelessWidget {
  const _ConfigSection({
    required this.data,
    required this.onEdit,
    required this.onAdd,
    required this.onDelete,
    required this.onReset,
  });

  final WheelData data;
  final void Function(int index) onEdit;
  final VoidCallback onAdd;
  final void Function(int index) onDelete;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.white38.withValues(alpha: 0.18)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.white70,
          collapsedIconColor: AppColors.white70,
          title: Text(data.title),
          subtitle: Text(
            '${data.options.length} \u4e2a\u9009\u9879',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          children: <Widget>[
            for (int i = 0; i < data.options.length; i++)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBottom,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        data.options[i].title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () => onEdit(i),
                      icon: const Icon(Icons.edit_rounded, size: 20),
                    ),
                    IconButton(
                      onPressed: data.options.length <= 2
                          ? null
                          : () => onDelete(i),
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: _DrawerActionButton(
                    label: '\u6dfb\u52a0\u9009\u9879',
                    icon: Icons.add_rounded,
                    onTap: onAdd,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DrawerActionButton(
                    label: '\u6062\u590d\u9ed8\u8ba4',
                    icon: Icons.restart_alt_rounded,
                    onTap: onReset,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerActionButton extends StatelessWidget {
  const _DrawerActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: AppColors.backgroundBottom,
        child: InkWell(
          onTap: onTap,
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.white38.withValues(alpha: 0.18),
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 18, color: AppColors.white70),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    color: AppColors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
