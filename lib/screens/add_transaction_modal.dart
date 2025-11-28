import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_data_provider.dart';
import '../models/transaction.dart';
import '../models/account.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../utils/formatters.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  TransactionType _type = TransactionType.expense;
  String? _categoryId;
  String? _accountId;
  double _amount = 0;
  DateTime _date = DateTime.now();
  String _note = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppDataProvider>(context);
    final data = provider.appData;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredCategories = data.categories
        .where((c) => c.type == _type)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nueva Transacción',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Type Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = TransactionType.expense),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == TransactionType.expense
                              ? (isDark ? const Color(0xFF334155) : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Gasto',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _type == TransactionType.expense
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = TransactionType.income),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == TransactionType.income
                              ? (isDark ? const Color(0xFF334155) : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Ingreso',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _type == TransactionType.income
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Date
            CustomInput(
              label: 'Fecha',
              value: formatDate(_date),
              onChanged: (value) {
                final date = DateTime.tryParse(value);
                if (date != null) setState(() => _date = date);
              },
              keyboardType: TextInputType.datetime,
            ),
            // Amount
            CustomInput(
              label: 'Monto',
              value: _amount > 0 ? _amount.toString() : '',
              onChanged: (value) {
                setState(() => _amount = double.tryParse(value) ?? 0);
              },
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              placeholder: '0.00',
            ),
            // Category
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'CATEGORÍA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        final isSelected = _categoryId == category.id;
                        return GestureDetector(
                          onTap: () => setState(() => _categoryId = category.id),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF3B82F6).withOpacity(0.1)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF3B82F6)
                                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(category.icon, style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected
                                        ? const Color(0xFF3B82F6)
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Account
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'CUENTA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: _accountId,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: data.accounts.map((account) {
                      return DropdownMenuItem(
                        value: account.id,
                        child: Text(
                          '${account.name} (${formatCurrency(account.currentBalance, account.currency, data.currencies)})',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _accountId = value),
                  ),
                ],
              ),
            ),
            // Note
            CustomInput(
              label: 'Nota (Opcional)',
              value: _note,
              onChanged: (value) => setState(() => _note = value),
              placeholder: 'Descripción breve...',
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Guardar',
              onPressed: _amount > 0 && _categoryId != null && _accountId != null
                  ? () {
                      final transaction = Transaction(
                        id: const Uuid().v4(),
                        amount: _amount,
                        type: _type,
                        categoryId: _categoryId!,
                        accountId: _accountId!,
                        date: _date,
                        note: _note,
                      );

                      // Update account balance
                      final updatedAccounts = data.accounts.map((acc) {
                        if (acc.id == transaction.accountId) {
                          final change = transaction.type == TransactionType.income
                              ? transaction.amount
                              : -transaction.amount;
                          return acc.copyWith(
                            currentBalance: acc.currentBalance + change,
                          );
                        }
                        return acc;
                      }).toList();

                      provider.updateData(
                        data.copyWith(
                          accounts: updatedAccounts,
                          transactions: [transaction, ...data.transactions],
                        ),
                      );

                      Navigator.pop(context);
                    }
                  : null,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

