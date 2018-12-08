import QtQuick 2.0
import Sailfish.Silica 1.0
import "../DB.js" as DB

Page{
    id: settingsPage
    RemorsePopup{ id: remorseSettings }
    SilicaFlickable{
        id: settingsFlickable
        VerticalScrollDecorator { flickable: settingsFlickable }
        anchors.fill:parent
        contentHeight: buttonResetSettings.y + buttonResetSettings.height + Theme.paddingLarge
        Column{
            id:settingsCol
            spacing: Theme.paddingMedium
            width: parent.width
            PageHeader{
                title: qsTr("Settings")
            }
            TextSwitch{
                checked: DB.getParameter("vibrate")!==0
                text: qsTr("Vibrate when press-and-hold")
                description: checked?qsTr("Enabled"):qsTr("Disabled")
                onClicked:{
                    if(checked)
                        DB.setParameter("vibrate", 1)
                    else
                        DB.setParameter("vibrate", 0)
                    game.vibrate=checked
                }
            }
            TextSwitch{
                checked: DB.getParameter("zoomindic")!==0
                text: qsTr("Zoom on indicators")
                description: checked?qsTr("Enabled"):qsTr("Disabled")
                onClicked:{
                    if(checked)
                        DB.setParameter("zoomindic", 1)
                    else
                        DB.setParameter("zoomindic", 0)
                    game.zoomIndic=(checked?1:0)
                }
            }
            TextSwitch{
                checked: DB.getParameter("autoLoadSave")===1
                text: qsTr("Load saves by default")
                description: checked?qsTr("Saves will be loaded by default"):qsTr("Load them by a long press")
                onClicked:{
                    if(checked)
                        DB.setParameter("autoLoadSave", 1)
                    else
                        DB.setParameter("autoLoadSave", 0)
                }
            }
            TextSwitch{
                checked: DB.getParameter("slideInteractive")===1
                text: qsTr("Swipe throught difficulty")
                description: checked?qsTr("Swipe is enabled"):qsTr("Swipe disable. Click on a difficulty name to load it")
                onClicked:{
                    if(checked)
                        DB.setParameter("slideInteractive", 1)
                    else
                        DB.setParameter("slideInteractive", 0)
                }
            }
            TextSwitch {
                checked: DB.getParameter("showKeypad")===1
                text: qsTr("Display keypad")
                description: qsTr("Use on-screen arrow keys and cursor.")
                onClicked: {
                    DB.setParameter("showKeypad", checked ? 1 : 0)
                    game.showKeypad = checked ? 1 : 0
                }
            }

            Slider {
                id: slider
                width: parent.width
                label: qsTr("Space between separators")
                minimumValue: -1
                maximumValue: 10
                stepSize: 1
                value: DB.getParameter("space")
                valueText: value > -1 ? value : "Auto"
                onValueChanged: {
                    game.space = slider.value
                    DB.setParameter("space", slider.value)
                }
            }
            Button{
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Clear ALL databases (saves & progress)")

                onClicked:{
                    remorseSettings.execute(qsTr("Clearing ALL Databases"), function(){
                        DB.destroyData()
                        DB.initialize()
                        game.allLevelsCompleted = false
                    })
                }
            }
            Button{
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Clear only saves database")
                onClicked:{
                    remorseSettings.execute(qsTr("Clearing only saves database"), function(){
                        DB.destroySaves()
                        DB.initializeSaves()})
                }
            }
            Button{
                id: buttonResetSettings
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Reset settings")
                onClicked:{
                    remorseSettings.execute(qsTr("Resetting settings"), function(){
                        DB.destroySettings()
                        game.space = DB.getParameter("space")
                        game.vibrate = DB.getParameter("vibrate") === 1
                        game.zoomIndic = DB.getParameter("zoomindic")
                        game.showKeypad = DB.getParameter("showKeypad") === 1
                        pageStack.pop()
                    })
                }
            }
        }
        Component.onDestruction:{
            game.pause=false
        }
    }
}
