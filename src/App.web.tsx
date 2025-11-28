import React, { useState } from 'react';
import { AppDataProvider } from './context/AppDataContext';
import HomeScreen from './screens/HomeScreen';
import TransactionsScreen from './screens/TransactionsScreen';
import BudgetScreen from './screens/BudgetScreen';
import SettingsScreen from './screens/SettingsScreen';
import './App.web.css';

const App: React.FC = () => {
  const [currentTab, setCurrentTab] = useState(0);

  const tabs = [
    { id: 0, label: 'Inicio', icon: '🏠', component: HomeScreen },
    { id: 1, label: 'Trans.', icon: '📊', component: TransactionsScreen },
    { id: 2, label: 'Presup.', icon: '📈', component: BudgetScreen },
    { id: 3, label: 'Config.', icon: '⚙️', component: SettingsScreen },
  ];

  const CurrentComponent = tabs[currentTab].component;

  return (
    <AppDataProvider>
      <div className="app">
        <div className="app-content">
          <CurrentComponent />
        </div>
        <div className="bottom-nav">
          {tabs.map(tab => (
            <button
              key={tab.id}
              className={`nav-item ${currentTab === tab.id ? 'active' : ''}`}
              onClick={() => setCurrentTab(tab.id)}
            >
              <span className="nav-icon">{tab.icon}</span>
              <span className="nav-label">{tab.label}</span>
            </button>
          ))}
        </div>
      </div>
    </AppDataProvider>
  );
};

export default App;

