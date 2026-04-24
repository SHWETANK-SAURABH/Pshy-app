import 'package:flutter/material.dart';

class PsychologistCrudScreen extends StatelessWidget {
  const PsychologistCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Psychologists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
            tooltip: 'Add Psychologist',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildListItem(context, 'Dr. Sarah Jenkins', 'Active', true),
          _buildListItem(context, 'Dr. Marcus Chen', 'Active', true),
          _buildListItem(context, 'Dr. Emily Stone', 'Inactive', false),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String name, String status, bool isActive) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.green : Colors.grey,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(status),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit coming soon'))),
            ),
            Switch(
              value: isActive,
              onChanged: (v) {},
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Psychologist'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'First Name')),
            SizedBox(height: 8),
            TextField(decoration: InputDecoration(labelText: 'Last Name')),
            SizedBox(height: 8),
            TextField(decoration: InputDecoration(labelText: 'Consultation Fee')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save')),
        ],
      ),
    );
  }
}
