import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/strings.dart';
import '../viewmodels/flight_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/list_tile_with_actions.dart';
import '../models/flight.dart';
import '../utils/encrypted_prefs_helper.dart';
import '../constants/themes.dart'; //

class FlightsListPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  const FlightsListPage({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlightModel(),
      child: Consumer<FlightModel>(
        builder: (ctx, model, _) {
          Widget content;
          if (model.loading) {
            content = const Center(child: CircularProgressIndicator());
          } else if (model.error != null) {
            content = Center(
              child: Text(
                model.error!,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            );
          } else if (model.flights.isEmpty) {
            content = const Center(
              child: Text(
                'No flights yet.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          } else {
            content = ListView.builder(
              itemCount: model.flights.length,
              itemBuilder: (_, i) {
                final f = model.flights[i];
                return Card(
                  color: isDarkMode ? AppThemes.darkBrown.withOpacity(0.8) : Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTileWithActions(
                    title: '${f.departureCity} → ${f.destinationCity}',
                    subtitle:
                    '${DateFormat.jm().format(DateTime.parse(f.departTime))} - ${DateFormat.jm().format(DateTime.parse(f.arriveTime))}',
                    onEdit: () => _showForm(context, model, f),
                    onDelete: () async {
                      final ok = await showConfirmationDialog(ctx, 'Delete this flight?');
                      if (ok) {
                        await model.delete(f);
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(
                            content: const Text('Flight deleted'),
                            backgroundColor: AppThemes.darkYellow,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }

          return BaseScaffold(
            title: 'Flights',
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/flight.png',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.4), // dark overlay
                ),
                content, // existing list/form content
              ],
            ),
            onFab: () => _showForm(context, model, null),
            helpAction: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    '${Strings.of(context, 'flightsTitle')} Help',
                    style: TextStyle(
                      color: AppThemes.darkYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(Strings.of(context, 'flightHelp')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        Strings.of(context, 'ok'),
                        style: TextStyle(color: AppThemes.darkYellow),
                      ),
                    )
                  ],
                ),
              );
            },
            toggleTheme: toggleTheme,
            isDarkMode: isDarkMode,
          );
        },
      ),
    );
  }

  Future<void> _showForm(BuildContext ctx, FlightModel model, Flight? f) async {
    final isNew = f == null;
    final prefs = EncryptedPrefsHelper();
    final depCtl = TextEditingController(text: isNew ? '' : f!.departureCity);
    final dstCtl = TextEditingController(text: isNew ? '' : f!.destinationCity);
    DateTime depTime = isNew ? DateTime.now() : DateTime.parse(f.departTime);
    DateTime arrTime = isNew
        ? DateTime.now().add(const Duration(hours: 2))
        : DateTime.parse(f.arriveTime);
    final key = GlobalKey<FormState>();

    await showDialog(
      context: ctx,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                isNew ? 'Add Flight' : 'Edit Flight',
                style: TextStyle(
                  color: AppThemes.darkYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isNew)
              IconButton(
                icon: Icon(Icons.copy, color: AppThemes.darkYellow),
                tooltip: 'Copy Last',
                onPressed: () async {
                  final lastData = await prefs.loadLast(
                    EncryptedPrefsHelper.lastFlightKey,
                    ['departureCity', 'destinationCity', 'departureTime', 'arrivalTime'],
                  );
                  depCtl.text = lastData['departureCity'] ?? '';
                  dstCtl.text = lastData['destinationCity'] ?? '';
                  if (lastData['departureTime'] != null) {
                    depTime = DateFormat.jm().parse(lastData['departureTime']!);
                  }
                  if (lastData['arrivalTime'] != null) {
                    arrTime = DateFormat.jm().parse(lastData['arrivalTime']!);
                  }
                  (ctx as Element).markNeedsBuild();
                },
              ),
          ],
        ),
        content: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: depCtl,
                decoration: const InputDecoration(labelText: 'Departure City'),
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(v)) {
                    return 'Only letters allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: dstCtl,
                decoration: const InputDecoration(labelText: 'Destination City'),
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(v)) {
                    return 'Only letters allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text('Departure Time: ${DateFormat.jm().format(depTime)}')),
                  IconButton(
                    icon: Icon(Icons.access_time, color: AppThemes.darkYellow),
                    onPressed: () async {
                      final t = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(depTime),
                      );
                      if (t != null) {
                        depTime = DateTime(depTime.year, depTime.month, depTime.day, t.hour, t.minute);
                        (ctx as Element).markNeedsBuild();
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Arrival Time: ${DateFormat.jm().format(arrTime)}')),
                  IconButton(
                    icon: Icon(Icons.access_time, color: AppThemes.darkYellow),
                    onPressed: () async {
                      final t = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(arrTime),
                      );
                      if (t != null) {
                        arrTime = DateTime(arrTime.year, arrTime.month, arrTime.day, t.hour, t.minute);
                        (ctx as Element).markNeedsBuild();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: AppThemes.darkYellow)),
          ),
          TextButton(
            onPressed: () async {
              if (!key.currentState!.validate()) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: const Text('Fill all fields correctly'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }
              final fNew = Flight(
                isNew ? Flight.ID++ : f!.id,
                depCtl.text,
                dstCtl.text,
                depTime.toIso8601String(),
                arrTime.toIso8601String(),
              );
              if (isNew) {
                await model.add(fNew);
                await prefs.saveLast(EncryptedPrefsHelper.lastFlightKey, {
                  'departureCity': depCtl.text,
                  'destinationCity': dstCtl.text,
                  'departureTime': DateFormat.jm().format(depTime),
                  'arrivalTime': DateFormat.jm().format(arrTime),
                });
              } else {
                await model.update(fNew);
              }
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(isNew ? 'Flight added' : 'Flight updated'),
                  backgroundColor: AppThemes.darkYellow,
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: Text(isNew ? 'Add Flight' : 'Edit Flight', style: TextStyle(color: AppThemes.darkYellow)),
          ),
        ],
      ),
    );
  }
}
