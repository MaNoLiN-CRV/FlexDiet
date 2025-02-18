import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
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

  //final TextEditingController _weightController = TextEditingController(); <-- Remove these
  //final TextEditingController _heightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  //String? _goal; <-- REMOVE THIS
  //String? _gender; <-- REMOVE THIS

  int _currentPage = 0;
  String? _selectedGoal; // Add this
  String? _selectedGender; //Add this
  double? _selectedWeight;
  double? _selectedHeight;

  @override
  void dispose() {
    _pageController.dispose();
    //_weightController.dispose(); <-- Remove these
    //_heightController.dispose();
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
                        horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      children: [
                        WeightSelectionCard(
                          title: "Peso (kg)",
                          icon: Icons.balance,
                          selectedValue: _selectedWeight,
                          onChanged: (value) {
                            setState(() {
                              _selectedWeight = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        HeightSelectionCard(
                          title: "Altura (cm)",
                          icon: Icons.height,
                          selectedValue: _selectedHeight,
                          onChanged: (value) {
                            setState(() {
                              _selectedHeight = value;
                            });
                          },
                        ),
                      ],
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
                        horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      children: [
                        WeightSelectionCard(
                          title: "Peso Deseado (kg)",
                          icon: Icons.flag,
                          selectedValue: _targetWeightController.text.isNotEmpty
                              ? double.tryParse(_targetWeightController.text)
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _targetWeightController.text =
                                  value?.toString() ?? '';
                            });
                          },
                        ),
                      ],
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
                    if (_selectedWeight == null ||
                        _selectedHeight == null ||
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
