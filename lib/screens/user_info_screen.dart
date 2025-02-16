import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/theme/app_theme.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _pageController = PageController(initialPage: 0);

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String? _goal;
  double? _targetWeight;

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: backgroundColorBlue, // AppBar transparente
        elevation: 0, // Elimina la sombra del AppBar
        title: const Text('Información Personal'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildWaveBackgrounds(theme),
          _buildMainContent(theme),
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

  Widget _buildMainContent(ThemeData theme) {
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
                  _buildWeightHeightCard(context, theme),
                  _buildGoalCard(context, theme),
                  _buildTargetWeightCard(context, theme),
                ],
              ),
            ),
            _buildPageIndicator(),
            if (_currentPage == 2)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: theme.elevatedButtonTheme.style,
                  onPressed: () {
                    // Validar la página actual antes de terminar
                    if (_formKey3.currentState != null &&
                        !_formKey3.currentState!.validate()) {
                      ShowToast(context, "Por favor, completa la información",
                          toastType: ToastType.warning);
                      return;
                    }

                    // Validación para asegurar que los campos obligatorios estén completos.
                    if (_weightController.text.isEmpty ||
                        _heightController.text.isEmpty ||
                        _goal == null) {
                      ShowToast(
                          context, "Por favor, rellena la información anterior",
                          toastType: ToastType.warning);
                      return;
                    }

                    // Ahora que has validado que _weightController.text y _heightController.text no están vacíos,
                    // puedes parsearlos de forma segura.
                    final weight = double.parse(_weightController.text);
                    final height = double.parse(_heightController.text);

                    print(
                        'Peso: $weight, Altura: $height, Objetivo: $_goal, Peso Deseado: $_targetWeight');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text('Terminar', style: TextStyle(fontSize: 18)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
          3,
          (int index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 8,
            width: _currentPage == index ? 16 : 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentPage == index
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey[300]!,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightHeightCard(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Peso (kg)',
                      border: const UnderlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce tu peso.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Introduce un número válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Altura (cm)',
                      border: const UnderlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce tu altura.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Introduce un número válido.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Objetivo',
                      border: const UnderlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    value: _goal,
                    items: const [
                      DropdownMenuItem(
                          value: 'perder', child: Text('Perder peso')),
                      DropdownMenuItem(
                          value: 'mantener', child: Text('Mantener peso')),
                      DropdownMenuItem(
                          value: 'ganar', child: Text('Ganar peso')),
                      DropdownMenuItem(
                          value: 'tonificar', child: Text('Tonificar')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _goal = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Selecciona un objetivo' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTargetWeightCard(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Peso Deseado (opcional)',
                      border: const UnderlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _targetWeight = double.tryParse(value);
                      });
                    },
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          double.tryParse(value) == null) {
                        return "Por favor, introduce un número válido";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
