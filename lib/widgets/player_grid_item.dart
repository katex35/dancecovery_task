import 'package:flutter/material.dart';

class PlayerGridItem extends StatelessWidget {
  final String name;
  final bool isUnknown;
  final bool isSelected;
  final bool isSelf;
  final VoidCallback? onTap;

  const PlayerGridItem({
    super.key,
    required this.name,
    this.isUnknown = false,
    this.isSelected = false,
    this.isSelf = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            children: [
              // main container background
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: isUnknown
                      ? (isSelf
                            ? const Color(0xFF4F3479)
                            : Colors.white.withValues(alpha: 0.1))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),

              // content
              if (isUnknown)
                Center(
                  child: Image.asset(
                    'assets/unknown.png',
                    width: 110,
                    height: 110,
                  ),
                )
              else ...[
                // revealed state
                // avatar circle
                Positioned(
                  left: 30,
                  top: 18,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF00C853)
                          : (isSelf
                                ? const Color(0xFF4F3479)
                                : const Color(0xFF857998)),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        (name.isNotEmpty ? name[0].toUpperCase() : '?'),
                        style: const TextStyle(
                          fontFamily: 'Geist',
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // name pill
                Positioned(
                  left: 0,
                  top: 106,
                  child: Container(
                    width: 140,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF00C853)
                          : (isSelf
                                ? const Color(0xFF4F3479)
                                : const Color(0xFF857998)),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Geist',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
