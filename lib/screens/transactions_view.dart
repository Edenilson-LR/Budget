import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import '../widgets/custom_card.dart';
import '../utils/formatters.dart';
import '../models/transaction.dart';
import 'add_transaction_modal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  String _sortBy = 'date-desc';
  String _filterCategory = 'all';
  String _filterAccount = 'all';

  Future<void> _exportToCSV() async {
    final provider = Provider.of<AppDataProvider>(context, listen: false);
    final data = provider.appData;

    final headers = ['Fecha', 'Tipo', 'Monto', 'Categoría', 'Cuenta', 'Nota'];
    final rows = data.transactions.map((tx) {
      final cat = data.categories.firstWhere(
        (c) => c.id == tx.categoryId,
        orElse: () => data.categories.first,
      );
      final acc = data.accounts.firstWhere(
        (a) => a.id == tx.accountId,
        orElse: () => data.accounts.first,
      );
      return [
        formatDate(tx.date),
        tx.type.name,
        tx.amount.toString(),
        cat.name,
        acc.name,
        tx.note,
      ];
    }).toList();

    final csv = ListToCsvConverter().convert([headers, ...rows]);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/smartbudget_export_${DateTime.now().toIso8601String().split('T')[0]}.csv');
    await file.writeAsString(csv);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exportado a: ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataProvider>(
      builder: (context, provider, _) {
        final data = provider.appData;
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        // Filter and sort
        var filtered = data.transactions.toList();
        
        if (_filterCategory != 'all') {
          filtered = filtered.where((t) => t.categoryId == _filterCategory).toList();
        }
        if (_filterAccount != 'all') {
          filtered = filtered.where((t) => t.accountId == _filterAccount).toList();
        }

        filtered.sort((a, b) {
          switch (_sortBy) {
            case 'date-desc':
              return b.date.compareTo(a.date);
            case 'date-asc':
              return a.date.compareTo(b.date);
            case 'amount-desc':
              return b.amount.compareTo(a.amount);
            case 'amount-asc':
              return a.amount.compareTo(b.amount);
            default:
              return 0;
          }
        });

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Movimientos',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: _exportToCSV,
                        tooltip: 'Exportar CSV',
                      ),
                    ],
                  ),
                ),
                // Filters
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildFilterChip(
                        context,
                        Icons.swap_vert,
                        _sortBy == 'date-desc' ? 'Más recientes' : 
                        _sortBy == 'date-asc' ? 'Más antiguos' :
                        _sortBy == 'amount-desc' ? 'Mayor monto' : 'Menor monto',
                        () {
                          setState(() {
                            _sortBy = _sortBy == 'date-desc' ? 'date-asc' :
                                     _sortBy == 'date-asc' ? 'amount-desc' :
                                     _sortBy == 'amount-desc' ? 'amount-asc' : 'date-desc';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        Icons.filter_list,
                        _filterCategory == 'all' ? 'Todas las categorías' :
                        data.categories.firstWhere((c) => c.id == _filterCategory).name,
                        () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => _buildCategoryFilter(data),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        Icons.account_balance_wallet,
                        _filterAccount == 'all' ? 'Todas las cuentas' :
                        data.accounts.firstWhere((a) => a.id == _filterAccount).name,
                        () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => _buildAccountFilter(data),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Transactions List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No se encontraron transacciones.',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final tx = filtered[index];
                            final cat = data.categories.firstWhere(
                              (c) => c.id == tx.categoryId,
                              orElse: () => data.categories.first,
                            );
                            final acc = data.accounts.firstWhere(
                              (a) => a.id == tx.accountId,
                              orElse: () => data.accounts.first,
                            );
                            return CustomCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(
                                              cat.color.replaceFirst('#', '0xFF')))
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        cat.icon,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cat.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tx.note.isEmpty ? 'Sin nota' : tx.note,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            acc.name,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF3B82F6),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${tx.type == TransactionType.income ? '+' : '-'}${formatCurrency(tx.amount, acc.currency, data.currencies)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: tx.type == TransactionType.income
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      Text(
                                        formatDate(tx.date),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 20),
                                        color: Colors.grey[400],
                                        onPressed: () {
                                          _deleteTransaction(provider, tx);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddTransactionModal(),
              );
            },
            backgroundColor: const Color(0xFF3B82F6),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(AppData data) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Todas las categorías'),
            leading: const Icon(Icons.clear_all),
            onTap: () {
              setState(() => _filterCategory = 'all');
              Navigator.pop(context);
            },
          ),
          ...data.categories.map((cat) {
            return ListTile(
              leading: Text(cat.icon, style: const TextStyle(fontSize: 24)),
              title: Text(cat.name),
              onTap: () {
                setState(() => _filterCategory = cat.id);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccountFilter(AppData data) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Todas las cuentas'),
            leading: const Icon(Icons.clear_all),
            onTap: () {
              setState(() => _filterAccount = 'all');
              Navigator.pop(context);
            },
          ),
          ...data.accounts.map((acc) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(int.parse(acc.color.replaceFirst('#', '0xFF'))),
                child: Text(
                  acc.name.substring(0, 2).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              title: Text(acc.name),
              onTap: () {
                setState(() => _filterAccount = acc.id);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  void _deleteTransaction(AppDataProvider provider, Transaction tx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: const Text('¿Estás seguro de eliminar esta transacción?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final data = provider.appData;
              // Revert account balance
              final updatedAccounts = data.accounts.map((acc) {
                if (acc.id == tx.accountId) {
                  final change = tx.type == TransactionType.income
                      ? -tx.amount
                      : tx.amount;
                  return acc.copyWith(
                    currentBalance: acc.currentBalance + change,
                  );
                }
                return acc;
              }).toList();

              provider.updateData(
                data.copyWith(
                  accounts: updatedAccounts,
                  transactions: data.transactions.where((t) => t.id != tx.id).toList(),
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

