import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../models/category.dart';
import '../models/account.dart';
import '../models/currency.dart';
import '../models/transaction.dart';
import '../models/account.dart' as account_model;
import 'edit_item_modal.dart';

enum SettingsSection { menu, categories, accounts, currencies }

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SettingsSection _currentSection = SettingsSection.menu;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_currentSection == SettingsSection.categories) {
      return _buildCategoriesView();
    } else if (_currentSection == SettingsSection.accounts) {
      return _buildAccountsView();
    } else if (_currentSection == SettingsSection.currencies) {
      return _buildCurrenciesView();
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuración',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Dark Mode Toggle
              CustomCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            color: const Color(0xFF6366F1),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Modo Oscuro',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: isDark,
                      onChanged: (value) {
                        // This would need theme management
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Gestión',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Categorías',
                icon: Icons.trending_up,
                variant: ButtonVariant.secondary,
                isFullWidth: true,
                onPressed: () {
                  setState(() => _currentSection = SettingsSection.categories);
                },
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: 'Cuentas',
                icon: Icons.credit_card,
                variant: ButtonVariant.secondary,
                isFullWidth: true,
                onPressed: () {
                  setState(() => _currentSection = SettingsSection.accounts);
                },
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: 'Monedas',
                icon: Icons.attach_money,
                variant: ButtonVariant.secondary,
                isFullWidth: true,
                onPressed: () {
                  setState(() => _currentSection = SettingsSection.currencies);
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'SmartBudget v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesView() {
    return Consumer<AppDataProvider>(
      builder: (context, provider, _) {
        final data = provider.appData;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _currentSection = SettingsSection.menu),
            ),
            title: const Text('Categorías'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                  text: 'Agregar Nueva',
                  icon: Icons.add,
                  isFullWidth: true,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => EditItemModal(
                        type: EditItemType.category,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.categories.length,
                  itemBuilder: (context, index) {
                    final category = data.categories[index];
                    return CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                category.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  category.type == TransactionType.income
                                      ? 'Ingreso'
                                      : 'Gasto',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => EditItemModal(
                                  type: EditItemType.category,
                                  item: category,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(provider, category),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountsView() {
    return Consumer<AppDataProvider>(
      builder: (context, provider, _) {
        final data = provider.appData;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _currentSection = SettingsSection.menu),
            ),
            title: const Text('Cuentas'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                  text: 'Agregar Nueva',
                  icon: Icons.add,
                  isFullWidth: true,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => EditItemModal(
                        type: EditItemType.account,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.accounts.length,
                  itemBuilder: (context, index) {
                    final account = data.accounts[index];
                    return CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(int.parse(
                                account.color.replaceFirst('#', '0xFF'))),
                            child: Text(
                              account.name.substring(0, 2).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${account.currency} • ${account.type.name}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => EditItemModal(
                                  type: EditItemType.account,
                                  item: account,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteAccount(provider, account),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrenciesView() {
    return Consumer<AppDataProvider>(
      builder: (context, provider, _) {
        final data = provider.appData;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _currentSection = SettingsSection.menu),
            ),
            title: const Text('Monedas'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                  text: 'Agregar Nueva',
                  icon: Icons.add,
                  isFullWidth: true,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => EditItemModal(
                        type: EditItemType.currency,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.currencies.length,
                  itemBuilder: (context, index) {
                    final currency = data.currencies[index];
                    return CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Text(
                              currency.symbol,
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currency.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  currency.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => EditItemModal(
                                  type: EditItemType.currency,
                                  item: currency,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCurrency(provider, currency),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteCategory(AppDataProvider provider, Category category) {
    final data = provider.appData;
    final hasTransactions = data.transactions.any((t) => t.categoryId == category.id);
    
    if (hasTransactions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede eliminar esta categoría porque tiene transacciones asociadas.',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: const Text('¿Estás seguro de eliminar esta categoría?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.updateData(
                data.copyWith(
                  categories: data.categories
                      .where((c) => c.id != category.id)
                      .toList(),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteAccount(AppDataProvider provider, account_model.Account account) {
    final data = provider.appData;
    final hasTransactions = data.transactions.any((t) => t.accountId == account.id);
    
    if (hasTransactions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede eliminar esta cuenta porque tiene transacciones asociadas.',
          ),
        ),
      );
      return;
    }

    if (data.accounts.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes tener al menos una cuenta activa.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text('¿Estás seguro de eliminar esta cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.updateData(
                data.copyWith(
                  accounts: data.accounts.where((a) => a.id != account.id).toList(),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteCurrency(AppDataProvider provider, Currency currency) {
    final data = provider.appData;
    final isUsed = data.accounts.any((a) => a.currency == currency.code);
    
    if (isUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede eliminar esta moneda porque está siendo usada en una cuenta.',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar moneda'),
        content: const Text('¿Estás seguro de eliminar esta moneda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.updateData(
                data.copyWith(
                  currencies: data.currencies
                      .where((c) => c.id != currency.id)
                      .toList(),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

