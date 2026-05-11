import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';
import 'tambah_screen.dart';
import 'edit_screen.dart';

class MahasiswaScreen extends StatefulWidget {
  const MahasiswaScreen({super.key});

  @override
  State<MahasiswaScreen> createState() => _MahasiswaScreenState();
}

class _MahasiswaScreenState extends State<MahasiswaScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Mahasiswa>> futureMahasiswa;
  late AnimationController _fabController;
  late Animation<double> _fabScale;

  // ── Color palette ──────────────────────────────────────────────
  static const Color _navy      = Color(0xFF0D1B2A);
  static const Color _midnight  = Color(0xFF1B2A3B);
  static const Color _accent    = Color(0xFF00D4AA);   // teal-mint
  static const Color _accentAlt = Color(0xFF4ECDC4);
  static const Color _surface   = Color(0xFF1E2F42);
  static const Color _card      = Color(0xFF243447);
  static const Color _textPri   = Color(0xFFF0F4F8);
  static const Color _textSec   = Color(0xFF8FACC4);
  static const Color _danger    = Color(0xFFFF6B6B);

  @override
  void initState() {
    super.initState();
    futureMahasiswa = ApiService.getMahasiswa();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fabScale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    setState(() {
      futureMahasiswa = ApiService.getMahasiswa();
    });
  }

  // ── Avatar color per jurusan ────────────────────────────────────
  Color _avatarColor(String jurusan) {
    final colors = [
      const Color(0xFF00D4AA),
      const Color(0xFF4ECDC4),
      const Color(0xFF45B7D1),
      const Color(0xFF96CEB4),
      const Color(0xFFFFAD69),
      const Color(0xFFA29BFE),
    ];
    return colors[jurusan.length % colors.length];
  }

  // ── Initials from name ──────────────────────────────────────────
  String _initials(String nama) {
    final parts = nama.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nama.isNotEmpty ? nama[0].toUpperCase() : '?';
  }

  // ── Delete confirm dialog ───────────────────────────────────────
  Future<bool?> _showDeleteDialog(BuildContext ctx) {
    return showDialog<bool>(
      context: ctx,
      builder: (_) => Dialog(
        backgroundColor: _midnight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _danger.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: _danger, size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hapus Data',
                style: TextStyle(
                  color: _textPri,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Data mahasiswa ini akan dihapus\npermanen dan tidak bisa dipulihkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textSec,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: _textSec.withOpacity(0.3)),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: _textSec, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _danger,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Main build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,

      // ── App Bar ──────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Mahasiswa',
              style: TextStyle(
                color: _textPri,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Kelola data mahasiswa',
              style: TextStyle(
                color: _textSec,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          // Refresh button
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Material(
              color: _surface,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: refreshData,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.refresh_rounded,
                      color: _accentAlt, size: 20),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
              color: _surface, thickness: 1, height: 1),
        ),
      ),

      // ── Body ─────────────────────────────────────────────────
      body: FutureBuilder<List<Mahasiswa>>(
        future: futureMahasiswa,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: _accent,
                      backgroundColor: _surface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat data...',
                    style:
                        TextStyle(color: _textSec, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off_rounded,
                        color: _danger.withOpacity(0.7), size: 56),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat data',
                      style: TextStyle(
                        color: _textPri,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _textSec, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: refreshData,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: _navy,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.school_outlined,
                        color: _textSec, size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Belum ada data',
                    style: TextStyle(
                      color: _textPri,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tekan + untuk menambah\ndata mahasiswa baru.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: _textSec, fontSize: 13.5, height: 1.5),
                  ),
                ],
              ),
            );
          }

          final mahasiswa = snapshot.data!;

          // ── List ──────────────────────────────────────────────
          return RefreshIndicator(
            onRefresh: refreshData,
            color: _accent,
            backgroundColor: _midnight,
            child: CustomScrollView(
              slivers: [
                // Stats chip
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        _StatChip(
                          icon: Icons.people_alt_rounded,
                          label: '${mahasiswa.length} Mahasiswa',
                          color: _accent,
                        ),
                      ],
                    ),
                  ),
                ),

                // Cards
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 4, 16, 100),
                  sliver: SliverList.separated(
                    itemCount: mahasiswa.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final data = mahasiswa[index];
                      return _MahasiswaCard(
                        data: data,
                        initials: _initials(data.nama),
                        avatarColor: _avatarColor(data.jurusan),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditScreen(mahasiswa: data),
                            ),
                          );
                          if (result == true) refreshData();
                        },
                        onDelete: () async {
                          final confirm =
                              await _showDeleteDialog(context);
                          if (confirm == true) {
                            try {
                              await ApiService.deleteMahasiswa(
                                  data.id);
                              refreshData();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                            Icons.check_circle_rounded,
                                            color: _accent,
                                            size: 18),
                                        const SizedBox(width: 10),
                                        const Text(
                                            'Data berhasil dihapus'),
                                      ],
                                    ),
                                    backgroundColor: _midnight,
                                    behavior:
                                        SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: _danger,
                                    behavior:
                                        SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              }
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // ── FAB ──────────────────────────────────────────────────
      floatingActionButton: ScaleTransition(
        scale: _fabScale,
        child: FloatingActionButton.extended(
          onPressed: () async {
            _fabController.forward().then((_) => _fabController.reverse());
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const TambahScreen()),
            );
            if (result == true) refreshData();
          },
          backgroundColor: _accent,
          foregroundColor: _navy,
          elevation: 4,
          icon: const Icon(Icons.add_rounded, size: 22),
          label: const Text(
            'Tambah',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}

// ── Stat Chip ─────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mahasiswa Card ────────────────────────────────────────────────────────────
class _MahasiswaCard extends StatelessWidget {
  const _MahasiswaCard({
    required this.data,
    required this.initials,
    required this.avatarColor,
    required this.onTap,
    required this.onDelete,
  });

  final Mahasiswa data;
  final String initials;
  final Color avatarColor;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  static const Color _card    = Color(0xFF243447);
  static const Color _surface = Color(0xFF1E2F42);
  static const Color _textPri = Color(0xFFF0F4F8);
  static const Color _textSec = Color(0xFF8FACC4);
  static const Color _accent  = Color(0xFF00D4AA);
  static const Color _danger  = Color(0xFFFF6B6B);
  static const Color _navy    = Color(0xFF0D1B2A);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: _accent.withOpacity(0.08),
        highlightColor: _accent.withOpacity(0.04),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: avatarColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: avatarColor.withOpacity(0.35), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: avatarColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.nama,
                      style: const TextStyle(
                        color: _textPri,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.badge_outlined,
                            color: _textSec, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          data.nim,
                          style: const TextStyle(
                              color: _textSec, fontSize: 12.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data.jurusan,
                        style: const TextStyle(
                          color: _textSec,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Actions column
              Column(
                children: [
                  // ID badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#${data.id}',
                      style: const TextStyle(
                        color: _accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Delete
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: _danger.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: _danger, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}