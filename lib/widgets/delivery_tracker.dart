import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DeliveryTracker extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const DeliveryTracker({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _buildStepIcon(index),
                if (index < steps.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: index < currentStep
                        ? Colors.green
                        : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps[index],
                      style: TextStyle(
                        fontWeight: index <= currentStep
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: index <= currentStep
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    if (index == currentStep)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _getStatusMessage(index),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStepIcon(int index) {
    if (index < currentStep) {
      return Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          size: 18,
          color: Colors.white,
        ),
      );
    } else if (index == currentStep) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: const Icon(
          Icons.local_shipping,
          size: 18,
          color: Colors.white,
        ),
      );
    } else {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      );
    }
  }

  String _getStatusMessage(int index) {
    switch (index) {
      case 0:
        return 'Your order has been confirmed';
      case 1:
        return 'Chef is preparing your delicious meal';
      case 2:
        return 'Delivery partner is on the way';
      case 3:
        return 'Enjoy your meal!';
      default:
        return '';
    }
  }
}