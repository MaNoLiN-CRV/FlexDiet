import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/admin/use_template_screen.dart';
import 'package:flutter_flexdiet/screens/home_screen.dart';
import 'package:flutter_flexdiet/widgets/custom_button.dart';
import 'package:flutter_flexdiet/widgets/custom_card_scroll.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  String? _selectedClientName;
  final List<CardData> _clientCards = [
    CardData(
      title: 'Snoop Dogg',
      description: 'Client with gaining weight routine, 30 years old',
      imageUrl: 'https://allhiphop.com/wp-content/uploads/2022/11/Snoop-Dogg.jpg',
    ),
    CardData(
      title: 'Eminem',
      description: 'Atheletic, 40 years old and a bodybuilder',
      imageUrl: 'https://cdn.britannica.com/63/136263-050-7FBFFBD1/Eminem.jpg',
    ),
    CardData(
      title: 'Ice Cube',
      description: 'Loose weight routine, 50 years old',
      imageUrl: 'https://heavy.com/wp-content/uploads/2017/02/gettyimages-615695594.jpg?quality=65&strip=all',
    ),
    CardData(
      title: 'Juice WRLD',
      description: 'Cicling routine, 20 years old',
      imageUrl: 'https://www.thefamouspeople.com/profiles/images/juice-wrld-1.jpg',
    ),
  ];

  void _selectClient(String clientName) {
    setState(() {
      _selectedClientName = clientName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('ADMIN PANEL'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        elevation: 2,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _selectedClientName != null
                  ? 'Selected Client: $_selectedClientName'
                  : 'Select a Client',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: _selectedClientName != null ? FontStyle.normal : FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: CardScroll(
                scrollDirection: Axis.horizontal,
                cards: _clientCards,
                onCardTap: (index) {
                  _selectClient(_clientCards.elementAt(index).title.toString());
                  // TODO: CLIENT SELECTION LOGIC HERE
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.onSecondary,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 3,
              ),
              child: Text(
                'CREAR PLANTILLA',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSecondary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UseTemplateScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 3,
              ),
              child: Text(
                'USAR PLANTILLA',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
