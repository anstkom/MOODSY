import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: root

    // Параметры выбранного дня
    property int selectedDay: 1
    property int selectedMonth: 0
    property int selectedYear: 2025

    // Состояние выбора
    property int moodValue: 5
    property int selectedDogIndex: -1

    // Шрифты приложения
    property string monthFont: "EoSD U.N. Owen Hand"
    property string dayFont: "VividSans"

    // Сигналы для взаимодействия с родительским компонентом
    signal moodSelected(int day, int month, int year, int moodValue, int dogImageIndex)
    signal cancelled()

    // Количество доступных изображений собачек
    property int dogImagesCount: 8

    // Фоновый цвет страницы
    Rectangle {
        anchors.fill: parent
        color: "#C7DAA1"
    }

    // Главный заголовок страницы
    Text {
        id: mainTitle
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 79  
        }
        text: "how are you?"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 36
        font.family: monthFont
        color: "#FDFDF5"
        style: Text.Outline
        styleColor: "#583E3F"
    }

    // Белый фон для основного контента
    Rectangle {
        id: whiteBackground
        anchors {
            top: mainTitle.bottom
            left: parent.left
            right: parent.right
            bottom: doneButtonBackground.top
            topMargin: 40
            leftMargin: 17
            rightMargin: 17
            bottomMargin: 50  
        }
        color: "#FDFDF5"
        radius: 10
    }

    // Основной макет с элементами управления
    ColumnLayout {
        anchors {
            top: mainTitle.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 40
            leftMargin: 25
            rightMargin: 25
            bottomMargin: 30
        }
        spacing: 40

        // Слайдер для выбора настроения (1-10)
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            
            // Линия слайдера
            Rectangle {
                id: sliderLine
                anchors.centerIn: parent
                width: 309
                height: 2
                color: "#583E3F"
            }

            // Ручка слайдера
            Rectangle {
                id: sliderHandle
                width: 18
                height: 18
                radius: 9
                color: "#583E3F"
                anchors.verticalCenter: sliderLine.verticalCenter
                x: sliderLine.x + (sliderLine.width - width) * (moodValue - 1) / 9

                // Обработка перетаскивания
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -10
                    drag {
                        target: parent
                        axis: Drag.XAxis
                        minimumX: sliderLine.x
                        maximumX: sliderLine.x + sliderLine.width - sliderHandle.width
                    }

                    // Обновление значения при перетаскивании
                    onPositionChanged: {
                        if (drag.active) {
                            const relativeX = sliderHandle.x - sliderLine.x;
                            const newValue = Math.round(relativeX / (sliderLine.width - sliderHandle.width) * 9) + 1;
                            if (newValue >= 1 && newValue <= 10) {
                                moodValue = newValue;
                            }
                        }
                    }
                }
            }

            // Числовые метки под слайдером (1-10)
            Row {
                id: valueLabels
                anchors {
                    horizontalCenter: sliderLine.horizontalCenter
                    top: sliderLine.bottom
                    topMargin: 15
                }
                width: sliderLine.width
                
                Repeater {
                    model: 10
                    
                    Item {
                        width: valueLabels.width / 10
                        height: 30
                        
                        // Числовая метка
                        Text {
                            anchors.centerIn: parent
                            text: index + 1
                            font.pixelSize: 16
                            font.family: dayFont
                            color: moodValue === (index + 1) ? "#A0B9F2" : "#583E3F"
                            font.bold: moodValue === (index + 1)
                            
                            // Клик по числу для быстрого выбора
                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -5
                                onClicked: {
                                    moodValue = index + 1
                                }
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }
        }

        // Подзаголовок для выбора собачки
        Text {
            Layout.fillWidth: true
            text: "woof are you today?"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 18
            font.family: dayFont
            color: "#583E3F"
            Layout.topMargin: 10
        }

        // Сетка с изображениями собачек (4x2)
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: width / 2
            Layout.topMargin: 15
            Layout.leftMargin: 25
            Layout.rightMargin: 25
            
            Grid {
                id: dogGrid
                anchors.fill: parent
                columns: 4
                rows: 2
                spacing: 10
                
                Repeater {
                    model: dogImagesCount

                    // Контейнер для одного изображения собачки
                    Item {
                        property bool isSelected: selectedDogIndex === index

                        width: (dogGrid.width - (dogGrid.columns) * dogGrid.spacing) / dogGrid.columns
                        height: (dogGrid.height - (dogGrid.rows) * dogGrid.spacing) / dogGrid.rows

                        Rectangle {
                            id: dogContainer
                            anchors.fill: parent
                            color: "transparent"
                            
                            // Основной контейнер с изображением
                            Rectangle {
                                id: roundedBorder
                                anchors.fill: parent
                                color: "#FDFDF5"
                                radius: 10
                                border.width: 1
                                border.color: "#C7DAA1"
                                clip: true
                                
                                // Изображение собачки
                                Image {
                                    anchors.fill: parent
                                    source: "../images/dogs/dog_" + index + ".png"
                                    fillMode: Image.PreserveAspectCrop
                                }
                            }

                            // Рамка выбора (показывается только для выбранной собачки)
                            Rectangle {
                                visible: isSelected
                                anchors.fill: parent
                                color: "transparent"
                                radius: 10
                                border.width: 3
                                border.color: "#583E3F"
                            }

                            // Обработка клика для выбора собачки
                            MouseArea {
                                anchors.fill: parent
                                onClicked: selectedDogIndex = index
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }
        }

        // Заполнитель для выравнивания элементов
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    // Кнопка "Готово" для сохранения выбора
    Rectangle {
        id: doneButtonBackground
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 180
        }
        width: 100
        height: 40
        radius: 20
        color: "#FDFDF5"
        
        // Текст кнопки
        Text {
            id: doneButton
            anchors.centerIn: parent
            text: "done"
            font.pixelSize: 18
            font.family: dayFont
            color: selectedDogIndex >= 0 ? "#583E3F" : "#A0A0A0"
        }
        
        // Обработка клика по кнопке "Готово"
        MouseArea {
            anchors.fill: parent
            enabled: selectedDogIndex >= 0
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (selectedDogIndex >= 0) {
                    root.moodSelected(selectedDay, selectedMonth, selectedYear, moodValue, selectedDogIndex)
                }
            }
        }
    }

    // Кнопка "Назад" в левом верхнем углу
    Button {
        id: backButton
        anchors {
            top: parent.top
            left: parent.left
            margins: 10
        }
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

        onClicked: root.cancelled()
        
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