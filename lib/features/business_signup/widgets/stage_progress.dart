import "package:flutter/material.dart";

class StageProgress extends StatelessWidget {
  const StageProgress({
    super.key,
    required this.currentStage,
    required this.stages,
  });

  final int currentStage;
  final List<String> stages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress bars
        Row(
          children: List.generate(stages.length, (index) {
            final isCompleted = index < currentStage;
            final isCurrent = index == currentStage;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? const Color(0xFF4A90D9)
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < stages.length - 1) const SizedBox(width: 4),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // Stage labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(stages.length, (index) {
            final isCurrent = index == currentStage;
            return Expanded(
              child: Text(
                stages[index],
                style: TextStyle(
                  fontSize: 11,
                  color: isCurrent
                      ? const Color(0xFF4A90D9)
                      : Colors.white.withOpacity(0.4),
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
        ),
      ],
    );
  }
}
