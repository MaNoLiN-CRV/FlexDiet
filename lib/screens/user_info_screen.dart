import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/theme/app_theme_light.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _pageController = PageController(initialPage: 0);

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  //String? _goal; <-- REMOVE THIS
  //String? _gender; <-- REMOVE THIS

  int _currentPage = 0;
  String? _selectedGoal; // Add this
  String? _selectedGender; //Add this

  @override
  void dispose() {
    _pageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _setUserInfoCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('userInfoCompleted', true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: backgroundColorBlue,
        elevation: 0,
        title: const Text('Información Personal'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildWaveBackgrounds(theme),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildWaveBackgrounds(ThemeData theme) {
    return Stack(
      children: [
        Positioned.fill(
          top: 50,
          child: RepaintBoundary(
            child: WaveBackground(
              color: theme.colorScheme.primary,
              frequency: 0.5,
              phase: 1,
            ),
          ),
        ),
        Positioned.fill(
          top: 250,
          child: RepaintBoundary(
            child: WaveBackground(
              color: theme.colorScheme.secondary,
              frequency: 0.3,
              phase: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // Page 1: Weight and Height
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              CustomUserInfo(
                                labelText: 'Peso (kg)',
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              CustomUserInfo(
                                labelText: 'Altura (cm)',
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Page 2: Goal Selection
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      children: [
                        GoalSelectionCard(
                          title: "Perder Grasa",
                          subtitle:
                              "Maximiza la pérdida de grasa y conserva tu masa muscular",
                          icon: Icons.whatshot,
                          value: "perder",
                          selectedValue: _selectedGoal,
                          onChanged: (value) {
                            setState(() {
                              _selectedGoal = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        GoalSelectionCard(
                          title: "Mantener Peso",
                          subtitle:
                              "Conserva tu estado físico y mantente saludable",
                          icon: Icons.apple,
                          value: "mantener",
                          selectedValue: _selectedGoal,
                          onChanged: (value) {
                            setState(() {
                              _selectedGoal = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        GoalSelectionCard(
                          title: "Ganar Músculo",
                          subtitle:
                              "Incrementa tu masa muscular y vuélvete más fuerte",
                          icon: Icons.fitness_center,
                          value: "ganar",
                          selectedValue: _selectedGoal,
                          onChanged: (value) {
                            setState(() {
                              _selectedGoal = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  //Page 3: Gender selection
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      children: [
                        GenderSelectionCard(
                          title: "Hombre",
                          icon: Icons.man,
                          value: "hombre",
                          selectedValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        GenderSelectionCard(
                          title: "Mujer",
                          icon: Icons.woman,
                          value: "mujer",
                          selectedValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Page 4: Desired Weight
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomUserInfo(
                            labelText: 'Peso Deseado (opcional)',
                            controller: _targetWeightController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomPageIndicator(
              currentPage: _currentPage,
              pageCount: 4, // El número de páginas
              activeColor:
                  theme.colorScheme.secondary, // Color del indicador activo
              inactiveColor: Colors.grey[300]!, // Color del indicador inactivo
            ),
            if (_currentPage == 3)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: theme.elevatedButtonTheme.style,
                  onPressed: () async {
                    if (_weightController.text.isEmpty ||
                        _heightController.text.isEmpty ||
                        _selectedGoal == null || // USE _selectedGoal here
                        _selectedGender == null) {
                      ShowToast(
                          context, "Por favor, rellena la información anterior",
                          toastType: ToastType.warning);
                      return;
                    }

                    await _setUserInfoCompleted();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoadingScreen(
                                  targetScreen: HomeScreen(),
                                  loadingSeconds: 2,
                                )),
                      );
                    }
                  },
                  child: const Text('Terminar', style: TextStyle(fontSize: 18)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
