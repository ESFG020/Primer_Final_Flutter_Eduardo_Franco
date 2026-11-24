import 'package:material_ui/material_ui.dart';

/// Shown once the player has selected the correct word for every slot.
class PuzzleCompletedWidget extends StatelessWidget {
  const PuzzleCompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Puzzle Completed!',
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      ),
    );
  }
}
