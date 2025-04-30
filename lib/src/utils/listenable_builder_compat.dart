import 'package:flutter/material.dart';

/// Compatibilité pour ListenableBuilder qui n'existe que dans Flutter 3.x
/// Cette classe fournit la même fonctionnalité pour Flutter 2.x
class ListenableBuilder extends StatefulWidget {
  /// Le listenable à observer
  final Listenable listenable;

  /// Le constructeur de widget
  final Widget Function(BuildContext context, Widget? child) builder;

  /// Widget enfant optionnel qui ne sera pas reconstruit
  final Widget? child;

  /// Constructeur
  const ListenableBuilder({
    super.key,
    required this.listenable,
    required this.builder,
    this.child,
  });

  @override
  State<ListenableBuilder> createState() => _ListenableBuilderState();
}

class _ListenableBuilderState extends State<ListenableBuilder> {
  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(ListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(_handleChange);
      widget.listenable.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    setState(() {
      // La valeur a changé, donc reconstruisons
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }
}
