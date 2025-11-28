import { format, parseISO } from 'date-fns';
import { Currency } from '../models/Currency';

export const formatCurrency = (
  amount: number,
  currencyCode: string,
  currencies: Currency[]
): string => {
  const currency = currencies.find(c => c.code === currencyCode) || currencies[0] || {
    id: '',
    code: 'USD',
    symbol: '$',
    name: 'Dólar',
  };

  return `${currency.symbol}${amount.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`;
};

export const formatDate = (date: Date | string): string => {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  return format(dateObj, 'yyyy-MM-dd');
};

export const formatDateShort = (date: Date | string): string => {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  return format(dateObj, 'MMM dd');
};

