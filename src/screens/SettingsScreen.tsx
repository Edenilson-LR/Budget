import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { useAppData } from '../context/AppDataContext';
import { CustomCard } from '../components/CustomCard';
import { CustomButton, ButtonVariant } from '../components/CustomButton';

const SettingsScreen: React.FC = () => {
  const { appData } = useAppData();

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Configuración</Text>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Categorías ({appData.categories.length})</Text>
        {appData.categories.map(category => (
          <CustomCard key={category.id} style={styles.itemCard}>
            <View style={styles.itemHeader}>
              <Text style={styles.itemIcon}>{category.icon}</Text>
              <View style={styles.itemInfo}>
                <Text style={styles.itemName}>{category.name}</Text>
                <Text style={styles.itemType}>
                  {category.type === 'income' ? 'Ingreso' : 'Gasto'}
                </Text>
              </View>
            </View>
          </CustomCard>
        ))}
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Cuentas ({appData.accounts.length})</Text>
        {appData.accounts.map(account => (
          <CustomCard key={account.id} style={styles.itemCard}>
            <View style={styles.itemHeader}>
              <View
                style={[styles.colorDot, { backgroundColor: account.color }]}
              />
              <View style={styles.itemInfo}>
                <Text style={styles.itemName}>{account.name}</Text>
                <Text style={styles.itemType}>{account.type}</Text>
              </View>
            </View>
          </CustomCard>
        ))}
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Monedas ({appData.currencies.length})</Text>
        {appData.currencies.map(currency => (
          <CustomCard key={currency.id} style={styles.itemCard}>
            <View style={styles.itemHeader}>
              <Text style={styles.currencySymbol}>{currency.symbol}</Text>
              <View style={styles.itemInfo}>
                <Text style={styles.itemName}>{currency.name}</Text>
                <Text style={styles.itemType}>{currency.code}</Text>
              </View>
            </View>
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
  section: {
    padding: 20,
    paddingTop: 0,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#111827',
    marginBottom: 12,
  },
  itemCard: {
    marginBottom: 12,
  },
  itemHeader: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  itemIcon: {
    fontSize: 24,
    marginRight: 12,
  },
  currencySymbol: {
    fontSize: 20,
    fontWeight: 'bold',
    marginRight: 12,
    width: 30,
  },
  colorDot: {
    width: 20,
    height: 20,
    borderRadius: 10,
    marginRight: 12,
  },
  itemInfo: {
    flex: 1,
  },
  itemName: {
    fontSize: 16,
    fontWeight: '600',
    color: '#111827',
  },
  itemType: {
    fontSize: 12,
    color: '#6B7280',
    marginTop: 2,
  },
});

export default SettingsScreen;

