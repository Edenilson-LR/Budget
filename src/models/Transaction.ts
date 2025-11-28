export enum TransactionType {
  INCOME = 'income',
  EXPENSE = 'expense',
  TRANSFER = 'transfer',
}

export interface Transaction {
  id: string;
  amount: number;
  type: TransactionType;
  categoryId: string;
  accountId: string;
  date: Date;
  note: string;
}

export const createTransaction = (
  id: string,
  amount: number,
  type: TransactionType,
  categoryId: string,
  accountId: string,
  date: Date,
  note: string = ''
): Transaction => ({
  id,
  amount,
  type,
  categoryId,
  accountId,
  date,
  note,
});

export const transactionToJson = (transaction: Transaction) => ({
  id: transaction.id,
  amount: transaction.amount,
  type: transaction.type,
  categoryId: transaction.categoryId,
  accountId: transaction.accountId,
  date: transaction.date.toISOString(),
  note: transaction.note,
});

export const transactionFromJson = (json: any): Transaction => ({
  id: json.id as string,
  amount: parseFloat(json.amount),
  type: json.type as TransactionType,
  categoryId: json.categoryId as string,
  accountId: json.accountId as string,
  date: new Date(json.date),
  note: json.note || '',
});

