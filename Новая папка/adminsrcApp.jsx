import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { auth, db } from './firebase';
import { signInWithEmailAndPassword, signOut } from 'firebase/auth';
import { collection, query, onSnapshot, doc, updateDoc, addDoc, getDocs } from 'firebase/firestore';
import { 
  Container, 
  AppBar, 
  Toolbar, 
  Typography, 
  Button, 
  Box, 
  CircularProgress,
  Alert,
  Snackbar
} from '@mui/material';

// Компоненты
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Teams from './components/Teams';
import AddPoints from './components/AddPoints';

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [teams, setTeams] = useState([]);
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' });

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((user) => {
      setUser(user);
      setLoading(false);
    });
    return unsubscribe;
  }, []);

  useEffect(() => {
    if (!user) return;

    const q = query(collection(db, 'teams'));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const teamsData = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
      setTeams(teamsData);
    });

    return unsubscribe;
  }, [user]);

  const handleLogin = async (email, password) => {
    try {
      await signInWithEmailAndPassword(auth, email, password);
      showSnackbar('Вход выполнен успешно', 'success');
    } catch (error) {
      showSnackbar('Ошибка входа: ' + error.message, 'error');
    }
  };

  const handleLogout = async () => {
    try {
      await signOut(auth);
      showSnackbar('Выход выполнен', 'info');
    } catch (error) {
      showSnackbar('Ошибка выхода', 'error');
    }
  };

  const showSnackbar = (message, severity) => {
    setSnackbar({ open: true, message, severity });
  };

  const handleCloseSnackbar = () => {
    setSnackbar({ ...snackbar, open: false });
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="100vh">
        <CircularProgress />
      </Box>
    );
  }

  if (!user) {
    return <Login onLogin={handleLogin} />;
  }

  return (
    <Router>
      <Box sx={{ flexGrow: 1 }}>
        <AppBar position="static">
          <Toolbar>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
              Панель организатора
            </Typography>
            <Button color="inherit" onClick={handleLogout}>
              Выйти
            </Button>
          </Toolbar>
        </AppBar>
        
        <Container maxWidth="lg" sx={{ mt: 4 }}>
          <Routes>
            <Route path="/" element={<Navigate to="/dashboard" />} />
            <Route path="/dashboard" element={<Dashboard teams={teams} />} />
            <Route path="/teams" element={<Teams teams={teams} />} />
            <Route 
              path="/add-points" 
              element={<AddPoints teams={teams} showSnackbar={showSnackbar} />} 
            />
          </Routes>
        </Container>
      </Box>

      <Snackbar 
        open={snackbar.open} 
        autoHideDuration={6000} 
        onClose={handleCloseSnackbar}
      >
        <Alert onClose={handleCloseSnackbar} severity={snackbar.severity}>
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Router>
  );
}

export default App;