import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { useAppData } from '../context/AppDataContext';
import { CustomCard } from '../components/CustomCard';
import { formatCurrency } from '../utils/formatters';

const BudgetScreen: React.FC = () => {
  const { appData } = useAppData();

  const getCategorySpending = (categoryId: string) => {
    return appData.transactions
      .filter(t => t.categoryId === categoryId && t.type === 'expense')
      .reduce((sum, t) => sum + t.amount, 0);
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Presupuesto</Text>
        <Text style={styles.subtitle}>Gastos por categoría</Text>
      </View>

      {appData.categories
        .filter(c => c.type === 'expense' && c.budgetLimit > 0)
        .map(category => {
          const spent = getCategorySpending(category.id);
          const percentage = (spent / category.budgetLimit) * 100;
          const currency = appData.currencies.find(cur => cur.code === 'USD') || appData.currencies[0];

          return (
            <CustomCard key={category.id} style={styles.budgetCard}>
              <View style={styles.categoryHeader}>
                <Text style={styles.categoryIcon}>{category.icon}</Text>
                <View style={styles.categoryInfo}>
                  <Text style={styles.categoryName}>{category.name}</Text>
                  <Text style={styles.budgetLimit}>
                    {formatCurrency(category.budgetLimit, currency?.code || 'USD', appData.currencies)}
                  </Text>
                </View>
              </View>
              <View style={styles.progressBar}>
                <View
                  style={[
                    styles.progressFill,
                    {
                      width: `${Math.min(percentage, 100)}%`,
                      backgroundColor: percentage > 100 ? '#EF4444' : category.color,
                    },
                  ]}
                />
              </View>
              <View style={styles.budgetStats}>
                <Text style={styles.spentText}>
                  Gastado: {formatCurrency(spent, currency?.code || 'USD', appData.currencies)}
                </Text>
                <Text style={styles.remainingText}>
                  Restante: {formatCurrency(
                    Math.max(0, category.budgetLimit - spent),
                    currency?.code || 'USD',
                    appData.currencies
                  )}
                </Text>
              </View>
            </CustomCard>
          );
        })}
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
  budgetCard: {
    margin: 20,
    marginTop: 0,
    marginBottom: 12,
  },
  categoryHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  categoryIcon: {
    fontSize: 32,
    marginRight: 12,
  },
  categoryInfo: {
    flex: 1,
  },
  categoryName: {
    fontSize: 18,
    fontWeight: '600',
    color: '#111827',
  },
  budgetLimit: {
    fontSize: 14,
    color: '#6B7280',
    marginTop: 2,
  },
  progressBar: {
    height: 8,
    backgroundColor: '#E5E7EB',
    borderRadius: 4,
    overflow: 'hidden',
    marginBottom: 12,
  },
  progressFill: {
    height: '100%',
    borderRadius: 4,
  },
  budgetStats: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  spentText: {
    fontSize: 12,
    color: '#6B7280',
  },
  remainingText: {
    fontSize: 12,
    color: '#10B981',
    fontWeight: '600',
  },
});

export default BudgetScreen;

