import 'package:flutter/material.dart';
import 'package:muaath_start_point_project/src/data/local/sqlite/database_service.dart';

class DatabaseTestScreen extends StatefulWidget {
  @override
  _DatabaseTestScreenState createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  String _status = 'Testing...';
  bool _isTesting = true;

  @override
  void initState() {
    super.initState();
    _testDatabase();
  }

  Future<void> _testDatabase() async {
    try {
      setState(() {
        _status = '🔄 Testing database connection...';
        _isTesting = true;
      });

      await DatabaseService().initialize();

      setState(() {
        _status =
            '✅ Database is working perfectly!\n\n'
            '✓ Connection established\n'
            '✓ Performance optimizations applied\n'
            '✓ Test table created\n'
            '✓ Ready for table creation';
        _isTesting = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Database error:\n$e';
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Database Test'),
        backgroundColor: _isTesting
            ? Colors.orange
            : _status.contains('✅')
            ? Colors.green
            : Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      _isTesting
                          ? Icons.hourglass_empty
                          : _status.contains('✅')
                          ? Icons.check_circle
                          : Icons.error,
                      color: _isTesting
                          ? Colors.orange
                          : _status.contains('✅')
                          ? Colors.green
                          : Colors.red,
                      size: 50,
                    ),
                    SizedBox(height: 16),
                    Text(
                      _status,
                      style: TextStyle(
                        fontSize: 16,
                        color: _isTesting
                            ? Colors.orange
                            : _status.contains('✅')
                            ? Colors.green
                            : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (!_isTesting)
              ElevatedButton(
                onPressed: _testDatabase,
                child: Text('Test Again'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            if (_isTesting) LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
