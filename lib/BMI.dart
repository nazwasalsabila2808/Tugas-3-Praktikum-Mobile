import 'package:flutter/material.dart';

enum Gender { male, female }

class BMIScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final _bbController = TextEditingController();
  final _tbController = TextEditingController();

  Gender _selectedGender = Gender.male;
  double? _hasilBMI;
  String _keterangan = "Masukkan Data Anda";
  Color _statusColor = Colors.teal;

  void _logikaBMI() {
    final double bb = double.tryParse(_bbController.text) ?? 0;
    final double tbCm = double.tryParse(_tbController.text) ?? 0;

  
    if (bb <= 0 || tbCm <= 0) {
      setState(() {
        _hasilBMI = null;
        _keterangan = "Data tidak valid!";
        _statusColor = Colors.grey;
      });
      return;
    }

    final double tbM = tbCm / 100;
    final double hasil = bb / (tbM * tbM);

    setState(() {
      _hasilBMI = hasil;

      if (_selectedGender == Gender.male) {
        // Klasifikasi BMI untuk Laki-laki
        if (hasil < 18.5) {
          _keterangan = "Berat Badan Kurang";
          _statusColor = Colors.orange;
        } else if (hasil < 25.0) {
          _keterangan = "Berat Badan Ideal";
          _statusColor = Colors.green;
        } else if (hasil < 30.0) {
          _keterangan = "Kelebihan Berat Badan";
          _statusColor = Colors.deepOrange;
        } else {
          _keterangan = "Obesitas";
          _statusColor = Colors.red;
        }
      } else {
        // Klasifikasi BMI untuk Perempuan
        if (hasil < 18.0) {
          _keterangan = "Berat Badan Kurang";
          _statusColor = Colors.orange;
        } else if (hasil < 24.0) {
          _keterangan = "Berat Badan Ideal";
          _statusColor = Colors.green;
        } else if (hasil < 29.0) {
          _keterangan = "Kelebihan Berat Badan";
          _statusColor = Colors.deepOrange;
        } else {
          _keterangan = "Obesitas";
          _statusColor = Colors.red;
        }
      }
    });
  }

  void _reset() {
    setState(() {
      _bbController.clear();
      _tbController.clear();
      _hasilBMI = null;
      _keterangan = "Masukkan Data Anda";
      _statusColor = Colors.teal;
      _selectedGender = Gender.male;
    });
  }

  @override
  void dispose() {
    _bbController.dispose();
    _tbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Kalkulator BMI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 2,
        leading: const Icon(Icons.fitness_center, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pilih Gender
              const Text(
                "Jenis Kelamin",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SegmentedButton<Gender>(
                segments: const [
                  ButtonSegment<Gender>(
                    value: Gender.male,
                    label: Text('Laki-laki'),
                    icon: Icon(Icons.male),
                  ),
                  ButtonSegment<Gender>(
                    value: Gender.female,
                    label: Text('Perempuan'),
                    icon: Icon(Icons.female),
                  ),
                ],
                selected: {_selectedGender},
                onSelectionChanged: (Set<Gender> newSelection) {
                  setState(() {
                    _selectedGender = newSelection.first;
                  });
                  if (_hasilBMI != null) {
                    _logikaBMI(); // Recalculate if results are showing
                  }
                },
              ),
              const SizedBox(height: 20),

              // Input Berat Badan
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _bbController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.monitor_weight_outlined, color: Colors.teal),
                      labelText: 'Berat Badan (kg)',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Input Tinggi Badan
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _tbController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.height, color: Colors.teal),
                      labelText: 'Tinggi Badan (cm)',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Hitung & Reset
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _reset,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.teal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 16, color: Colors.teal),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _logikaBMI,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Hitung BMI',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Kartu Hasil
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _statusColor, width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(
                      _hasilBMI != null ? 'BMI Anda (${_selectedGender == Gender.male ? "Laki-laki" : "Perempuan"})' : 'Hasil BMI',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _hasilBMI?.toStringAsFixed(1) ?? '--',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _statusColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _keterangan,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}