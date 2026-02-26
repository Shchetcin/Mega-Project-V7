const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Автоматическое создание пользователя при вводе кода
exports.registerWithCode = functions.https.onCall(async (data, context) => {
  const code = data.code;
  
  // Проверяем код в коллекции регистрационных кодов
  const codeDoc = await admin.firestore()
    .collection('registration_codes')
    .doc(code)
    .get();
    
  if (!codeDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Неверный код');
  }
  
  const codeData = codeDoc.data();
  
  // Создаем пользователя
  const userRecord = await admin.auth().createUser({
    email: codeData.email,
    displayName: codeData.name,
    password: Math.random().toString(36).slice(-8) // Генерация случайного пароля
  });
  
  // Добавляем пользователя в команду
  await admin.firestore()
    .collection('teams')
    .doc(codeData.teamId)
    .update({
      members: admin.firestore.FieldValue.arrayUnion(userRecord.uid)
    });
    
  // Удаляем использованный код
  await codeDoc.ref.delete();
  
  return {
    success: true,
    userId: userRecord.uid,
    teamId: codeData.teamId
  };
});

// Отправка push-уведомлений при начислении баллов
exports.sendScoreNotification = functions.firestore
  .document('score_transactions/{transactionId}')
  .onCreate(async (snapshot, context) => {
    const transaction = snapshot.data();
    
    // Получаем список участников команды
    const teamDoc = await admin.firestore()
      .collection('teams')
      .doc(transaction.teamId)
      .get();
      
    const teamData = teamDoc.data();
    const members = teamData.members || [];
    
    // Получаем токены устройств всех участников
    const tokensSnapshot = await admin.firestore()
      .collection('device_tokens')
      .where('userId', 'in', members)
      .get();
      
    const tokens = tokensSnapshot.docs.map(doc => doc.data().token);
    
    if (tokens.length === 0) return;
    
    const message = {
      notification: {
        title: 'Новые баллы!',
        body: `${transaction.description}: ${transaction.points > 0 ? '+' : ''}${transaction.points} баллов`
      },
      data: {
        teamId: transaction.teamId,
        points: transaction.points.toString(),
        type: 'score_update'
      },
      tokens: tokens
    };
    
    try {
      await admin.messaging().sendMulticast(message);
    } catch (error) {
      console.error('Error sending notification:', error);
    }
  });