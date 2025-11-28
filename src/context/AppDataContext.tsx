import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { AppData } from '../models/AppData';
import { loadData, saveData, getInitialData } from '../services/storageService';

interface AppDataContextType {
  appData: AppData;
  isLoading: boolean;
  updateData: (newData: AppData) => Promise<void>;
  refreshData: () => Promise<void>;
}

const AppDataContext = createContext<AppDataContextType | undefined>(undefined);

export const useAppData = () => {
  const context = useContext(AppDataContext);
  if (!context) {
    throw new Error('useAppData must be used within AppDataProvider');
  }
  return context;
};

interface AppDataProviderProps {
  children: ReactNode;
}

export const AppDataProvider: React.FC<AppDataProviderProps> = ({ children }) => {
  const [appData, setAppData] = useState<AppData>(getInitialData());
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    refreshData();
  }, []);

  const refreshData = async () => {
    setIsLoading(true);
    const data = await loadData();
    setAppData(data);
    setIsLoading(false);
  };

  const updateData = async (newData: AppData) => {
    setAppData(newData);
    await saveData(newData);
  };

  return (
    <AppDataContext.Provider value={{ appData, isLoading, updateData, refreshData }}>
      {children}
    </AppDataContext.Provider>
  );
};

