import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'psychologist_directory_screen.dart'; // To get mock psychologist data

class BookingFlowScreen extends StatefulWidget {
  final String psychologistId;
  const BookingFlowScreen({super.key, required this.psychologistId});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _currentStep = 0;
  
  // Form Data
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _phone;
  String? _issue;
  bool _acceptedTerms = false;
  
  // Mock Payment
  bool _isPaid = false;
  
  // Mock Slot Selection
  String? _selectedSlot;
  final List<String> mockSlots = [
    'Tomorrow, 10:00 AM',
    'Tomorrow, 1:00 PM',
    'Tomorrow, 4:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final psychologist = mockPsychologists.firstWhere((p) => p.id == widget.psychologistId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Book with ${psychologist.lastName}'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_formKey.currentState!.validate() && _acceptedTerms) {
              _formKey.currentState!.save();
              setState(() => _currentStep++);
            } else if (!_acceptedTerms) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept terms and conditions')));
            }
          } else if (_currentStep == 1) {
            if (_isPaid) {
              setState(() => _currentStep++);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete payment')));
            }
          } else if (_currentStep == 2) {
            if (_selectedSlot != null) {
              setState(() => _currentStep++);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a time slot')));
            }
          } else if (_currentStep == 3) {
            // Finish
            context.go('/');
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Confirmed! You will receive an email shortly.')));
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else if (Navigator.canPop(context)) {
            context.pop();
          } else {
            context.go('/');
          }
        },
        controlsBuilder: (context, details) {
          if (_currentStep == 3) {
            return ElevatedButton(onPressed: details.onStepContinue, child: const Text('Return to Home'));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                ElevatedButton(onPressed: details.onStepContinue, child: const Text('Continue')),
                const SizedBox(width: 12),
                TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Client Details'),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _name = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email Address'),
                    validator: (v) => v!.isEmpty || !v.contains('@') ? 'Invalid Email' : null,
                    onSaved: (v) => _email = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _phone = v,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Issue Type'),
                    items: psychologist.areasOfExpertise.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => _issue = v,
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('I accept the Terms & Conditions'),
                    value: _acceptedTerms,
                    onChanged: (v) => setState(() => _acceptedTerms = v!),
                  )
                ],
              ),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Payment'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Consultation Fee: \$${psychologist.consultationFee}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                const Text('Mock Bank Gateway Interface:'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  label: Text(_isPaid ? 'Payment Successful' : 'Pay Now'),
                  style: ElevatedButton.styleFrom(backgroundColor: _isPaid ? Colors.green : Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    setState(() => _isPaid = true);
                  },
                )
              ],
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Select Slot'),
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: mockSlots.map((s) {
                final selected = _selectedSlot == s;
                return ChoiceChip(
                  label: Text(s),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedSlot = s),
                );
              }).toList(),
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text('Confirmation'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                Text('Your session has been successfully booked!', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Client: ${_name ?? 'N/A'}', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text('Email: ${_email ?? 'N/A'}', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text('Phone: ${_phone ?? 'N/A'}', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 12),
                Text('Issue: ${_issue ?? 'N/A'}', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text('Selected slot: ${_selectedSlot ?? 'N/A'}', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                const Text('We have sent an email with the Google Meet link and session details. Please check your inbox.'),
              ],
            ),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }
}
