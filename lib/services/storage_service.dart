import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_data.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../models/transaction.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static const String _dataKey = 'smartbudget_data';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static AppData getInitialData() {
    final currencies = [
      Currency(
        id: 'cur1',
        code: 'USD',
        symbol: '\$',
        name: 'Dólar Estadounidense',
      ),
      Currency(
        id: 'cur2',
        code: 'EUR',
        symbol: '€',
        name: 'Euro',
      ),
      Currency(
        id: 'cur3',
        code: 'MXN',
        symbol: '\$',
        name: 'Peso Mexicano',
      ),
    ];

    final categories = [
      Category(
        id: 'c1',
        name: 'Comida',
        type: TransactionType.expense,
        icon: '🍔',
        budgetLimit: 300,
        color: '#F59E0B',
      ),
      Category(
        id: 'c2',
        name: 'Transporte',
        type: TransactionType.expense,
        icon: '🚌',
        budgetLimit: 100,
        color: '#3B82F6',
      ),
      Category(
        id: 'c3',
        name: 'Hogar',
        type: TransactionType.expense,
        icon: '🏠',
        budgetLimit: 500,
        color: '#8B5CF6',
      ),
      Category(
        id: 'c4',
        name: 'Salario',
        type: TransactionType.income,
        icon: '💰',
        budgetLimit: 0,
        color: '#10B981',
      ),
      Category(
        id: 'c5',
        name: 'Freelance',
        type: TransactionType.income,
        icon: '💻',
        budgetLimit: 0,
        color: '#06B6D4',
      ),
    ];

    final accounts = [
      Account(
        id: 'a1',
        name: 'Efectivo',
        type: AccountType.cash,
        currency: 'USD',
        initialBalance: 100,
        currentBalance: 100,
        color: '#22C55E',
      ),
      Account(
        id: 'a2',
        name: 'Banco Principal',
        type: AccountType.bank,
        currency: 'USD',
        initialBalance: 1500,
        currentBalance: 1500,
        color: '#3B82F6',
      ),
    ];

    return AppData(
      accounts: accounts,
      categories: categories,
      transactions: [],
      currencies: currencies,
    );
  }

  static Future<AppData> loadData() async {
    if (_prefs == null) await init();
    final dataString = _prefs!.getString(_dataKey);
    if (dataString == null) {
      return getInitialData();
    }
    try {
      final json = jsonDecode(dataString) as Map<String, dynamic>;
      return AppData.fromJson(json);
    } catch (e) {
      return getInitialData();
    }
  }

  static Future<void> saveData(AppData data) async {
    if (_prefs == null) await init();
    final jsonString = jsonEncode(data.toJson());
    await _prefs!.setString(_dataKey, jsonString);
  }
}

