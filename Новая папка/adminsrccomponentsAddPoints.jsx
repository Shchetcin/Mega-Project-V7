import React, { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  TextField,
  Button,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Grid,
  Typography,
  Chip,
  Paper
} from '@mui/material';
import { db } from '../firebase';
import { collection, addDoc, updateDoc, doc, Timestamp } from 'firebase/firestore';

const presetActions = [
  { label: 'Активность на лекции', points: 10 },
  { label: 'Правильный ответ', points: 20 },
  { label: 'Решение кейса', points: 50 },
  { label: 'Лидерство в группе', points: 30 },
  { label: 'Креативный подход', points: 40 },
  { label: 'Помощь другим', points: 15 },
];

function AddPoints({ teams, showSnackbar }) {
  const [selectedTeam, setSelectedTeam] = useState('');
  const [points, setPoints] = useState('');
  const [description, setDescription] = useState('');
  const [loading, setLoading] = useState(false);

  const handlePresetClick = (action) => {
    setPoints(action.points);
    setDescription(action.label);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!selectedTeam || !points || !description) {
      showSnackbar('Заполните все поля', 'error');
      return;
    }

    setLoading(true);
    try {
      const team = teams.find(t => t.id === selectedTeam);
      
      // Создаем транзакцию
      await addDoc(collection(db, 'score_transactions'), {
        teamId: selectedTeam,
        teamName: team.name,
        points: parseInt(points),
        description: description,
        category: 'manual',
        timestamp: Timestamp.now(),
        addedBy: 'admin',
      });

      // Обновляем общий счет команды
      const teamRef = doc(db, 'teams', selectedTeam);
      await updateDoc(teamRef, {
        score: team.score + parseInt(points)
      });

      showSnackbar(`Начислено ${points} баллов команде "${team.name}"`, 'success');
      
      // Сброс формы
      setSelectedTeam('');
      setPoints('');
      setDescription('');
      
    } catch (error) {
      showSnackbar('Ошибка: ' + error.message, 'error');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        Начисление баллов
      </Typography>
      
      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <Card>
            <CardContent>
              <form onSubmit={handleSubmit}>
                <FormControl fullWidth sx={{ mb: 3 }}>
                  <InputLabel>Команда</InputLabel>
                  <Select
                    value={selectedTeam}
                    label="Команда"
                    onChange={(e) => setSelectedTeam(e.target.value)}
                    required
                  >
                    {teams.map((team) => (
                      <MenuItem key={team.id} value={team.id}>
                        {team.name} ({team.score} баллов)
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>

                <TextField
                  fullWidth
                  label="Баллы"
                  type="number"
                  value={points}
                  onChange={(e) => setPoints(e.target.value)}
                  sx={{ mb: 3 }}
                  required
                />

                <TextField
                  fullWidth
                  label="Описание"
                  multiline
                  rows={3}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  sx={{ mb: 3 }}
                  required
                />

                <Button
                  type="submit"
                  variant="contained"
                  size="large"
                  disabled={loading}
                  fullWidth
                >
                  {loading ? 'Начисление...' : 'Начислить баллы'}
                </Button>
              </form>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={4}>
          <Paper sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Быстрые действия
            </Typography>
            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
              {presetActions.map((action, index) => (
                <Chip
                  key={index}
                  label={`${action.label} (+${action.points})`}
                  onClick={() => handlePresetClick(action)}
                  color="primary"
                  variant="outlined"
                  sx={{ mb: 1 }}
                />
              ))}
            </Box>
            
            <Typography variant="h6" sx={{ mt: 3, mb: 2 }}>
              Последние операции
            </Typography>
            {/* Здесь можно добавить список последних операций */}
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
}

export default AddPoints;