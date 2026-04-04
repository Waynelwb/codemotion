// Graph Visualization Component
// 图可视化组件，用于展示最短路径等图算法
//
// 使用示例：
// ```dart
// GraphVisualization(
//   nodes: [...],
//   edges: [...],
//   highlightedNodes: {'A', 'B'},
//   highlightedEdges: [('A', 'B')],
//   distances: {'A': 0, 'B': 5},
// )
// ```

import 'package:flutter/material.dart';
import '../design_system.dart';

/// 图中的节点
class GraphNode {
  final String id;
  final String label;
  final double x; // 0.0 - 1.0 相对位置
  final double y;

  const GraphNode({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
  });
}

/// 图中的边
class GraphEdge {
  final String from;
  final String to;
  final double weight;
  final String? label;

  const GraphEdge({
    required this.from,
    required this.to,
    required this.weight,
    this.label,
  });
}

/// 图可视化组件
class GraphVisualization extends StatefulWidget {
  const GraphVisualization({
    super.key,
    required this.nodes,
    required this.edges,
    this.size = 300,
    this.nodeRadius = 24,
    this.highlightedNodes = const {},
    this.highlightedEdges = const {}, 
    this.visitedNodes = const {},
    this.currentNode = null,
    this.distances = const {},
    this.showDistances = true,
    this.highlightedEdgeColor,
  });

  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final double size;
  final double nodeRadius;
  final Set<String> highlightedNodes;
  final Set<String> highlightedEdges;
  final Set<String> visitedNodes;
  final String? currentNode;
  final Map<String, double> distances;
  final bool showDistances;
  final Color? highlightedEdgeColor;

  @override
  State<GraphVisualization> createState() => _GraphVisualizationState();
}

class _GraphVisualizationState extends State<GraphVisualization>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.borderMd,
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _GraphPainter(
            nodes: widget.nodes,
            edges: widget.edges,
            nodeRadius: widget.nodeRadius,
            highlightedNodes: widget.highlightedNodes,
            highlightedEdges: widget.highlightedEdges,
            visitedNodes: widget.visitedNodes,
            currentNode: widget.currentNode,
            distances: widget.distances,
            showDistances: widget.showDistances,
            highlightedEdgeColor:
                widget.highlightedEdgeColor ?? AppColors.primary,
            pulseAnimation: _pulseAnimation,
          ),
        ),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  _GraphPainter({
    required this.nodes,
    required this.edges,
    required this.nodeRadius,
    required this.highlightedNodes,
    required this.highlightedEdges,
    required this.visitedNodes,
    required this.currentNode,
    required this.distances,
    required this.showDistances,
    required this.highlightedEdgeColor,
    required this.pulseAnimation,
  });

  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final double nodeRadius;
  final Set<String> highlightedNodes;
  final Set<String> highlightedEdges;
  final Set<String> visitedNodes;
  final String? currentNode;
  final Map<String, double> distances;
  final bool showDistances;
  final Color highlightedEdgeColor;
  final Animation<double> pulseAnimation;

  Map<String, Offset> _nodePositions(Size size) {
    final padding = nodeRadius + 20;
    final effectiveSize = size.width - padding * 2;
    return {
      for (final node in nodes)
        node.id: Offset(
          padding + node.x * effectiveSize,
          padding + node.y * effectiveSize,
        ),
    };
  }

  @override
  void paint(Canvas canvas, Size size) {
    final positions = _nodePositions(size);

    // Draw edges
    for (final edge in edges) {
      final fromPos = positions[edge.from];
      final toPos = positions[edge.to];
      if (fromPos == null || toPos == null) continue;

      final edgeKey = '${edge.from}->${edge.to}';
      final isHighlighted = highlightedEdges.contains(edgeKey) ||
          highlightedEdges.contains('${edge.to}->${edge.from}');
      final isVisited =
          visitedNodes.contains(edge.from) && visitedNodes.contains(edge.to);

      final paint = Paint()
        ..color = isHighlighted
            ? highlightedEdgeColor
            : isVisited
                ? AppColors.textTertiary
                : AppColors.border
        ..strokeWidth = isHighlighted ? 3 : 2
        ..style = PaintingStyle.stroke;

      if (isHighlighted) {
        paint.shader = LinearGradient(
          colors: [
            highlightedEdgeColor.withValues(alpha: 0.8),
            highlightedEdgeColor,
          ],
        ).createShader(Rect.fromPoints(fromPos, toPos));
      }

      // Draw line
      canvas.drawLine(fromPos, toPos, paint);

      // Draw weight label
      if (edge.weight != 0) {
        final midPoint = Offset(
          (fromPos.dx + toPos.dx) / 2,
          (fromPos.dy + toPos.dy) / 2,
        );
        final textPainter = TextPainter(
          text: TextSpan(
            text: isHighlighted ? '➜${edge.weight.toInt()}' : '${edge.weight.toInt()}',
            style: TextStyle(
              color: isHighlighted ? highlightedEdgeColor : AppColors.textTertiary,
              fontSize: isHighlighted ? 12 : 10,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          midPoint - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }

    // Draw nodes
    for (final node in nodes) {
      final pos = positions[node.id]!;
      final isHighlighted = highlightedNodes.contains(node.id);
      final isVisited = visitedNodes.contains(node.id);
      final isCurrent = currentNode == node.id;
      final distance = distances[node.id];

      // Pulse effect for current node
      double radius = nodeRadius;
      if (isCurrent) {
        radius = nodeRadius * pulseAnimation.value;
      }

      // Node background
      final bgPaint = Paint()
        ..color = isCurrent
            ? AppColors.primary
            : isHighlighted
                ? AppColors.primary.withValues(alpha: 0.2)
                : isVisited
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.cardBackground;
      canvas.drawCircle(pos, radius, bgPaint);

      // Node border
      final borderPaint = Paint()
        ..color = isCurrent
            ? AppColors.primary
            : isHighlighted
                ? highlightedEdgeColor
                : isVisited
                    ? AppColors.success
                    : AppColors.border
        ..strokeWidth = isCurrent || isHighlighted ? 3 : 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(pos, radius, borderPaint);

      // Glow for current node
      if (isCurrent) {
        final glowPaint = Paint()
          ..color = AppColors.primary.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(pos, radius + 4, glowPaint);
      }

      // Node label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: node.label,
          style: TextStyle(
            color: isCurrent ? Colors.white : AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      labelPainter.paint(
        canvas,
        pos - Offset(labelPainter.width / 2, labelPainter.height / 2),
      );

      // Distance label
      if (showDistances && distance != null && distance != double.infinity) {
        final distPainter = TextPainter(
          text: TextSpan(
            text: 'd=${distance.toInt()}',
            style: TextStyle(
              color: isCurrent ? Colors.white70 : AppColors.textTertiary,
              fontSize: 9,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        distPainter.paint(
          canvas,
          pos + Offset(-distPainter.width / 2, radius + 4),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) {
    return oldDelegate.highlightedNodes != highlightedNodes ||
        oldDelegate.highlightedEdges != highlightedEdges ||
        oldDelegate.visitedNodes != visitedNodes ||
        oldDelegate.currentNode != currentNode ||
        oldDelegate.distances != distances ||
        oldDelegate.pulseAnimation.value != pulseAnimation.value;
  }
}

/// 带控制面板的图可视化完整组件
class GraphVisualizationPanel extends StatefulWidget {
  const GraphVisualizationPanel({
    super.key,
    required this.title,
    required this.description,
    this.nodes = const [],
    this.edges = const [],
    this.initialDistances = const {},
    this.initialHighlighted = const {},
  });

  final String title;
  final String description;
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final Map<String, double> initialDistances;
  final Set<String> initialHighlighted;

  @override
  State<GraphVisualizationPanel> createState() =>
      _GraphVisualizationPanelState();
}

class _GraphVisualizationPanelState extends State<GraphVisualizationPanel> {
  late Set<String> _highlightedNodes;
  late Set<String> _highlightedEdges;
  late Set<String> _visitedNodes;
  String? _currentNode;
  late Map<String, double> _distances;
  int _stepIndex = 0;
  List<_GraphStep> _steps = [];

  @override
  void initState() {
    super.initState();
    _highlightedNodes = Set.from(widget.initialHighlighted);
    _highlightedEdges = {};
    _visitedNodes = {};
    _currentNode = null;
    _distances = Map.from(widget.initialDistances);
    _generateSteps();
  }

  void _generateSteps() {
    // Generate steps based on edges (Dijkstra-like visualization)
    _steps = [];
    final edgeList = widget.edges.toList();

    for (var i = 0; i < edgeList.length && i < 5; i++) {
      final edge = edgeList[i];
      _steps.add(_GraphStep(
        description: '检查边 ${edge.from} → ${edge.to}',
        highlightNode: edge.to,
        highlightEdge: '${edge.from}->${edge.to}',
        visitedNodes: {..._visitedNodes, edge.from},
        distanceUpdate: edge.to,
        newDistance: (widget.initialDistances[edge.from] ?? 0) + edge.weight,
      ));
    }
  }

  void _nextStep() {
    if (_stepIndex >= _steps.length) return;
    final step = _steps[_stepIndex];
    setState(() {
      _currentNode = step.highlightNode;
      if (step.highlightNode != null) {
        _highlightedNodes = {..._highlightedNodes, step.highlightNode!};
      }
      if (step.highlightEdge != null) {
        _highlightedEdges = {..._highlightedEdges, step.highlightEdge!};
      }
      _visitedNodes = step.visitedNodes;
      if (step.distanceUpdate != null && step.newDistance != null) {
        _distances = Map.from(_distances);
        _distances[step.distanceUpdate!] = step.newDistance!;
      }
      _stepIndex++;
    });
  }

  void _reset() {
    setState(() {
      _highlightedNodes = Set.from(widget.initialHighlighted);
      _highlightedEdges = {};
      _visitedNodes = {};
      _currentNode = null;
      _distances = Map.from(widget.initialDistances);
      _stepIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stepDescription =
        _stepIndex < _steps.length ? _steps[_stepIndex].description : '完成！';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.account_tree, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(widget.title, style: AppFonts.titleMedium()),
              const Spacer(),
              Text(
                '步骤 ${_stepIndex.clamp(0, _steps.length)} / ${_steps.length}',
                style: AppFonts.labelMedium(color: AppColors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.description,
            style: AppFonts.bodySmall(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),

          // Graph
          Center(
            child: GraphVisualization(
              nodes: widget.nodes,
              edges: widget.edges,
              size: 280,
              highlightedNodes: _highlightedNodes,
              highlightedEdges: _highlightedEdges,
              visitedNodes: _visitedNodes,
              currentNode: _currentNode,
              distances: _distances,
              showDistances: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Step description
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderXs,
            ),
            child: Text(
              stepDescription,
              style: AppFonts.labelMedium(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _GraphControlButton(
                icon: Icons.replay,
                label: '重置',
                onTap: _reset,
              ),
              const SizedBox(width: AppSpacing.sm),
              _GraphControlButton(
                icon: Icons.skip_next,
                label: '下一步',
                onTap: _stepIndex < _steps.length ? _nextStep : null,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GraphStep {
  final String description;
  final String? highlightNode;
  final String? highlightEdge;
  final Set<String> visitedNodes;
  final String? distanceUpdate;
  final double? newDistance;

  const _GraphStep({
    required this.description,
    this.highlightNode,
    this.highlightEdge,
    required this.visitedNodes,
    this.distanceUpdate,
    this.newDistance,
  });
}

class _GraphControlButton extends StatefulWidget {
  const _GraphControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  @override
  State<_GraphControlButton> createState() => _GraphControlButtonState();
}

class _GraphControlButtonState extends State<_GraphControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onTap != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered && isEnabled
                    ? AppColors.primary.withValues(alpha: 0.8)
                    : AppColors.primary)
                : (_isHovered && isEnabled
                    ? AppColors.border
                    : Colors.transparent),
            borderRadius: AppRadius.borderSm,
            border: Border.all(
              color: isEnabled ? AppColors.border : AppColors.textDisabled,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: isEnabled
                    ? (widget.isPrimary ? Colors.white : AppColors.textPrimary)
                    : AppColors.textDisabled,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                widget.label,
                style: AppFonts.labelMedium(
                  color: isEnabled
                      ? (widget.isPrimary ? Colors.white : AppColors.textPrimary)
                      : AppColors.textDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
