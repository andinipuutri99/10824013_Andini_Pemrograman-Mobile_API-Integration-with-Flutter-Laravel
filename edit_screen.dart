import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';

class EditScreen extends StatefulWidget {
  final Mahasiswa mahasiswa;

  const EditScreen({
    super.key,
    required this.mahasiswa,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController namaController;
  late TextEditingController nimController;
  late TextEditingController jurusanController;

  bool isLoading = false;

  // ── Palette (same as MahasiswaScreen) ──────────────────────────
  static const Color _navy     = Color(0xFF0D1B2A);
  static const Color _midnight = Color(0xFF1B2A3B);
  static const Color _accent   = Color(0xFF00D4AA);
  static const Color _surface  = Color(0xFF1E2F42);
  static const Color _card     = Color(0xFF243447);
  static const Color _textPri  = Color(0xFFF0F4F8);
  static const Color _textSec  = Color(0xFF8FACC4);
  static const Color _danger   = Color(0xFFFF6B6B);
  static const Color _warning  = Color(0xFFFFAD69);

  @override
  void initState() {
    super.initState();
    namaController    = TextEditingController(text: widget.mahasiswa.nama);
    nimController     = TextEditingController(text: widget.mahasiswa.nim);
    jurusanController = TextEditingController(text: widget.mahasiswa.jurusan);
  }

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    jurusanController.dispose();
    super.dispose();
  }

  // ── Initials helper ─────────────────────────────────────────────
  String get _initials {
    final parts = widget.mahasiswa.nama.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
  }

  Future<void> updateData() async {
    if (namaController.text.trim().isEmpty ||
        nimController.text.trim().isEmpty ||
        jurusanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: _warning, size: 18),
              const SizedBox(width: 10),
              const Text('Semua field harus diisi'),
            ],
          ),
          backgroundColor: _midnight,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.updateMahasiswa(
        widget.mahasiswa.id,
        namaController.text,
        nimController.text,
        jurusanController.text,
      );
      if (context.mounted) Navigator.pop(context, true);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: _danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,

      appBar: AppBar(
        backgroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_rounded,
                color: _textPri, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Mahasiswa',
          style: TextStyle(
            color: _textPri,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: _surface, thickness: 1, height: 1),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current data preview card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: _warning.withOpacity(0.25), width: 1),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _warning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: _warning.withOpacity(0.35), width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        _initials,
                        style: const TextStyle(
                          color: _warning,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mahasiswa.nama,
                          style: const TextStyle(
                            color: _textPri,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.mahasiswa.nim,
                          style: const TextStyle(
                              color: _textSec, fontSize: 12.5),
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
                            widget.mahasiswa.jurusan,
                            style: const TextStyle(
                              color: _textSec,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Edit badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _warning.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.edit_rounded,
                            color: _warning, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: _warning,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Form
            _FieldLabel(
                label: 'Nama Lengkap',
                icon: Icons.person_outline_rounded),
            const SizedBox(height: 8),
            _DarkTextField(
              controller: namaController,
              hint: 'Masukkan nama lengkap',
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 20),

            _FieldLabel(label: 'NIM', icon: Icons.badge_outlined),
            const SizedBox(height: 8),
            _DarkTextField(
              controller: nimController,
              hint: 'Masukkan NIM mahasiswa',
            ),

            const SizedBox(height: 20),

            _FieldLabel(
                label: 'Jurusan', icon: Icons.school_outlined),
            const SizedBox(height: 8),
            _DarkTextField(
              controller: jurusanController,
              hint: 'Masukkan nama jurusan',
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 36),

            // Update button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _warning,
                  foregroundColor: _navy,
                  disabledBackgroundColor: _warning.withOpacity(0.4),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: _navy,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: _surface, width: 1.5),
                  ),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                      color: _textSec,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.icon});
  final String label;
  final IconData icon;

  static const Color _textSec = Color(0xFF8FACC4);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _textSec, size: 15),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: _textSec,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _DarkTextField extends StatelessWidget {
  const _DarkTextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  static const Color _card    = Color(0xFF243447);
  static const Color _accent  = Color(0xFF00D4AA);
  static const Color _textPri = Color(0xFFF0F4F8);
  static const Color _textSec = Color(0xFF8FACC4);
  static const Color _surface = Color(0xFF1E2F42);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: const TextStyle(color: _textPri, fontSize: 14.5),
      cursorColor: _accent,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: _textSec.withOpacity(0.6), fontSize: 14),
        filled: true,
        fillColor: _card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _surface, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _surface, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
      ),
    );
  }
}