import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class UseTemplateScreen extends StatelessWidget {
  const UseTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height * 0.8; 

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        title: const Text('Usar Plantillas'),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox( 
                height: height,
                child: CardScroll(
                  cards: [
                    CardData(
                      title: 'PLANTILLA PARA MUJERES - PERDER PESO',
                      description:
                          'Dieta de 2000kcal para mujeres que desean perder peso de manera saludable. Incluye un perfil nutricional equilibrado y recetas enfocadas en tus objetivos.',
                      imageUrl:
                          'https://images.unsplash.com/photo-1607178743429-f34aa08f784d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjQwNzZ8MHwxfHNlYXJjaHwxfHxkaWV0JTIwd29tYW58ZW58MHx8fHwxNzA3NjY3NzYxfDA&ixlib=rb-4.0.3&q=80&w=200',
                    ),
                    CardData(
                      title: 'DIETA PARA GANAR MASA MUSCULAR',
                      description:
                          'Plan de comidas de 3500kcal optimizado para el crecimiento muscular. Rico en proteInas y carbohidratos complejos para apoyar tus entrenamientos y recuperacion muscular.',
                      imageUrl:
                          'https://images.unsplash.com/photo-1556771512-9804c2c7482f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjQwNzZ8MHwxfHNlYXJjaHw2fHxidWxrJTIwbXVzY2xlfGVufDB8fHx8MTcwNzY2NzgyOXww&ixlib=rb-4.0.3&q=80&w=200',
                    ),
                    CardData(
                      title: 'DIETA PARA DEPORTISTAS',
                      description:
                          'Dieta equilibrada de 2500kcal para deportistas que desean mantener un rendimiento optimo. Proporciona la energia y nutrientes necesarios para entrenamientos intensivos y competitivos.',
                      imageUrl:
                          'https://images.unsplash.com/photo-1554999212-c68ed64f0a51?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjQwNzZ8MHwxfHNlYXJjaHwxfHNsYWxhZCUyMGF0aGxldGV8ZW58MHx8fHwxNzA3NjY3ODc3fDA&ixlib=rb-4.0.3&q=80&w=200',
                    ),
                  ],
                  scrollDirection: Axis.vertical,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

