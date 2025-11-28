export interface Currency {
  id: string;
  code: string;
  symbol: string;
  name: string;
}

export const createCurrency = (
  id: string,
  code: string,
  symbol: string,
  name: string
): Currency => ({
  id,
  code,
  symbol,
  name,
});

export const currencyToJson = (currency: Currency) => ({
  id: currency.id,
  code: currency.code,
  symbol: currency.symbol,
  name: currency.name,
});

export const currencyFromJson = (json: any): Currency => ({
  id: json.id as string,
  code: json.code as string,
  symbol: json.symbol as string,
  name: json.name as string,
});

