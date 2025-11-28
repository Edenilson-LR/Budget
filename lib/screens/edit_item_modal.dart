import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_data_provider.dart';
import '../models/category.dart';
import '../models/account.dart';
import '../models/currency.dart';
import '../models/transaction.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

enum EditItemType { category, account, currency }

class EditItemModal extends StatefulWidget {
  final EditItemType type;
  final dynamic item;

  const EditItemModal({
    super.key,
    required this.type,
    this.item,
  });

  @override
  State<EditItemModal> createState() => _EditItemModalState();
}

class _EditItemModalState extends State<EditItemModal> {
  late String _name;
  late String _icon;
  late TransactionType _categoryType;
  late double _budgetLimit;
  late String _color;
  
  // Account fields
  late account_model.AccountType _accountType;
  late String _accountCurrency;
  late double _currentBalance;
  late double _initialBalance;
  late String _accountColor;
  
  // Currency fields
  late String _code;
  late String _symbol;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      if (widget.type == EditItemType.category) {
        final cat = widget.item as Category;
        _name = cat.name;
        _icon = cat.icon;
        _categoryType = cat.type;
        _budgetLimit = cat.budgetLimit;
        _color = cat.color;
      } else if (widget.type == EditItemType.account) {
        final acc = widget.item as Account;
        _name = acc.name;
        _accountType = acc.type;
        _accountCurrency = acc.currency;
        _currentBalance = acc.currentBalance;
        _initialBalance = acc.initialBalance;
        _accountColor = acc.color;
      } else if (widget.type == EditItemType.currency) {
        final cur = widget.item as Currency;
        _code = cur.code;
        _symbol = cur.symbol;
        _name = cur.name;
      }
    } else {
      // Defaults for new items
      if (widget.type == EditItemType.category) {
        _name = '';
        _icon = '🏷️';
        _categoryType = TransactionType.expense;
        _budgetLimit = 0;
        _color = '#9CA3AF';
      } else if (widget.type == EditItemType.account) {
        final provider = Provider.of<AppDataProvider>(context, listen: false);
        _name = '';
        _accountType = account_model.AccountType.cash;
        _accountCurrency = provider.appData.currencies.isNotEmpty
            ? provider.appData.currencies.first.code
            : 'USD';
        _currentBalance = 0;
        _initialBalance = 0;
        _accountColor = '#9CA3AF';
      } else if (widget.type == EditItemType.currency) {
        _code = '';
        _symbol = '';
        _name = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppDataProvider>(context);
    final data = provider.appData;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                  '${widget.item != null ? 'Editar' : 'Crear'} ${widget.type == EditItemType.category ? 'Categoría' : widget.type == EditItemType.account ? 'Cuenta' : 'Moneda'}',
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
            if (widget.type == EditItemType.category) _buildCategoryForm(data, isDark),
            if (widget.type == EditItemType.account) _buildAccountForm(data, isDark),
            if (widget.type == EditItemType.currency) _buildCurrencyForm(),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Guardar',
              icon: Icons.save,
              isFullWidth: true,
              onPressed: _validateAndSave,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryForm(AppData data, bool isDark) {
    return Column(
      children: [
        CustomInput(
          label: 'Nombre',
          value: _name,
          onChanged: (value) => setState(() => _name = value),
        ),
        CustomInput(
          label: 'Icono (Emoji)',
          value: _icon,
          onChanged: (value) => setState(() => _icon = value),
          placeholder: 'Ej: 🍔',
        ),
        CustomInput(
          label: 'Presupuesto Mensual',
          value: _budgetLimit > 0 ? _budgetLimit.toString() : '',
          onChanged: (value) => setState(() => _budgetLimit = double.tryParse(value) ?? 0),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
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
                  onTap: () => setState(() => _categoryType = TransactionType.expense),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _categoryType == TransactionType.expense
                          ? (isDark ? const Color(0xFF334155) : Colors.white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Gasto',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _categoryType == TransactionType.expense
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
                  onTap: () => setState(() => _categoryType = TransactionType.income),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _categoryType == TransactionType.income
                          ? (isDark ? const Color(0xFF334155) : Colors.white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Ingreso',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _categoryType == TransactionType.income
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'COLOR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
                ),
              ),
              child: ColorPicker(
                color: Color(int.parse(_color.replaceFirst('#', '0xFF'))),
                onColorChanged: (color) {
                  setState(() {
                    final hex = color.value.toRadixString(16).padLeft(8, '0').substring(2);
                    _color = '#$hex';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountForm(AppData data, bool isDark) {
    return Column(
      children: [
        CustomInput(
          label: 'Nombre de Cuenta',
          value: _name,
          onChanged: (value) => setState(() => _name = value),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'MONEDA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _accountCurrency,
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
                items: data.currencies.map((c) {
                  return DropdownMenuItem(
                    value: c.code,
                    child: Text('${c.code} - ${c.name}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _accountCurrency = value!),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'TIPO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              DropdownButtonFormField<account_model.AccountType>(
                value: _accountType,
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
                items: account_model.AccountType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _accountType = value!),
              ),
            ],
          ),
        ),
        CustomInput(
          label: 'Balance Actual',
          value: _currentBalance > 0 ? _currentBalance.toString() : '',
          onChanged: (value) {
            setState(() {
              _currentBalance = double.tryParse(value) ?? 0;
              if (_initialBalance == 0) _initialBalance = _currentBalance;
            });
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'COLOR DISTINTIVO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
                ),
              ),
              child: ColorPicker(
                color: Color(int.parse(_accountColor.replaceFirst('#', '0xFF'))),
                onColorChanged: (color) {
                  setState(() {
                    final hex = color.value.toRadixString(16).padLeft(8, '0').substring(2);
                    _accountColor = '#$hex';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyForm() {
    return Column(
      children: [
        CustomInput(
          label: 'Código (Ej: USD)',
          value: _code,
          onChanged: (value) => setState(() => _code = value.toUpperCase()),
          maxLength: 3,
        ),
        CustomInput(
          label: 'Símbolo (Ej: \$)',
          value: _symbol,
          onChanged: (value) => setState(() => _symbol = value),
        ),
        CustomInput(
          label: 'Nombre',
          value: _name,
          onChanged: (value) => setState(() => _name = value),
        ),
      ],
    );
  }

  void _validateAndSave() {
    final provider = Provider.of<AppDataProvider>(context);
    final data = provider.appData;

    if (widget.type == EditItemType.category) {
      if (_name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre es requerido')),
        );
        return;
      }
      final category = Category(
        id: widget.item?.id ?? const Uuid().v4(),
        name: _name,
        type: _categoryType,
        icon: _icon.isEmpty ? '🏷️' : _icon,
        budgetLimit: _budgetLimit,
        color: _color,
      );
      final categories = List<Category>.from(data.categories);
      final index = categories.indexWhere((c) => c.id == category.id);
      if (index >= 0) {
        categories[index] = category;
      } else {
        categories.add(category);
      }
      provider.updateData(data.copyWith(categories: categories));
    } else if (widget.type == EditItemType.account) {
      if (_name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre es requerido')),
        );
        return;
      }
      final account = Account(
        id: widget.item?.id ?? const Uuid().v4(),
        name: _name,
        type: _accountType,
        currency: _accountCurrency,
        initialBalance: _initialBalance,
        currentBalance: _currentBalance,
        color: _accountColor,
      );
      final accounts = List<Account>.from(data.accounts);
      final index = accounts.indexWhere((a) => a.id == account.id);
      if (index >= 0) {
        accounts[index] = account;
      } else {
        accounts.add(account);
      }
      provider.updateData(data.copyWith(accounts: accounts));
    } else if (widget.type == EditItemType.currency) {
      if (_code.isEmpty || _symbol.isEmpty || _name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todos los campos son requeridos')),
        );
        return;
      }
      final currency = Currency(
        id: widget.item?.id ?? const Uuid().v4(),
        code: _code,
        symbol: _symbol,
        name: _name,
      );
      final currencies = List<Currency>.from(data.currencies);
      final index = currencies.indexWhere((c) => c.id == currency.id);
      if (index >= 0) {
        currencies[index] = currency;
      } else {
        currencies.add(currency);
      }
      provider.updateData(data.copyWith(currencies: currencies));
    }

    Navigator.pop(context);
  }
}

// Simple Color Picker Widget
class ColorPicker extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      '#F59E0B', '#3B82F6', '#8B5CF6', '#10B981', '#06B6D4',
      '#EF4444', '#F97316', '#EC4899', '#14B8A6', '#6366F1',
      '#22C55E', '#84CC16', '#FBBF24', '#FB923C', '#9CA3AF',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((hex) {
        final c = Color(int.parse(hex.replaceFirst('#', '0xFF')));
        final isSelected = c.value == color.value;
        return GestureDetector(
          onTap: () => onColorChanged(c),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : Border.all(color: Colors.grey[300]!, width: 1),
            ),
          ),
        );
      }).toList(),
    );
  }
}

