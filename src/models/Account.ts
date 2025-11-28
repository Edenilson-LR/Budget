export enum AccountType {
  CASH = 'cash',
  BANK = 'bank',
  CARD = 'card',
  CRYPTO = 'crypto',
}

export interface Account {
  id: string;
  name: string;
  type: AccountType;
  currency: string;
  initialBalance: number;
  currentBalance: number;
  color: string;
}

export const createAccount = (
  id: string,
  name: string,
  type: AccountType,
  currency: string,
  initialBalance: number,
  currentBalance: number,
  color: string
): Account => ({
  id,
  name,
  type,
  currency,
  initialBalance,
  currentBalance,
  color,
});

export const accountToJson = (account: Account) => ({
  id: account.id,
  name: account.name,
  type: account.type,
  currency: account.currency,
  initialBalance: account.initialBalance,
  currentBalance: account.currentBalance,
  color: account.color,
});

export const accountFromJson = (json: any): Account => ({
  id: json.id as string,
  name: json.name as string,
  type: json.type as AccountType,
  currency: json.currency as string,
  initialBalance: parseFloat(json.initialBalance),
  currentBalance: parseFloat(json.currentBalance),
  color: json.color as string,
});

