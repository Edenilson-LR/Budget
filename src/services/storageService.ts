import { AppData, appDataFromJson, appDataToJson } from '../models/AppData';
import { Currency, createCurrency } from '../models/Currency';
import { Category, createCategory } from '../models/Category';
import { Account, createAccount, AccountType } from '../models/Account';
import { TransactionType } from '../models/Transaction';

const DATA_KEY = 'smartbudget_data';

// Para web, usar localStorage
const isWeb = typeof window !== 'undefined';

// Lazy import de AsyncStorage solo para React Native
let AsyncStorage: any = null;
if (!isWeb) {
  try {
    AsyncStorage = require('@react-native-async-storage/async-storage').default;
  } catch (e) {
    console.warn('AsyncStorage not available');
  }
}

export const getInitialData = (): AppData => {
  const currencies: Currency[] = [
    createCurrency('cur1', 'USD', '$', 'Dólar Estadounidense'),
    createCurrency('cur2', 'EUR', '€', 'Euro'),
    createCurrency('cur3', 'MXN', '$', 'Peso Mexicano'),
  ];

  const categories: Category[] = [
    createCategory('c1', 'Comida', TransactionType.EXPENSE, '🍔', 300, '#F59E0B'),
    createCategory('c2', 'Transporte', TransactionType.EXPENSE, '🚌', 100, '#3B82F6'),
    createCategory('c3', 'Hogar', TransactionType.EXPENSE, '🏠', 500, '#8B5CF6'),
    createCategory('c4', 'Salario', TransactionType.INCOME, '💰', 0, '#10B981'),
    createCategory('c5', 'Freelance', TransactionType.INCOME, '💻', 0, '#06B6D4'),
  ];

  const accounts = [
    createAccount('a1', 'Efectivo', AccountType.CASH, 'USD', 100, 100, '#22C55E'),
    createAccount('a2', 'Banco Principal', AccountType.BANK, 'USD', 1500, 1500, '#3B82F6'),
  ];

  return {
    accounts,
    categories,
    transactions: [],
    currencies,
  };
};

export const loadData = async (): Promise<AppData> => {
  try {
    let dataString: string | null;
    
    if (isWeb) {
      dataString = localStorage.getItem(DATA_KEY);
    } else {
      dataString = await AsyncStorage.getItem(DATA_KEY);
    }

    if (!dataString) {
      return getInitialData();
    }

    const json = JSON.parse(dataString);
    return appDataFromJson(json);
  } catch (error) {
    console.error('Error loading data:', error);
    return getInitialData();
  }
};

export const saveData = async (data: AppData): Promise<void> => {
  try {
    const jsonString = JSON.stringify(appDataToJson(data));
    
    if (isWeb) {
      localStorage.setItem(DATA_KEY, jsonString);
    } else {
      await AsyncStorage.setItem(DATA_KEY, jsonString);
    }
  } catch (error) {
    console.error('Error saving data:', error);
  }
};

