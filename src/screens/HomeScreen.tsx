import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { useAppData } from '../context/AppDataContext';
import { CustomCard } from '../components/CustomCard';
import { formatCurrency } from '../utils/formatters';

const HomeScreen: React.FC = () => {
  const { appData } = useAppData();

  const totalBalance = appData.accounts.reduce(
    (sum, account) => sum + account.currentBalance,
    0
  );

  const monthlyIncome = appData.transactions
    .filter(t => t.type === 'income')
    .reduce((sum, t) => sum + t.amount, 0);

  const monthlyExpenses = appData.transactions
    .filter(t => t.type === 'expense')
    .reduce((sum, t) => sum + t.amount, 0);

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>SmartBudget</Text>
        <Text style={styles.subtitle}>Resumen Financiero</Text>
      </View>

      <CustomCard>
        <Text style={styles.cardLabel}>Balance Total</Text>
        <Text style={styles.balanceText}>
          {formatCurrency(totalBalance, 'USD', appData.currencies)}
        </Text>
      </CustomCard>

      <View style={styles.statsRow}>
        <CustomCard style={styles.statCard}>
          <Text style={styles.statLabel}>Ingresos</Text>
          <Text style={styles.statValue}>
            {formatCurrency(monthlyIncome, 'USD', appData.currencies)}
          </Text>
        </CustomCard>

        <CustomCard style={styles.statCard}>
          <Text style={styles.statLabel}>Gastos</Text>
          <Text style={styles.statValue}>
            {formatCurrency(monthlyExpenses, 'USD', appData.currencies)}
          </Text>
        </CustomCard>
      </View>

      <View style={styles.accountsSection}>
        <Text style={styles.sectionTitle}>Cuentas</Text>
        {appData.accounts.map(account => (
          <CustomCard key={account.id} style={styles.accountCard}>
            <View style={styles.accountHeader}>
              <Text style={styles.accountName}>{account.name}</Text>
              <View
                style={[styles.colorDot, { backgroundColor: account.color }]}
              />
            </View>
            <Text style={styles.accountBalance}>
              {formatCurrency(account.currentBalance, account.currency, appData.currencies)}
            </Text>
          </CustomCard>
        ))}
      </View>
    </ScrollView>
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
  subtitle: {
    fontSize: 16,
    color: '#6B7280',
    marginTop: 4,
  },
  cardLabel: {
    fontSize: 12,
    color: '#6B7280',
    marginBottom: 8,
  },
  balanceText: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#111827',
  },
  statsRow: {
    flexDirection: 'row',
    paddingHorizontal: 20,
    gap: 12,
  },
  statCard: {
    flex: 1,
  },
  statLabel: {
    fontSize: 12,
    color: '#6B7280',
    marginBottom: 4,
  },
  statValue: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#111827',
  },
  accountsSection: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#111827',
    marginBottom: 12,
  },
  accountCard: {
    marginBottom: 12,
  },
  accountHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  accountName: {
    fontSize: 16,
    fontWeight: '600',
    color: '#111827',
  },
  colorDot: {
    width: 12,
    height: 12,
    borderRadius: 6,
  },
  accountBalance: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#111827',
  },
});

export default HomeScreen;

