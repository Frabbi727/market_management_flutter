import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/models/shop_model.dart';
import '../../service/shop_service.dart';
import '../../provider/shop_providers.dart';

class AddShopDialog extends ConsumerStatefulWidget {
  const AddShopDialog({super.key});

  @override
  ConsumerState<AddShopDialog> createState() => _AddShopDialogState();
}

class _AddShopDialogState extends ConsumerState<AddShopDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form controllers
  final _shopNumberController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _floorController = TextEditingController();
  final _sideController = TextEditingController();
  final _locationController = TextEditingController();
  final _locationNoController = TextEditingController();
  final _registrationNoController = TextEditingController();
  final _areaSqftController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _remarksController = TextEditingController();

  bool _isActive = true;
  final int _marketId = 1; // Fixed to 1 as per requirement

  @override
  void dispose() {
    _shopNumberController.dispose();
    _shopNameController.dispose();
    _floorController.dispose();
    _sideController.dispose();
    _locationController.dispose();
    _locationNoController.dispose();
    _registrationNoController.dispose();
    _areaSqftController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final shopData = {
        'shopNumber': int.parse(_shopNumberController.text),
        'shopName': _shopNameController.text.trim(),
        'marketId': _marketId,
        'floor': int.parse(_floorController.text),
        'side': _sideController.text.trim(),
        'location': _locationController.text.trim(),
        'locationNo': _locationNoController.text.trim(),
        'registrationNo': _registrationNoController.text.trim(),
        'areaSqft': double.parse(_areaSqftController.text),
        'ownerName': _ownerNameController.text.trim(),
        'ownerPhone': _ownerPhoneController.text.trim(),
        'remarks': _remarksController.text.trim(),
        'active': _isActive,
      };

      final service = ref.read(shopServiceProvider);
      await service.createShop(shopData);

      // Refresh shops list
      ref.invalidate(shopsListProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shop created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create shop: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_business, color: Colors.white),
                  const SizedBox(width: 12),
                  const Text(
                    'Add New Shop',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information Section
                      _buildSectionTitle('Basic Information'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _shopNumberController,
                        label: 'Shop Number *',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Shop number is required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _shopNameController,
                        label: 'Shop Name *',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Shop name is required';
                          }
                          if (value.length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),
                      // Location Information Section
                      _buildSectionTitle('Location Information'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _floorController,
                              label: 'Floor *',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Floor is required';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Enter a valid floor number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _sideController,
                              label: 'Side *',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Side is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _locationController,
                              label: 'Location *',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Location is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _locationNoController,
                              label: 'Location No *',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Location No is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      // Shop Details Section
                      _buildSectionTitle('Shop Details'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _registrationNoController,
                              label: 'Registration No *',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Registration No is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _areaSqftController,
                              label: 'Area (sqft) *',
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Area is required';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Enter a valid area';
                                }
                                if (double.parse(value) <= 0) {
                                  return 'Area must be greater than 0';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      // Owner Information Section
                      _buildSectionTitle('Owner Information'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _ownerNameController,
                        label: 'Owner Name *',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Owner name is required';
                          }
                          if (value.length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _ownerPhoneController,
                        label: 'Owner Phone *',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          if (value.length < 10) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),
                      // Additional Information Section
                      _buildSectionTitle('Additional Information'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _remarksController,
                        label: 'Remarks',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text(
                          'Active',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          _isActive
                              ? 'Shop is active and operational'
                              : 'Shop is inactive',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() => _isActive = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer with buttons
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleSubmit,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(_isLoading ? 'Creating...' : 'Create Shop'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
    );
  }
}
