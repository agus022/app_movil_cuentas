import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key});

  @override
  State<CompletionScreen> createState() =>
      _CompletionScreenState();
}

class _CompletionScreenState
    extends State<CompletionScreen> {

  late ConfettiController controller;

  @override
  void initState() {
    super.initState();

    controller = ConfettiController(
      duration: const Duration(
        seconds: 3,
      ),
    );

    controller.play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xff0F172A),

      body: Stack(
        alignment: Alignment.center,
        children: [

          Align(
            alignment:
                Alignment.centerLeft,
            child: ConfettiWidget(
              confettiController:
                  controller,
              blastDirection: 0,
              emissionFrequency:
                  0.05,
              numberOfParticles:
                  20,
            ),
          ),

          Align(
            alignment:
                Alignment.centerRight,
            child: ConfettiWidget(
              confettiController:
                  controller,
              blastDirection:
                  3.14,
              emissionFrequency:
                  0.05,
              numberOfParticles:
                  20,
            ),
          ),

          Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 120,
              ),

              const SizedBox(
                height: 20,
              ),

              const Text(
                "Cuenta completada",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              const Text(
                "La deuda fue liquidada al 100%",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  "Continuar",
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}