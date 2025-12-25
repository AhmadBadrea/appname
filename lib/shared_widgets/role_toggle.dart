import 'package:appname/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RoleToggle extends StatelessWidget {
  final bool isTenant;
  final ValueChanged<bool> onChanged;

  const RoleToggle({
    super.key,
    required this.isTenant,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _item('Tenant', true),
          _item('Owner', false),
        ],
      ),
    );
  }

  Widget _item(String text, bool tenant) {
    final active = isTenant == tenant;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(tenant),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
