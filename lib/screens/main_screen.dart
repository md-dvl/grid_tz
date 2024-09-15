import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_tz/bloc/grid_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF7),
      body: BlocProvider(
        create: (context) => GridBloc(),
        child: BlocBuilder<GridBloc, GridState>(
          builder: (context, state) {
            return Column(
              children: [
                Image.asset('assets/images/area_up.png'),
                const Spacer(),
                SizedBox(
                  width: state.gridWidth,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: state.gridSize, //размер сетки
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.gridSize *
                        state.gridSize, //сетка всегда квадратная
                    itemBuilder: (context, index) {
                      int row = index ~/ state.gridSize;
                      int col = index % state.gridSize;

                      if (row == 0 && col == 0) {
                        return const SizedBox.shrink();
                      }

                      if (row == 0 || col == 0) {
                        return Image.asset('assets/images/mt.png');
                      }

                      return GestureDetector(
                          onTap: () {
                            BlocProvider.of<GridBloc>(context)
                                .add(TileTap(index));
                          },
                          child: Image.asset(
                              'assets/images/${state.tileValues[index]}.png'));
                    },
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 157,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                          image: AssetImage('assets/images/area_down.png'),
                          fit: BoxFit.cover),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 48,
                                child: Image.asset(
                                    'assets/images/timer${state.level}.png'), //меняется ассет таймера в зависимости от уровня
                              ),
                              GestureDetector(
                                onTap: () => BlocProvider.of<GridBloc>(context)
                                    .add(RestartGame()),
                                child: SizedBox(
                                  height: 48,
                                  child:
                                      Image.asset('assets/images/restart.png'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'LEVEL: ${state.level}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  BlocProvider.of<GridBloc>(context)
                                      .add(ChangeLVL());
                                },
                                child: const Icon(
                                  Icons.radio_button_checked,
                                  size: 32,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
