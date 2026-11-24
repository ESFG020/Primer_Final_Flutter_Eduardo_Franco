import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// A widget that rebuilds every frame, for live-updating displays such as
/// elapsed time.
class TickerBuilder extends StatefulWidget {
  const TickerBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context) builder;

  @override
  State<TickerBuilder> createState() => _TickerBuilderState();
}

class _TickerBuilderState extends State<TickerBuilder>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_handleTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _handleTick(Duration elapsed) {
    setState(() {
      // Force a rebuild without changing the widget tree.
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
