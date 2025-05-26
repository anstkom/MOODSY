.pragma library

// Используем LocalStorage для хранения данных
.import QtQuick.LocalStorage 2.15 as LS

// Ссылка на базу данных
var db;

// Инициализация базы данных
function initialize() {
    db = LS.LocalStorage.openDatabaseSync("MoodTrackerDB", "1.0", "Mood Tracker Database", 1000000);
    
    // Создаем таблицу для настроений, если она еще не существует
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS moods(\
            id INTEGER PRIMARY KEY AUTOINCREMENT,\
            day INTEGER,\
            month INTEGER,\
            year INTEGER,\
            mood_value INTEGER,\
            dog_image_index INTEGER,\
            UNIQUE(day, month, year)\
        )');
    });
}

// Сохранение настроения для конкретного дня
function saveMood(day, month, year, moodValue, dogImageIndex) {
    if (!db) {
        initialize();
    }
    
    db.transaction(function(tx) {
        // Используем REPLACE для обновления существующих записей
        tx.executeSql('REPLACE INTO moods(day, month, year, mood_value, dog_image_index) \
                      VALUES(?, ?, ?, ?, ?)',
                      [day, month, year, moodValue, dogImageIndex]);
    });
}

// Получение настроения для конкретного дня
function getMood(day, month, year) {
    if (!db) {
        initialize();
    }
    
    var result = null;
    
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT mood_value, dog_image_index FROM moods \
                               WHERE day = ? AND month = ? AND year = ?',
                              [day, month, year]);
        
        if (rs.rows.length > 0) {
            result = {
                moodValue: rs.rows.item(0).mood_value,
                dogImageIndex: rs.rows.item(0).dog_image_index
            };
        }
    });
    
    return result;
}

// Получение всех записей за определенный месяц
function getMonthMoods(month, year) {
    if (!db) {
        initialize();
    }
    
    var result = [];
    
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT day, mood_value, dog_image_index FROM moods \
                               WHERE month = ? AND year = ?',
                              [month, year]);
        
        for (var i = 0; i < rs.rows.length; i++) {
            result.push({
                day: rs.rows.item(i).day,
                moodValue: rs.rows.item(i).mood_value,
                dogImageIndex: rs.rows.item(i).dog_image_index
            });
        }
    });
    
    return result;
}

// Удаление настроения для конкретного дня
function deleteMood(day, month, year) {
    if (!db) {
        initialize();
    }
    
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM moods WHERE day = ? AND month = ? AND year = ?',
                     [day, month, year]);
    });
}