import { TransactionType } from './Transaction';

export interface Category {
  id: string;
  name: string;
  type: TransactionType;
  icon: string;
  budgetLimit: number;
  color: string;
}

export const createCategory = (
  id: string,
  name: string,
  type: TransactionType,
  icon: string,
  budgetLimit: number,
  color: string
): Category => ({
  id,
  name,
  type,
  icon,
  budgetLimit,
  color,
});

export const categoryToJson = (category: Category) => ({
  id: category.id,
  name: category.name,
  type: category.type,
  icon: category.icon,
  budgetLimit: category.budgetLimit,
  color: category.color,
});

export const categoryFromJson = (json: any): Category => ({
  id: json.id as string,
  name: json.name as string,
  type: json.type as TransactionType,
  icon: json.icon as string,
  budgetLimit: parseFloat(json.budgetLimit),
  color: json.color as string,
});

