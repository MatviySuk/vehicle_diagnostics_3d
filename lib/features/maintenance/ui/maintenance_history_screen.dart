import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vehicle/domain/diagnostic_report.dart';
import '../../vehicle/logic/vehicle_providers.dart';

// ING: Maintenance history — Firebase diagnostic reports on top, mock service history below.
// PT: Histórico de manutenção — relatórios Firebase no topo, histórico simulado em baixo.
class MaintenanceHistoryScreen extends ConsumerStatefulWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  ConsumerState<MaintenanceHistoryScreen> createState() => _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends ConsumerState<MaintenanceHistoryScreen> {
  _FilterStatus _selectedFilter = _FilterStatus.all;

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(diagnosticReportsProvider);

    final filtered = _selectedFilter == _FilterStatus.all
        ? _mockRecords
        : _mockRecords.where((r) => r.status == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.pink.withAlpha(60), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.pinkAccent.withAlpha(40), Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(),
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.pink,
                    onRefresh: () => ref.refresh(diagnosticReportsProvider.future),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: [
                        // ── Firebase diagnostic reports section ──
                        _SectionHeader(
                          icon: Icons.cloud_download_outlined,
                          title: 'Diagnostic Reports',
                          subtitle: 'Live data from vehicle sensors',
                          color: Colors.pink,
                        ),
                        const SizedBox(height: 8),
                        reportsAsync.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator(color: Colors.pink, strokeWidth: 2)),
                          ),
                          error: (e, _) => _ErrorCard(message: e.toString()),
                          data: (reports) => reports.isEmpty
                              ? const _EmptyCard(message: 'No diagnostic reports found.')
                              : Column(
                                  children: reports
                                      .map((r) => _DiagnosticCard(report: r))
                                      .toList(),
                                ),
                        ),

                        const SizedBox(height: 20),

                        // ── Mock service history section ──
                        _SectionHeader(
                          icon: Icons.build_outlined,
                          title: 'Service History',
                          subtitle: 'Scheduled maintenance records',
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(height: 8),
                        _SummaryBanner(),
                        const SizedBox(height: 8),
                        _FilterRow(
                          selected: _selectedFilter,
                          onChanged: (f) => setState(() => _selectedFilter = f),
                        ),
                        const SizedBox(height: 8),
                        if (filtered.isEmpty)
                          const _EmptyCard(message: 'No records match this filter.')
                        else
                          ...filtered.map((r) => _RecordCard(record: r)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SectionHeader({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black45)),
          ],
        ),
      ],
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maintenance History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'Toyota Corolla — 2020',
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.pink.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pink.withAlpha(60)),
            ),
            child: Row(
              children: [
                const Icon(Icons.directions_car, size: 14, color: Colors.pink),
                const SizedBox(width: 4),
                Text(
                  'VIN: 1HGBH41',
                  style: TextStyle(fontSize: 11, color: Colors.pink[700], fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Diagnostic card (Firebase data) ─────────────────────────────────────────

class _DiagnosticCard extends StatelessWidget {
  final DiagnosticReport report;
  const _DiagnosticCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final severity = report.severity.toLowerCase();
    final severityColor = switch (severity) {
      'low' => Colors.green,
      'medium' => Colors.orange,
      'high' => Colors.red,
      'critical' => Colors.red[900]!,
      _ => Colors.grey,
    };
    final severityIcon = switch (severity) {
      'low' => Icons.check_circle_outline,
      'medium' => Icons.info_outline,
      'high' => Icons.warning_amber_outlined,
      'critical' => Icons.error_outline,
      _ => Icons.help_outline,
    };

    final componentLabel = report.componentId
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');

    final ts = report.timestamp;
    final dateStr = '${ts.day.toString().padLeft(2, '0')} '
        '${_monthName(ts.month)} ${ts.year}  '
        '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: severityColor.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: severityColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(severityIcon, color: severityColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        componentLabel,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: severityColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: severityColor.withAlpha(80)),
                      ),
                      child: Text(
                        severity[0].toUpperCase() + severity.substring(1),
                        style: TextStyle(fontSize: 11, color: severityColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(report.description, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.black38),
                    const SizedBox(width: 4),
                    Text(dateStr, style: const TextStyle(fontSize: 11, color: Colors.black38)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}

// ─── Error / empty states ─────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 12, color: Colors.red))),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Text(message, style: const TextStyle(color: Colors.black38, fontSize: 13))),
    );
  }
}

// ─── Summary banner ───────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Total Services', value: '${_mockRecords.length}', icon: Icons.build_circle_outlined, color: Colors.blue),
          _VerticalDivider(),
          _StatItem(
            label: 'Due / Overdue',
            value: '${_mockRecords.where((r) => r.status == _FilterStatus.dueSoon || r.status == _FilterStatus.overdue).length}',
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
          ),
          _VerticalDivider(),
          _StatItem(
            label: 'Total Spent',
            value: '€${_mockRecords.fold<int>(0, (s, r) => s + r.costEur)}',
            icon: Icons.euro_rounded,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.black12);
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black45)),
      ],
    );
  }
}

// ─── Filter row ───────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final _FilterStatus selected;
  final ValueChanged<_FilterStatus> onChanged;

  const _FilterRow({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _FilterStatus.values
            .map((f) => _FilterChip(status: f, selected: f == selected, onTap: () => onChanged(f)))
            .toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final _FilterStatus status;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.status, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      _FilterStatus.all => 'All',
      _FilterStatus.completed => 'Completed',
      _FilterStatus.dueSoon => 'Due Soon',
      _FilterStatus.overdue => 'Overdue',
    };
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? Colors.pink : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? Colors.pink : Colors.black26),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Service record card (mock data) ──────────────────────────────────────────

class _RecordCard extends StatefulWidget {
  final _MaintenanceRecord record;
  const _RecordCard({required this.record});

  @override
  State<_RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<_RecordCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.record;
    final statusColor = switch (r.status) {
      _FilterStatus.completed => Colors.green,
      _FilterStatus.dueSoon => Colors.orange,
      _FilterStatus.overdue => Colors.red,
      _FilterStatus.all => Colors.grey,
    };
    final statusLabel = switch (r.status) {
      _FilterStatus.completed => 'Completed',
      _FilterStatus.dueSoon => 'Due Soon',
      _FilterStatus.overdue => 'Overdue',
      _FilterStatus.all => '',
    };

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: r.iconColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(r.icon, color: r.iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.serviceType, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                        Text(r.serviceCenter, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withAlpha(80)),
                    ),
                    child: Text(statusLabel, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _InfoPill(icon: Icons.calendar_today_outlined, label: r.date, color: Colors.blue),
                  const SizedBox(width: 8),
                  _InfoPill(
                    icon: Icons.speed_outlined,
                    label: '${r.mileageKm.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} km',
                    color: Colors.purple,
                  ),
                  const SizedBox(width: 8),
                  _InfoPill(icon: Icons.euro_outlined, label: '${r.costEur}', color: Colors.green),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, color: Colors.black12),
                const SizedBox(height: 12),
                _DetailRow(label: 'Technician', value: r.technician),
                _DetailRow(label: 'Next Service', value: r.nextServiceDue),
                _DetailRow(label: 'Parts Replaced', value: r.partsReplaced),
                if (r.notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(r.notes, style: const TextStyle(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic)),
                  ),
                ],
              ],
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.black45))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

// ─── Domain model ─────────────────────────────────────────────────────────────

enum _FilterStatus { all, completed, dueSoon, overdue }

class _MaintenanceRecord {
  final String serviceType;
  final String date;
  final int mileageKm;
  final int costEur;
  final String serviceCenter;
  final String technician;
  final String nextServiceDue;
  final String partsReplaced;
  final String notes;
  final _FilterStatus status;
  final IconData icon;
  final Color iconColor;

  const _MaintenanceRecord({
    required this.serviceType,
    required this.date,
    required this.mileageKm,
    required this.costEur,
    required this.serviceCenter,
    required this.technician,
    required this.nextServiceDue,
    required this.partsReplaced,
    required this.notes,
    required this.status,
    required this.icon,
    required this.iconColor,
  });
}

// ─── Mock data ────────────────────────────────────────────────────────────────

const List<_MaintenanceRecord> _mockRecords = [
  _MaintenanceRecord(
    serviceType: 'Oil & Filter Change',
    date: '18 Apr 2025',
    mileageKm: 87500,
    costEur: 65,
    serviceCenter: 'Toyota Centro Porto',
    technician: 'Carlos Mota',
    nextServiceDue: '18 Oct 2025 or 97,500 km',
    partsReplaced: 'Engine oil (5W-30), oil filter',
    notes: 'Oil was dark brown. Recommended synthetic oil next service.',
    status: _FilterStatus.completed,
    icon: Icons.oil_barrel_outlined,
    iconColor: Colors.amber,
  ),
  _MaintenanceRecord(
    serviceType: 'Brake Pad Replacement',
    date: '02 Feb 2025',
    mileageKm: 84200,
    costEur: 180,
    serviceCenter: 'AutoFix Braga',
    technician: 'Rui Ferreira',
    nextServiceDue: '02 Feb 2027 or 114,200 km',
    partsReplaced: 'Front brake pads (x2), brake dust shields',
    notes: 'Rear pads still at 60% — monitor on next inspection.',
    status: _FilterStatus.completed,
    icon: Icons.album_outlined,
    iconColor: Colors.redAccent,
  ),
  _MaintenanceRecord(
    serviceType: 'Tyre Rotation',
    date: '18 Apr 2025',
    mileageKm: 87500,
    costEur: 30,
    serviceCenter: 'Toyota Centro Porto',
    technician: 'Carlos Mota',
    nextServiceDue: '18 Oct 2025 or 97,500 km',
    partsReplaced: 'None — rotation only',
    notes: 'Tread depth: FL 5mm, FR 4.8mm, RL 5.1mm, RR 5mm. All within range.',
    status: _FilterStatus.dueSoon,
    icon: Icons.tire_repair_outlined,
    iconColor: Colors.blueAccent,
  ),
  _MaintenanceRecord(
    serviceType: 'Air Filter Replacement',
    date: '15 Sep 2024',
    mileageKm: 79000,
    costEur: 35,
    serviceCenter: 'Midas Lisboa Norte',
    technician: 'Ana Lopes',
    nextServiceDue: '15 Sep 2025 or 94,000 km',
    partsReplaced: 'Engine air filter',
    notes: '',
    status: _FilterStatus.dueSoon,
    icon: Icons.air_outlined,
    iconColor: Colors.teal,
  ),
  _MaintenanceRecord(
    serviceType: 'Battery Check & Replacement',
    date: '10 Jan 2024',
    mileageKm: 71000,
    costEur: 120,
    serviceCenter: 'Bosch Car Service — Gaia',
    technician: 'João Alves',
    nextServiceDue: '10 Jan 2028',
    partsReplaced: 'Lead-acid battery 60Ah / 540A',
    notes: 'Cold-crank amps were dropping below threshold in winter. Replaced preventively.',
    status: _FilterStatus.completed,
    icon: Icons.battery_full_outlined,
    iconColor: Colors.green,
  ),
  _MaintenanceRecord(
    serviceType: 'Coolant Flush',
    date: '20 Jun 2023',
    mileageKm: 60000,
    costEur: 90,
    serviceCenter: 'Toyota Centro Porto',
    technician: 'Carlos Mota',
    nextServiceDue: '20 Jun 2025 — OVERDUE',
    partsReplaced: 'Coolant (Toyota Super Long Life Coolant)',
    notes: 'Flush interval is 2 years. Schedule at next available appointment.',
    status: _FilterStatus.overdue,
    icon: Icons.water_drop_outlined,
    iconColor: Colors.cyan,
  ),
  _MaintenanceRecord(
    serviceType: 'Spark Plug Replacement',
    date: '15 Sep 2024',
    mileageKm: 79000,
    costEur: 95,
    serviceCenter: 'Midas Lisboa Norte',
    technician: 'Ana Lopes',
    nextServiceDue: '15 Sep 2028 or 159,000 km',
    partsReplaced: 'Iridium spark plugs x4 (NGK ILZKAR8J8S)',
    notes: '',
    status: _FilterStatus.completed,
    icon: Icons.bolt_outlined,
    iconColor: Colors.deepPurple,
  ),
  _MaintenanceRecord(
    serviceType: 'Cabin Air Filter',
    date: '18 Apr 2025',
    mileageKm: 87500,
    costEur: 20,
    serviceCenter: 'Toyota Centro Porto',
    technician: 'Carlos Mota',
    nextServiceDue: '18 Apr 2026 or 97,500 km',
    partsReplaced: 'Cabin / pollen filter',
    notes: 'Filter was visibly dirty. Recommend replacing every year.',
    status: _FilterStatus.completed,
    icon: Icons.ac_unit_outlined,
    iconColor: Colors.lightBlue,
  ),
  _MaintenanceRecord(
    serviceType: 'Wheel Alignment & Balancing',
    date: '02 Feb 2025',
    mileageKm: 84200,
    costEur: 60,
    serviceCenter: 'AutoFix Braga',
    technician: 'Rui Ferreira',
    nextServiceDue: '02 Feb 2026 or 104,200 km',
    partsReplaced: 'None — alignment correction only',
    notes: 'Slight toe-out on rear axle corrected. Vibration at 110 km/h resolved.',
    status: _FilterStatus.completed,
    icon: Icons.settings_outlined,
    iconColor: Colors.indigo,
  ),
  _MaintenanceRecord(
    serviceType: 'Timing Belt Inspection',
    date: '10 Jan 2024',
    mileageKm: 71000,
    costEur: 40,
    serviceCenter: 'Bosch Car Service — Gaia',
    technician: 'João Alves',
    nextServiceDue: 'Replacement due at 100,000 km — OVERDUE',
    partsReplaced: 'None — inspection only',
    notes: 'Belt shows early signs of cracking. Replacement strongly recommended before 95,000 km.',
    status: _FilterStatus.overdue,
    icon: Icons.change_circle_outlined,
    iconColor: Colors.deepOrange,
  ),
];
