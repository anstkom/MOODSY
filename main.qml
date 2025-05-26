import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import "storage.js" as Storage

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 393
    height: 852
    title: "Mood Tracker"
    color: "#f5f5f5"
    
    // Инициализация хранилища при запуске
    Component.onCompleted: {
        Storage.initialize();
    }
    
    // Стек экранов для навигации
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: calendarView
    }
    
    // Главный экран с календарем
    Component {
        id: calendarView
        CalendarView {
            id: calendarViewItem
            onDaySelected: function(day) {
                // Открываем экран выбора настроения при нажатии на день
                stackView.push(moodSelectionView, {
                    selectedDay: day, 
                    selectedMonth: currentMonth, 
                    selectedYear: currentYear
                });
            }
        }
    }
    
    // Экран выбора настроения
    Component {
        id: moodSelectionView
        MoodSelectionView {
            onMoodSelected: function(day, month, year, moodValue, dogImageIndex) {
                // Сохраняем выбранное настроение
                Storage.saveMood(day, month, year, moodValue, dogImageIndex);
                
                // Возвращаемся на экран календаря
                stackView.pop();
                
                // Обновляем календарь, чтобы отразить изменения
                var calendarViewInstance = stackView.currentItem;
                if (calendarViewInstance && typeof calendarViewInstance.refreshCalendar === "function") {
                    calendarViewInstance.refreshCalendar();
                }
            }
            
            onCancelled: {
                // Возвращаемся на экран календаря без сохранения
                stackView.pop();
            }
        }
    }
}