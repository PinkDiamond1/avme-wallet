/* Copyright (c) 2020-2021 AVME Developers
   Distributed under the MIT/X11 software license, see the accompanying
   file LICENSE or http://www.opensource.org/licenses/mit-license.php. */
import QtQuick 2.9
import QtQuick.Controls 2.2

import "qrc:/qml/components"
import "qrc:/qml/popups"

// Screen for showing general settings
Item {
  id: settingsScreen

  AVMEPanel {
    id: settingsPanel
    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
      bottom: parent.bottom
      margins: 10
    }
    title: "General Settings"

    Column {
      id: settingsCol
      anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        right: parent.right
        topMargin: 80
        bottomMargin: 40
        leftMargin: 40
        rightMargin: 40
      }
      spacing: 40

      Text {
        id: storePassText
        width: settingsCol.width * 0.75
        color: "#FFFFFF"
        font.pixelSize: 14.0
        text: "Remember password after next transaction for (0 = do not remember)"

        AVMESpinbox {
          id: storePassBox
          width: settingsCol.width * 0.15
          anchors {
            verticalCenter: parent.verticalCenter
            left: parent.right
          }
          from: 0
          to: 9999  // ~7 days
          editable: true
          validator: RegExpValidator { regExp: /[0-9]{0,4}/ }
          Rectangle {
            id: storePassRect
            property alias timer: storePassRectTimer
            anchors.fill: parent
            color: "#8858A0C9"
            radius: 5
            visible: storePassRectTimer.running
            Timer { id: storePassRectTimer; interval: 250 }
          }
          Text {
            id: storePassBoxText
            width: settingsCol.width * 0.1
            anchors {
              verticalCenter: parent.verticalCenter
              left: parent.right
              leftMargin: 10
            }
            font.pixelSize: 14.0
            color: "#FFFFFF"
            verticalAlignment: Text.AlignVCenter
            text: "minutes"
          }
          Component.onCompleted: {
            var storedValue = qmlSystem.getConfigValue("storePass")
            storedValue = (+storedValue >= 0) ? storedValue : "0"
            storePassBox.value = +storedValue
          }
          onValueModified: {
            qmlSystem.resetPass()
            var storedValue = storePassBox.value.toString()
            storedValue = (+storedValue >= 0) ? storedValue : "0"
            qmlSystem.setConfigValue("storePass", storedValue)
            storePassRect.timer.stop()
            storePassRect.timer.start()
          }
        }
      }

      Text {
        id: developerText
        width: settingsCol.width * 0.75
        color: "#FFFFFF"
        font.pixelSize: 14.0
        text: "Enable loading DApps from a local folder (FOR EXPERTS/DEVELOPERS ONLY!)"

        AVMECheckbox {
          id: developerCheck
          checked: false
          width: settingsCol.width * 0.25
          anchors {
            verticalCenter: parent.verticalCenter
            left: parent.right
          }
          text: "Developer Mode"
          Component.onCompleted: {
            var toggled = qmlSystem.getConfigValue("devMode")
            if (toggled == "true") { checked = true }
            else if (toggled == "false") { checked = false }
          }
          onToggled: qmlSystem.setConfigValue("devMode", (checked) ? "true" : "false")
        }
      }
    }
  }
}
