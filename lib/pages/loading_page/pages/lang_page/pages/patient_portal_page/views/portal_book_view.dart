import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';

class PortalBookView extends StatefulWidget {
  const PortalBookView({super.key});

  @override
  State<PortalBookView> createState() => _PortalBookViewState();
}

class _PortalBookViewState extends State<PortalBookView> {
  late final ScrollController _controller;
  int _step = 0;
  //TODO: handle portal query accordingly

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stepper(
            elevation: 6,
            controlsBuilder: (context, details) {
              return const SizedBox();
            },
            controller: _controller,
            type: context.isMobile
                ? StepperType.vertical
                : StepperType.horizontal,
            currentStep: _step,
            onStepTapped: (value) {
              setState(() {
                _step = value;
              });
            },
            steps: [
              Step(
                isActive: _step == 0,
                title: Text('First Time Or Booked Before'),
                content: Card.outlined(
                  elevation: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      ElevatedButton.icon(
                        label: Text('First Time'),
                        icon: const Icon(Icons.person_add),
                        onPressed: () {
                          //TODO
                          setState(() {
                            _step = 1;
                          });
                        },
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          //TODO
                          setState(() {
                            _step = 1;
                          });
                        },
                        icon: const Icon(Icons.person_2),
                        label: Text('Booked Before'),
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                isActive: _step == 1,
                title: Text('Enter Details'),
                content: Card.outlined(
                  elevation: 6,
                  child: Text('data entry and patient info save step'),
                ),
              ),
              Step(
                isActive: _step == 2,
                title: Text('Select Clinic'),
                content: Card.outlined(
                  elevation: 6,
                  child: Text('clinic selection step'),
                ),
              ),
              Step(
                isActive: _step == 3,

                title: Text('Select Date'),
                content: Card.outlined(
                  elevation: 6,
                  child: Text('date selection step'),
                ),
              ),
              Step(
                isActive: _step == 4,

                title: Text('Confirm Booking Details'),
                content: Card.outlined(
                  elevation: 6,
                  child: Text('booking confirmation step'),
                ),
              ),
              Step(
                isActive: _step == 5,

                title: Text('Thank You'),
                content: Card.outlined(
                  elevation: 6,
                  child: Text('thank you step'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
