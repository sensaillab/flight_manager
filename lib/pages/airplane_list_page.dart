import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/strings.dart';
import '../viewmodels/airplane_model.dart';
import '../models/airplane.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/list_tile_with_actions.dart';
import '../utils/encrypted_prefs_helper.dart';
import '../constants/themes.dart';

class AirplaneListPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  const AirplaneListPage({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AirplaneModel(),
      child: Consumer<AirplaneModel>(
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
          } else if (model.airplanes.isEmpty) {
            content = const Center(
              child: Text(
                'No airplanes yet.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          } else {
            content = ListView.builder(
              itemCount: model.airplanes.length,
              itemBuilder: (_, i) {
                final a = model.airplanes[i];
                return Card(
                  color: isDarkMode
                      ? AppThemes.darkBrown.withOpacity(0.85)
                      : Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTileWithActions(
                    title: a.type,
                    subtitle:
                    'Passengers: ${a.passengers} • Speed: ${a.maxSpeed} km/h • Range: ${a.range} km',
                    onEdit: () => _showForm(context, model, a),
                    onDelete: () async {
                      final ok = await showConfirmationDialog(
                          ctx, 'Delete this airplane?');
                      if (ok) {
                        await model.delete(a);
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(
                            content: const Text('Airplane deleted'),
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
            title: 'Airplanes',
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/airplanes.png', // your airplane background image
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.4), // overlay for contrast
                ),
                content,
              ],
            ),
            onFab: () => _showForm(context, model, null),
            helpAction: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    '${Strings.of(context, 'airplanesTitle')} Help',
                    style: TextStyle(
                      color: AppThemes.darkYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(Strings.of(context, 'airplaneHelp')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        Strings.of(context, 'ok'),
                        style: TextStyle(color: AppThemes.darkYellow),
                      ),
                    ),
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

  Future<void> _showForm(
      BuildContext ctx, AirplaneModel model, Airplane? a) async {
    final isNew = a == null;
    final prefs = EncryptedPrefsHelper();
    final typeCtl = TextEditingController(text: isNew ? '' : a!.type);
    final passCtl =
    TextEditingController(text: isNew ? '' : a!.passengers.toString());
    final speedCtl =
    TextEditingController(text: isNew ? '' : a!.maxSpeed.toString());
    final rangeCtl =
    TextEditingController(text: isNew ? '' : a!.range.toString());
    final key = GlobalKey<FormState>();

    await showDialog(
      context: ctx,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                isNew ? 'Add Airplane' : 'Edit Airplane',
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
                    'last_airplane',
                    ['type', 'passengers', 'maxSpeed', 'range'],
                  );
                  typeCtl.text = lastData['type'] ?? '';
                  passCtl.text = lastData['passengers'] ?? '';
                  speedCtl.text = lastData['maxSpeed'] ?? '';
                  rangeCtl.text = lastData['range'] ?? '';
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
                controller: typeCtl,
                decoration: const InputDecoration(labelText: 'Airplane Type'),
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(v)) {
                    return 'Only letters allowed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passCtl,
                decoration: const InputDecoration(labelText: 'Passenger Capacity'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              TextFormField(
                controller: speedCtl,
                decoration: const InputDecoration(labelText: 'Max Speed (km/h)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              TextFormField(
                controller: rangeCtl,
                decoration: const InputDecoration(labelText: 'Range (km)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
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
                  const SnackBar(content: Text('Fill all fields correctly')),
                );
                return;
              }
              final newAirplane = Airplane(
                isNew ? Airplane.ID++ : a!.id,
                typeCtl.text,
                int.parse(passCtl.text),
                double.parse(speedCtl.text),
                double.parse(rangeCtl.text),
              );
              if (isNew) {
                await model.add(newAirplane);
                await prefs.saveLast('last_airplane', {
                  'type': typeCtl.text,
                  'passengers': passCtl.text,
                  'maxSpeed': speedCtl.text,
                  'range': rangeCtl.text,
                });
              } else {
                await model.update(newAirplane);
              }
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(
                      isNew ? 'Airplane added' : 'Airplane updated'),
                  backgroundColor: AppThemes.darkYellow,
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: Text(
              isNew ? 'Add Airplane' : 'Edit Airplane',
              style: TextStyle(color: AppThemes.darkYellow),
            ),
          ),
        ],
      ),
    );
  }
}
