<script>
    // ================= КОНФИГУРАЦИЯ =================
    const CONFIG = {
        SCRIPT_URL: 'https://script.google.com/macros/s/AKfycbzdRxo0uM-BmfhTb-hUvUfzlIgK6gAkqXhjgQgcgwFKxWW2_e8ic6x8SPLc8evp4WBL9Q/exec',
        REFRESH_INTERVAL: 10000,
        VERSION: '2.0'
    };

    // ================= СОСТОЯНИЕ ПРИЛОЖЕНИЯ =================
    let currentState = {
        team: null,
        isAdmin: false,
        allTeams: [],
        rating: [],
        transactions: [],
        currentUser: null
    };

    // ================= ИНИЦИАЛИЗАЦИЯ =================
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Приложение загружается...');
        
        // Проверяем сохраненную сессию
        const savedTeam = localStorage.getItem('currentTeam');
        const savedAdmin = localStorage.getItem('isAdmin');
        const savedUser = localStorage.getItem('currentUser');
        
        if (savedTeam) {
            currentState.team = JSON.parse(savedTeam);
            showScreen('teamScreen');
            loadTeamData();
            startAutoRefresh();
        } else if (savedAdmin === 'true' && savedUser) {
            currentState.isAdmin = true;
            currentState.currentUser = JSON.parse(savedUser);
            showScreen('adminScreen');
            loadAdminData();
            startAutoRefresh();
        }
    });

    // ================= АВТОРИЗАЦИЯ =================
    async function loginAsTeam() {
        const code = document.getElementById('teamCode').value.trim().toUpperCase();
        
        if (!code) {
            showNotification('Введите код команды', 'error');
            return;
        }
        
        showLoading(true);
        
        try {
            console.log('Поиск команды с кодом:', code);
            const response = await fetch(`${CONFIG.SCRIPT_URL}?action=getTeamByCode&code=${encodeURIComponent(code)}`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            console.log('Ответ сервера:', result);
            
            if (result.success && result.data.team) {
                currentState.team = result.data.team;
                localStorage.setItem('currentTeam', JSON.stringify(currentState.team));
                showScreen('teamScreen');
                loadTeamData();
                startAutoRefresh();
                showNotification(`Добро пожаловать, ${currentState.team.name}!`, 'success');
            } else {
                showNotification(result.data?.error || 'Команда не найдена', 'error');
            }
        } catch (error) {
            console.error('Ошибка подключения:', error);
            showNotification('Ошибка подключения к серверу', 'error');
        } finally {
            showLoading(false);
        }
    }

    async function loginAsAdmin() {
        const password = document.getElementById('adminPassword').value;
        
        if (!password) {
            showNotification('Введите пароль', 'error');
            return;
        }
        
        showLoading(true);
        
        try {
            console.log('Проверка пароля администратора...');
            
            // Создаем FormData для отправки
            const formData = new FormData();
            formData.append('action', 'checkPassword');
            formData.append('password', password);
            
            // Отправляем как multipart/form-data (Google Apps Script лучше обрабатывает)
            const response = await fetch(CONFIG.SCRIPT_URL, {
                method: 'POST',
                body: formData
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            console.log('Ответ проверки пароля:', result);
            
            if (result.success && result.data.valid) {
                currentState.isAdmin = true;
                currentState.currentUser = {
                    name: 'Администратор',
                    role: 'admin',
                    timestamp: new Date().toISOString()
                };
                
                localStorage.setItem('isAdmin', 'true');
                localStorage.setItem('currentUser', JSON.stringify(currentState.currentUser));
                
                showScreen('adminScreen');
                loadAdminData();
                startAutoRefresh();
                
                showNotification('Панель организатора активна', 'success');
                
                // Очищаем поле пароля
                document.getElementById('adminPassword').value = '';
                
            } else {
                showNotification(result.data?.error || 'Неверный пароль', 'error');
            }
        } catch (error) {
            console.error('Ошибка подключения:', error);
            showNotification('Ошибка подключения: ' + error.message, 'error');
        } finally {
            showLoading(false);
        }
    }

    function logout() {
        currentState.team = null;
        currentState.isAdmin = false;
        currentState.currentUser = null;
        
        localStorage.removeItem('currentTeam');
        localStorage.removeItem('isAdmin');
        localStorage.removeItem('currentUser');
        
        stopAutoRefresh();
        showScreen('loginScreen');
        
        // Очищаем поля ввода
        document.getElementById('teamCode').value = '';
        document.getElementById('adminPassword').value = '';
        
        showNotification('Выход выполнен', 'info');
    }

    // ================= ЗАГРУЗКА ДАННЫХ =================
    async function loadTeamData() {
        if (!currentState.team) return;
        
        showLoading(true);
        
        try {
            console.log('Загрузка данных команды...');
            
            // Загружаем рейтинг
            const ratingResponse = await fetch(`${CONFIG.SCRIPT_URL}?action=getRating`);
            if (!ratingResponse.ok) throw new Error('Ошибка загрузки рейтинга');
            
            const ratingResult = await ratingResponse.json();
            console.log('Рейтинг:', ratingResult);
            
            if (ratingResult.success) {
                currentState.rating = ratingResult.data.rating;
                updateTeamDashboard();
            }
            
            // Загружаем историю
            const historyResponse = await fetch(`${CONFIG.SCRIPT_URL}?action=getTransactions&teamId=${currentState.team.id}`);
            if (!historyResponse.ok) throw new Error('Ошибка загрузки истории');
            
            const historyResult = await historyResponse.json();
            console.log('История:', historyResult);
            
            if (historyResult.success) {
                currentState.transactions = historyResult.data.transactions || [];
                updateHistoryTable();
            }
            
        } catch (error) {
            console.error('Ошибка загрузки данных:', error);
            showNotification('Ошибка загрузки данных', 'error');
        } finally {
            showLoading(false);
        }
    }

    async function loadAdminData() {
        showLoading(true);
        
        try {
            console.log('Загрузка данных администратора...');
            
            // Загружаем все команды
            const teamsResponse = await fetch(`${CONFIG.SCRIPT_URL}?action=getTeams`);
            if (!teamsResponse.ok) throw new Error('Ошибка загрузки команд');
            
            const teamsResult = await teamsResponse.json();
            console.log('Команды:', teamsResult);
            
            if (teamsResult.success) {
                currentState.allTeams = teamsResult.data.teams || [];
                updateAdminTables();
            }
            
            // Загружаем последние транзакции
            const transResponse = await fetch(`${CONFIG.SCRIPT_URL}?action=getTransactions`);
            if (!transResponse.ok) throw new Error('Ошибка загрузки транзакций');
            
            const transResult = await transResponse.json();
            console.log('Транзакции:', transResult);
            
            if (transResult.success) {
                updateRecentTransactions(transResult.data.transactions || []);
            }
            
        } catch (error) {
            console.error('Ошибка загрузки данных админа:', error);
            showNotification('Ошибка загрузки данных', 'error');
        } finally {
            showLoading(false);
        }
    }

    // ================= ОБНОВЛЕНИЕ ИНТЕРФЕЙСА =================
    function updateTeamDashboard() {
        if (!currentState.team) return;
        
        // Обновляем заголовок
        document.getElementById('teamNameDisplay').textContent = currentState.team.name;
        document.getElementById('teamScoreDisplay').textContent = `${currentState.team.score || 0} баллов`;
        
        // Обновляем статистику
        document.getElementById('myScore').textContent = currentState.team.score || 0;
        
        // Находим позицию в рейтинге
        let position = 0;
        if (currentState.rating && currentState.rating.length > 0) {
            position = currentState.rating.findIndex(team => team.id === currentState.team.id) + 1;
            if (position === 0) position = currentState.rating.length + 1;
        }
        
        document.getElementById('myPosition').textContent = position > 0 ? position : '-';
        document.getElementById('totalTeams').textContent = currentState.rating ? currentState.rating.length : 0;
        
        // Обновляем таблицу рейтинга
        updateRatingTable();
    }

    function updateHistoryTable() {
        const container = document.getElementById('historyTable');
        
        if (!currentState.transactions || currentState.transactions.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-history"></i>
                    <p>История начислений пока пуста</p>
                </div>
            `;
            return;
        }
        
        let html = '<table><thead><tr><th>Время</th><th>Баллы</th><th>Причина</th><th>Кто начислил</th></tr></thead><tbody>';
        
        currentState.transactions.slice(0, 10).forEach(trans => {
            const time = trans.timestamp ? 
                new Date(trans.timestamp).toLocaleTimeString('ru-RU', {
                    hour: '2-digit',
                    minute: '2-digit',
                    day: '2-digit',
                    month: '2-digit'
                }) : '--:--';
            
            const pointsClass = trans.points > 0 ? 'badge-success' : 'badge-danger';
            const pointsSign = trans.points > 0 ? '+' : '';
            
            html += `
                <tr>
                    <td>${time}</td>
                    <td><span class="badge ${pointsClass}">${pointsSign}${trans.points || 0}</span></td>
                    <td>${trans.reason || ''}</td>
                    <td>${trans.moderator || ''}</td>
                </tr>
            `;
        });
        
        html += '</tbody></table>';
        container.innerHTML = html;
    }

    function updateRatingTable() {
        const container = document.getElementById('ratingTable');
        
        if (!currentState.rating || currentState.rating.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-trophy"></i>
                    <p>Рейтинг пока пуст</p>
                </div>
            `;
            return;
        }
        
        let html = '<table><thead><tr><th>Место</th><th>Команда</th><th>Баллы</th><th>Отставание</th></tr></thead><tbody>';
        
        currentState.rating.forEach((team, index) => {
            const isCurrent = currentState.team && team.id === currentState.team.id;
            const rowClass = isCurrent ? 'style="background-color: #e3f2fd;"' : '';
            const medal = index < 3 ? ['🥇', '🥈', '🥉'][index] : `${index + 1}.`;
            
            // Рассчитываем отставание от лидера
            const leaderScore = currentState.rating[0].score || 0;
            const gap = leaderScore - (team.score || 0);
            
            html += `
                <tr ${rowClass}>
                    <td><strong>${medal}</strong></td>
                    <td>${team.name || 'Без названия'} ${isCurrent ? '<span class="badge badge-warning">Вы</span>' : ''}</td>
                    <td><strong>${team.score || 0}</strong></td>
                    <td>${gap > 0 ? `-${gap}` : 'Лидер'}</td>
                </tr>
            `;
        });
        
        html += '</tbody></table>';
        container.innerHTML = html;
    }

    function updateAdminTables() {
        // Обновляем таблицу всех команд
        const tbody = document.getElementById('teamsTableBody');
        const quickSelect = document.getElementById('quickTeamSelect');
        const manualSelect = document.getElementById('manualTeamSelect');
        
        tbody.innerHTML = '';
        quickSelect.innerHTML = '<option value="">Выберите команду</option>';
        manualSelect.innerHTML = '<option value="">Выберите команду</option>';
        
        if (!currentState.allTeams || currentState.allTeams.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align: center;">Нет команд</td></tr>';
            return;
        }
        
        currentState.allTeams.forEach(team => {
            // Добавляем в таблицу
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${team.id || ''}</td>
                <td><strong>${team.name || 'Без названия'}</strong></td>
                <td><span class="badge ${(team.score || 0) >= 100 ? 'badge-success' : 'badge-warning'}">${team.score || 0}</span></td>
                <td><code>${team.code || ''}</code></td>
                <td>
                    <button onclick="editTeam(${team.id})" class="btn btn-primary" style="padding: 5px 10px; margin-right: 5px;">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button onclick="addPointsToTeam(${team.id})" class="btn btn-success" style="padding: 5px 10px;">
                        <i class="fas fa-plus"></i>
                    </button>
                </td>
            `;
            tbody.appendChild(row);
            
            // Добавляем в выпадающие списки
            const option = `<option value="${team.id}">${team.name} (${team.score || 0} баллов)</option>`;
            quickSelect.innerHTML += option;
            manualSelect.innerHTML += option;
        });
    }

    function updateRecentTransactions(transactions) {
        const tbody = document.getElementById('recentTransactions');
        
        if (!transactions || transactions.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align: center;">Нет операций</td></tr>';
            return;
        }
        
        let html = '';
        
        transactions.slice(0, 10).forEach(trans => {
            const time = trans.timestamp ? 
                new Date(trans.timestamp).toLocaleTimeString('ru-RU', {
                    hour: '2-digit',
                    minute: '2-digit'
                }) : '--:--';
            
            const team = currentState.allTeams.find(t => t.id == trans.teamId);
            const teamName = team ? team.name : `ID: ${trans.teamId}`;
            
            html += `
                <tr>
                    <td>${time}</td>
                    <td>${teamName}</td>
                    <td><span class="badge ${trans.points > 0 ? 'badge-success' : 'badge-danger'}">${trans.points > 0 ? '+' : ''}${trans.points || 0}</span></td>
                    <td>${trans.reason || ''}</td>
                    <td>${trans.moderator || ''}</td>
                </tr>
            `;
        });
        
        tbody.innerHTML = html;
    }

    // ================= ОПЕРАЦИИ ОРГАНИЗАТОРА =================
    function quickAddPoints(points, reason) {
        const teamId = document.getElementById('quickTeamSelect').value;
        
        if (!teamId) {
            showNotification('Сначала выберите команду', 'warning');
            return;
        }
        
        document.getElementById('manualTeamSelect').value = teamId;
        document.getElementById('pointsInput').value = points;
        document.getElementById('reasonInput').value = reason;
        
        manualAddPoints();
    }

    async function manualAddPoints() {
        const teamId = document.getElementById('manualTeamSelect').value;
        const points = parseInt(document.getElementById('pointsInput').value);
        const reason = document.getElementById('reasonInput').value.trim();
        const moderator = document.getElementById('moderatorInput').value.trim() || 'Администратор';
        const password = document.getElementById('adminPassword').value;
        
        if (!teamId || isNaN(points) || !reason) {
            showNotification('Заполните все обязательные поля', 'error');
            return;
        }
        
        if (!password) {
            showNotification('Требуется пароль организатора', 'error');
            return;
        }
        
        showLoading(true);
        
        try {
            console.log('Начисление баллов команде:', teamId, 'баллы:', points);
            
            const formData = new FormData();
            formData.append('action', 'addPoints');
            formData.append('teamId', teamId);
            formData.append('points', points);
            formData.append('reason', reason);
            formData.append('moderator', moderator);
            formData.append('password', password);
            
            const response = await fetch(CONFIG.SCRIPT_URL, {
                method: 'POST',
                body: formData
            });
            
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            
            const result = await response.json();
            console.log('Результат начисления:', result);
            
            if (result.success) {
                showNotification(result.data?.message || 'Баллы начислены успешно', 'success');
                
                // Сбрасываем поля
                document.getElementById('pointsInput').value = '';
                document.getElementById('reasonInput').value = '';
                
                // Обновляем данные
                loadAdminData();
            } else {
                showNotification(result.data?.error || 'Ошибка при начислении баллов', 'error');
            }
        } catch (error) {
            console.error('Ошибка:', error);
            showNotification('Ошибка сети: ' + error.message, 'error');
        } finally {
            showLoading(false);
        }
    }

    function showAddTeamModal() {
        document.getElementById('addTeamModal').classList.add('active');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove('active');
    }

    function editTeam(teamId) {
        const team = currentState.allTeams.find(t => t.id == teamId);
        if (team) {
            document.getElementById('newTeamName').value = team.name || '';
            document.getElementById('newTeamCode').value = team.code || '';
            document.getElementById('newTeamContact').value = team.contact || '';
            document.getElementById('addTeamModal').classList.add('active');
        }
    }

    function addPointsToTeam(teamId) {
        const select = document.getElementById('quickTeamSelect');
        const option = Array.from(select.options).find(opt => opt.value == teamId);
        
        if (option) {
            select.value = teamId;
            showNotification(`Выбрана команда: ${option.text}`, 'info');
        } else {
            showNotification('Команда не найдена в списке', 'error');
        }
    }

    // ================= УТИЛИТЫ =================
    function showScreen(screenId) {
        console.log('Переход на экран:', screenId);
        
        document.querySelectorAll('.screen').forEach(screen => {
            screen.classList.remove('active');
        });
        
        const targetScreen = document.getElementById(screenId);
        if (targetScreen) {
            targetScreen.classList.add('active');
        } else {
            console.error('Экран не найден:', screenId);
        }
    }

    function showNotification(message, type = 'info') {
        console.log('Уведомление:', type, message);
        
        const notification = document.getElementById('notification');
        if (!notification) {
            console.error('Элемент уведомления не найден');
            return;
        }
        
        notification.textContent = message;
        notification.className = `notification ${type}`;
        notification.style.display = 'block';
        
        setTimeout(() => {
            notification.style.display = 'none';
        }, 3000);
    }

    function showLoading(show) {
        if (show) {
            document.body.style.cursor = 'wait';
            // Можно добавить спиннер
        } else {
            document.body.style.cursor = 'default';
        }
    }

    function refreshData() {
        console.log('Обновление данных...');
        
        if (currentState.team) {
            loadTeamData();
            showNotification('Данные команды обновлены', 'success');
        } else if (currentState.isAdmin) {
            loadAdminData();
            showNotification('Данные организатора обновлены', 'success');
        }
    }

    function startAutoRefresh() {
        stopAutoRefresh();
        console.log('Автообновление запущено с интервалом:', CONFIG.REFRESH_INTERVAL);
        
        window.refreshInterval = setInterval(() => {
            refreshData();
        }, CONFIG.REFRESH_INTERVAL);
    }

    function stopAutoRefresh() {
        if (window.refreshInterval) {
            clearInterval(window.refreshInterval);
            window.refreshInterval = null;
            console.log('Автообновление остановлено');
        }
    }

    // ================= PWA ФУНКЦИИ =================
    if ('serviceWorker' in navigator) {
        window.addEventListener('load', () => {
            navigator.serviceWorker.register('/sw.js').catch(error => {
                console.log('Service Worker не зарегистрирован:', error);
            });
        });
    }

    // Делаем функции глобальными для кнопок
    window.loginAsTeam = loginAsTeam;
    window.loginAsAdmin = loginAsAdmin;
    window.logout = logout;
    window.refreshData = refreshData;
    window.quickAddPoints = quickAddPoints;
    window.manualAddPoints = manualAddPoints;
    window.showAddTeamModal = showAddTeamModal;
    window.closeModal = closeModal;
    window.addPointsToTeam = addPointsToTeam;
    window.editTeam = editTeam;
</script>