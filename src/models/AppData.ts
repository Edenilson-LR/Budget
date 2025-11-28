import { Account } from './Account';
import { Category } from './Category';
import { Currency } from './Currency';
import { Transaction } from './Transaction';

export interface AppData {
  accounts: Account[];
  categories: Category[];
  transactions: Transaction[];
  currencies: Currency[];
}

export const appDataToJson = (data: AppData) => ({
  accounts: data.accounts.map(account => ({
    id: account.id,
    name: account.name,
    type: account.type,
    currency: account.currency,
    initialBalance: account.initialBalance,
    currentBalance: account.currentBalance,
    color: account.color,
  })),
  categories: data.categories.map(category => ({
    id: category.id,
    name: category.name,
    type: category.type,
    icon: category.icon,
    budgetLimit: category.budgetLimit,
    color: category.color,
  })),
  transactions: data.transactions.map(transaction => ({
    id: transaction.id,
    amount: transaction.amount,
    type: transaction.type,
    categoryId: transaction.categoryId,
    accountId: transaction.accountId,
    date: transaction.date.toISOString(),
    note: transaction.note,
  })),
  currencies: data.currencies.map(currency => ({
    id: currency.id,
    code: currency.code,
    symbol: currency.symbol,
    name: currency.name,
  })),
});

export const appDataFromJson = (json: any): AppData => ({
  accounts: (json.accounts || []).map((a: any) => ({
    id: a.id,
    name: a.name,
    type: a.type,
    currency: a.currency,
    initialBalance: parseFloat(a.initialBalance),
    currentBalance: parseFloat(a.currentBalance),
    color: a.color,
  })),
  categories: (json.categories || []).map((c: any) => ({
    id: c.id,
    name: c.name,
    type: c.type,
    icon: c.icon,
    budgetLimit: parseFloat(c.budgetLimit),
    color: c.color,
  })),
  transactions: (json.transactions || []).map((t: any) => ({
    id: t.id,
    amount: parseFloat(t.amount),
    type: t.type,
    categoryId: t.categoryId,
    accountId: t.accountId,
    date: new Date(t.date),
    note: t.note || '',
  })),
  currencies: (json.currencies || []).map((c: any) => ({
    id: c.id,
    code: c.code,
    symbol: c.symbol,
    name: c.name,
  })),
});

