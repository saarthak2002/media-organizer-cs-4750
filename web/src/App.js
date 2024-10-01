import './App.css';
import { AuthProvider } from './contexts/AuthContext';
import Dashboard from './components/Dashboard';

function App() {
  return (
    <AuthProvider>
      <Dashboard></Dashboard>
    </AuthProvider>
  );
}

export default App;
