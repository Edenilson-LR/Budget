import React from 'react';
import { View, Text, StyleSheet, FlatList } from 'react-native';
import { useAppData } from '../context/AppDataContext';
import { CustomCard } from '../components/CustomCard';
import { formatCurrency, formatDateShort } from '../utils/formatters';
import { Transaction } from '../models/Transaction';

const TransactionsScreen: React.FC = () => {
  const { appData } = useAppData();

  const renderTransaction = ({ item }: { item: Transaction }) => {
    const category = appData.categories.find(c => c.id === item.categoryId);
    const account = appData.accounts.find(a => a.id === item.accountId);

    return (
      <CustomCard style={styles.transactionCard}>
        <View style={styles.transactionHeader}>
          <Text style={styles.categoryIcon}>{category?.icon || '📝'}</Text>
          <View style={styles.transactionInfo}>
            <Text style={styles.categoryName}>{category?.name || 'Sin categoría'}</Text>
            <Text style={styles.accountName}>{account?.name || 'Sin cuenta'}</Text>
          </View>
          <Text
            style={[
              styles.amount,
              item.type === 'income' ? styles.income : styles.expense,
            ]}
          >
            {item.type === 'income' ? '+' : '-'}
            {formatCurrency(Math.abs(item.amount), account?.currency || 'USD', appData.currencies)}
          </Text>
        </View>
        <Text style={styles.date}>{formatDateShort(item.date)}</Text>
        {item.note && <Text style={styles.note}>{item.note}</Text>}
      </CustomCard>
    );
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Transacciones</Text>
      </View>
      <FlatList
        data={appData.transactions.sort((a, b) => b.date.getTime() - a.date.getTime())}
        renderItem={renderTransaction}
        keyExtractor={item => item.id}
        contentContainerStyle={styles.list}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F9FAFB',
  },
  header: {
    padding: 20,
    paddingTop: 60,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#111827',
  },
  list: {
    padding: 20,
  },
  transactionCard: {
    marginBottom: 12,
  },
  transactionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  categoryIcon: {
    fontSize: 24,
    marginRight: 12,
  },
  transactionInfo: {
    flex: 1,
  },
  categoryName: {
    fontSize: 16,
    fontWeight: '600',
    color: '#111827',
  },
  accountName: {
    fontSize: 12,
    color: '#6B7280',
    marginTop: 2,
  },
  amount: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  income: {
    color: '#10B981',
  },
  expense: {
    color: '#EF4444',
  },
  date: {
    fontSize: 12,
    color: '#6B7280',
    marginTop: 4,
  },
  note: {
    fontSize: 14,
    color: '#6B7280',
    marginTop: 4,
  },
});

export default TransactionsScreen;

