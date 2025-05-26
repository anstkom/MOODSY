import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../storage.js" as Storage

Page {
    id: root
    
    // Сигнал при выборе дня
    signal daySelected(int day)
    
    // Названия месяцев
    property var monthNames: ["january", "february", "march", "april", "may", "june", 
                             "july", "august", "september", "october", "november", "december"]
    
    // Текущие дата и время
    property int currentMonth: new Date().getMonth()
    property int currentYear: new Date().getFullYear()
    
    // Сегодняшняя дата для выделения
    property int today: new Date().getDate()
    property int todayMonth: new Date().getMonth()
    property int todayYear: new Date().getFullYear()
    
    // Шрифты приложения
    property string monthFont: "EoSD U.N. Owen Hand"
    property string dayFont: "VividSans"
    
    // Обновление календаря при смене месяца/года
    onCurrentMonthChanged: calendarGrid.updateCalendar()
    onCurrentYearChanged: calendarGrid.updateCalendar()
    
    // Функция обновления календаря извне
    function refreshCalendar() {
        calendarGrid.updateCalendar();
    }
    
    // Определение цвета фона по сезонам
    function getSeasonColor() {
        switch(currentMonth) {
            case 11: case 0: case 1:
                return "#BED5F2"; // Зима
            case 2: case 3: case 4:
                return "#e4e2ff"; // Весна
            case 5: case 6: case 7:
                return "#C7DAA1"; // Лето
            case 8: case 9: case 10:
                return "#cedaa1"; // Осень
            default:
                return "#C7DAA1";
        }
    }
    
    // Фоновый прямоугольник с сезонным цветом
    Rectangle {
        anchors.fill: parent
        color: getSeasonColor()
        
        // Плавная анимация смены цвета
        Behavior on color {
            ColorAnimation { duration: 300 }
        }
    }
    
    // Основной макет страницы
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 17
        spacing: 10
        
        // Верхняя панель с навигацией
        Item {
            Layout.fillWidth: true
            height: 90
            
            RowLayout {
                anchors.fill: parent
                spacing: 10
                
                // Кнопка "предыдущий месяц"
                Button {
                    text: "←"
                    width: 25
                    height: 25
                    background: Rectangle {
                        radius: 10
                        color: "#FDFDF5"
                        border.color: "#583E3F"
                        border.width: 0
                        
                        // Тень для объемности
                        Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: 2
                            anchors.leftMargin: 2
                            radius: 10
                            color: "#00000020"
                            z: -1
                        }
                    }
                    
                    contentItem: Text {
                        text: "←"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#583E3F"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    // Логика переключения месяца назад
                    onClicked: {
                        if (currentMonth === 0) {
                            currentMonth = 11;
                            currentYear--;
                        } else {
                            currentMonth--;
                        }
                    }
                    
                    // Hover-эффект при наведении
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.scale = 1.1
                        onExited: parent.scale = 1.0
                        onClicked: parent.clicked()
                        cursorShape: Qt.PointingHandCursor
                    }
                    
                    Behavior on scale {
                        NumberAnimation { duration: 150 }
                    }
                }
                
                // Название текущего месяца
                Text {
                    Layout.fillWidth: true
                    text: monthNames[currentMonth]
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 32
                    font.family: monthFont
                    color: "#583E3F"
                }
                
                // Кнопка "следующий месяц"
                Button {
                    text: "→"
                    width: 25
                    height: 25
                    background: Rectangle {
                        radius: 10
                        color: "#FDFDF5"
                        border.color: "#583E3F"
                        border.width: 0
                        
                        // Тень для объемности
                        Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: 2
                            anchors.leftMargin: 2
                            radius: 10
                            color: "#00000020"
                            z: -1
                        }
                    }
                    
                    contentItem: Text {
                        text: "→"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#583E3F"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    // Логика переключения месяца вперед
                    onClicked: {
                        if (currentMonth === 11) {
                            currentMonth = 0;
                            currentYear++;
                        } else {
                            currentMonth++;
                        }
                    }
                    
                    // Hover-эффект при наведении
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.scale = 1.1
                        onExited: parent.scale = 1.0
                        onClicked: parent.clicked()
                        cursorShape: Qt.PointingHandCursor
                    }
                    
                    Behavior on scale {
                        NumberAnimation { duration: 150 }
                    }
                }
            }
        }
        
        // Сетка календаря с днями
        GridLayout {
            id: calendarGrid
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            columns: 5
            rowSpacing: 0
            columnSpacing: 0
            
            // Шаблон для ячейки дня
            Component {
                id: dayDelegate
                
                Rectangle {
                    // Свойства дня
                    property int day: modelData
                    property bool isCurrentDay: day === today && currentMonth === todayMonth && currentYear === todayYear
                    property var moodData: Storage.getMood(day, currentMonth, currentYear)
                    property bool hasMood: moodData !== null
                    
                    // Фиксированные размеры ячейки
                    width: 70
                    height: 100
                    radius: 10
                    color: isCurrentDay ? "#F7EAD9" : "#FDFDF5"
                    border.color: "#C7DAA1"
                    border.width: 1
                    
                    // Анимация масштабирования при hover
                    Behavior on scale { 
                        NumberAnimation { duration: 100 } 
                    }
                    
                    // Содержимое ячейки дня
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 2
                        
                        // Номер дня
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: day
                            font.pixelSize: 20
                            font.family: dayFont
                            font.bold: isCurrentDay
                            color: "#333333"
                        }
                        
                        // Область для изображения собачки
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            // Изображение собачки (если есть настроение)
                            Image {
                                anchors.centerIn: parent
                                visible: hasMood
                                width: 60
                                height: 60
                                source: {
                                    if (hasMood) {
                                        return "../images/dogs/dog_" + moodData.dogImageIndex + ".png";
                                    } else {
                                        return "";
                                    }
                                }
                                
                                // Индикатор настроения с числом
                                Rectangle {
                                    visible: hasMood
                                    width: 17
                                    height: 17
                                    radius: 20
                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    color: "#FDFDF5"
                                    border.color: "#583E3F"
                                    border.width: 1
                                    
                                    // Число настроения
                                    Text {
                                        anchors.centerIn: parent
                                        text: hasMood ? moodData.moodValue : ""
                                        font.pixelSize: 12
                                        font.family: dayFont
                                        font.bold: true
                                        color: "#583E3F"
                                    }
                                    
                                    // Мигание для сегодняшнего дня
                                    SequentialAnimation on opacity {
                                        running: isCurrentDay && hasMood
                                        loops: Animation.Infinite
                                        NumberAnimation { to: 0.6; duration: 1000 }
                                        NumberAnimation { to: 1.0; duration: 1000 }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Обработка кликов и hover-эффектов
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        
                        onEntered: parent.scale = 1.05
                        onExited: parent.scale = 1.0
                        
                        onClicked: {
                            root.daySelected(day);
                        }
                    }
                }
            }
            
            // Количество дней в текущем месяце
            property int daysInMonth: new Date(currentYear, currentMonth + 1, 0).getDate()
            
            Component.onCompleted: updateCalendar()
            
            // Функция обновления календаря
            function updateCalendar() {
                // Удаляем старые ячейки
                for (var i = calendarGrid.children.length - 1; i >= 0; i--) {
                    calendarGrid.children[i].destroy();
                }
                
                // Создаем новые ячейки для текущего месяца
                for (var day = 1; day <= daysInMonth; day++) {
                    var delegateObject = dayDelegate.createObject(calendarGrid, { "day": day });
                }
            }
        }

        // Отображение текущего года внизу
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: currentYear.toString()
            font.pixelSize: 24
            font.family: monthFont
            color: "#FDFDF5"
            style: Text.Outline
            styleColor: "#583E3F"
        }
    }
}
