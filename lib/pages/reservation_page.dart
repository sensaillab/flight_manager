import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/strings.dart';
import '../viewmodels/reservation_model.dart';
import '../viewmodels/customer_model.dart';
import '../viewmodels/flight_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/list_tile_with_actions.dart';
import '../models/reservation.dart';
import '../constants/themes.dart';

class ReservationPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  const ReservationPage({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationModel()),
        ChangeNotifierProvider(create: (_) => CustomerModel()),
        ChangeNotifierProvider(create: (_) => FlightModel()),
      ],
      child: Consumer3<ReservationModel, CustomerModel, FlightModel>(
        builder: (ctx, resModel, custModel, flightModel, _) {
          Widget content;
          if (resModel.loading || custModel.loading || flightModel.loading) {
            content = const Center(child: CircularProgressIndicator());
          } else if (resModel.error != null) {
            content = Center(
              child: Text(
                resModel.error!,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            );
          } else if (resModel.reservations.isEmpty) {
            content = Center(
              child: Text(
                Strings.of(ctx, 'noReservations'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          } else {
            content = ListView.builder(
              itemCount: resModel.reservations.length,
              itemBuilder: (_, i) {
                final r = resModel.reservations[i];
                return FutureBuilder<String>(
                  future: Future.wait([
                    resModel.getCustomerName(r.customerId),
                    resModel.getFlightRoute(r.flightId),
                  ]).then((vals) => '${vals[0]} → ${vals[1]}'),
                  builder: (context, snapshot) {
                    final subtitle = snapshot.hasData ? snapshot.data! : 'Loading...';
                    return Card(
                      color: isDarkMode
                          ? AppThemes.darkBrown.withOpacity(0.85)
                          : Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTileWithActions(
                        title: r.name,
                        subtitle:
                        '$subtitle • ${DateFormat.yMd().format(DateTime.parse(r.date))}',
                        onEdit: () =>
                            _showForm(context, resModel, custModel, flightModel, r),
                        onDelete: () async {
                          final ok = await showConfirmationDialog(
                            ctx,
                            Strings.of(ctx, 'deleteReservationConfirm'),
                          );
                          if (ok) {
                            await resModel.delete(r);
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content:
                                Text(Strings.of(ctx, 'reservationDeleted')),
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
              },
            );
          }

          return BaseScaffold(
            title: Strings.of(ctx, 'reservationsTitle'),
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/reservation.png',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.4), // dark overlay
                ),
                content, // original content
              ],
            ),
            onFab: () =>
                _showForm(context, resModel, custModel, flightModel, null),
            helpAction: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    '${Strings.of(context, 'reservationsTitle')} Help',
                    style: TextStyle(
                      color: AppThemes.darkYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(Strings.of(context, 'reservationHelp')),
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
      BuildContext ctx,
      ReservationModel resModel,
      CustomerModel custModel,
      FlightModel flightModel,
      Reservation? r,
      ) async {
    // Always refresh the latest customers & flights before showing form
    await custModel.loadAll();
    await flightModel.loadAll();

    final isNew = r == null;
    final nameCtl = TextEditingController(text: isNew ? '' : r!.name);
    int? selectedCustomerId = isNew ? null : r!.customerId;
    int? selectedFlightId = isNew ? null : r!.flightId;
    DateTime date = isNew ? DateTime.now() : DateTime.parse(r!.date);
    final key = GlobalKey<FormState>();

    await showDialog(
      context: ctx,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        title: Text(
          isNew
              ? Strings.of(ctx, 'addReservation')
              : Strings.of(ctx, 'editReservation'),
          style: TextStyle(
            color: AppThemes.darkYellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                      labelText: Strings.of(ctx, 'customerId')),
                  value: selectedCustomerId,
                  items: custModel.customers
                      .map((c) => DropdownMenuItem<int>(
                    value: c.id,
                    child: Text('${c.firstName} ${c.lastName}'),
                  ))
                      .toList(),
                  onChanged: (val) => selectedCustomerId = val,
                  validator: (v) =>
                  v == null ? Strings.of(ctx, 'requiredField') : null,
                ),
                DropdownButtonFormField<int>(
                  decoration:
                  InputDecoration(labelText: Strings.of(ctx, 'flightId')),
                  value: selectedFlightId,
                  items: flightModel.flights
                      .map((f) => DropdownMenuItem<int>(
                    value: f.id,
                    child: Text(
                        '${f.departureCity} → ${f.destinationCity}'),
                  ))
                      .toList(),
                  onChanged: (val) => selectedFlightId = val,
                  validator: (v) =>
                  v == null ? Strings.of(ctx, 'requiredField') : null,
                ),
                TextFormField(
                  controller: nameCtl,
                  decoration: InputDecoration(
                      labelText: Strings.of(ctx, 'reservationName')),
                  validator: (v) =>
                  v!.isEmpty ? Strings.of(ctx, 'requiredField') : null,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${Strings.of(ctx, 'reservationDate')}: ${DateFormat.yMd().format(date)}',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today,
                          color: AppThemes.darkYellow),
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: ctx,
                          initialDate: date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          date = d;
                          (ctx as Element).markNeedsBuild();
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(Strings.of(ctx, 'cancel'),
                style: TextStyle(color: AppThemes.darkYellow)),
          ),
          TextButton(
            onPressed: () async {
              if (!key.currentState!.validate()) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text(Strings.of(ctx, 'fillAllFields')),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }
              final newRes = Reservation(
                isNew ? Reservation.ID++ : r!.id,
                nameCtl.text,
                selectedCustomerId!,
                selectedFlightId!,
                date.toIso8601String(),
              );
              await (isNew ? resModel.add(newRes) : resModel.update(newRes));
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(isNew
                      ? Strings.of(ctx, 'reservationAdded')
                      : Strings.of(ctx, 'reservationUpdated')),
                  backgroundColor: AppThemes.darkYellow,
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: Text(
              isNew
                  ? Strings.of(ctx, 'addReservation')
                  : Strings.of(ctx, 'editReservation'),
              style: TextStyle(color: AppThemes.darkYellow),
            ),
          ),
        ],
      ),
    );
  }
}
