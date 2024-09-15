import 'package:flutter_bloc/flutter_bloc.dart';

int level = 1;
int gridSize = level + 3;
List<int> tileValues = List.generate(gridSize * gridSize, (index) => 1);
double gridWidth = gridSize * 46 +
    (gridSize - 1) *
        16; //Ограничить общую ширину grid view на экране. 46 - размер плитки в пикселях, 16 - отступ в пикселях

class GridBloc extends Bloc<GridEvent, GridState> {
  GridBloc()
      : super(PlayState(
          level: level,
          gridSize: gridSize,
          tileValues: tileValues,
          gridWidth: gridWidth,
        )) {
    on<ChangeLVL>(
      ((event, emit) {
        if (level == 3) {
          level = 1;
        } else {
          level++;
        }
        gridSize = level + 3;
        tileValues = List.generate(gridSize * gridSize, (index) => 1);
        gridWidth = gridSize * 46 + (gridSize - 1) * 16;

        emit(PlayState(
          level: level,
          gridSize: gridSize,
          tileValues: tileValues,
          gridWidth: gridWidth,
        ));
      }),
    );

    on<TileTap>(
      ((event, emit) {
        if (tileValues[event.index] == 5) {
          tileValues[event.index] = 1;
        } else {
          tileValues[event.index]++;
        }

        emit((state as PlayState).copyWith(
          tileValues: tileValues,
        ));
      }),
    );

    on<RestartGame>(
      ((event, emit) {
        tileValues.fillRange(0, tileValues.length, 1);

        emit((state as PlayState).copyWith(
          tileValues: tileValues,
        ));
      }),
    );
  }
}

abstract class GridEvent {}

class ChangeLVL extends GridEvent {
  ChangeLVL();
}

class TileTap extends GridEvent {
  TileTap(this.index);
  final int index;
}

class RestartGame extends GridEvent {
  RestartGame();
}

abstract class GridState {
  final int level;
  final double gridWidth;
  final List<int> tileValues;
  final int gridSize;

  GridState(
      {required this.level,
      required this.gridWidth,
      required this.tileValues,
      required this.gridSize});
}

class PlayState extends GridState {
  PlayState({
    required super.level,
    required super.gridSize,
    required super.gridWidth,
    required super.tileValues,
  });

  PlayState copyWith({
    int? level,
    int? gridSize,
    double? gridWidth,
    List<int>? tileValues,
  }) {
    return PlayState(
      level: level ?? this.level,
      gridSize: gridSize ?? this.gridSize,
      gridWidth: gridWidth ?? this.gridWidth,
      tileValues: tileValues ?? this.tileValues,
    );
  }
}
