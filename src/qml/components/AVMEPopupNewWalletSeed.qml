/* Copyright (c) 2020-2021 AVME Developers
   Distributed under the MIT/X11 software license, see the accompanying
   file LICENSE or http://www.opensource.org/licenses/mit-license.php. */
import QtQuick 2.9
import QtQuick.Controls 2.2

// Copy of AVMEPopupViewSeed for the Create Account screen.
Popup {
  id: newWalletSeedPopup
  property string newWalletSeed
  property string newWalletPass
  property alias seed: seedText
  property alias okBtn: btnOk
  property color popupBgColor: "#1C2029"
  property color popupSeedBgColor: "#2D3542"
  property color popupSelectionColor: "#58A0B9"

  function showSeed() {
    seedText.text = System.getWalletSeed(newWalletPass)
    newWalletSeed = seedText.text
  }

  function clean() {
    seedText.text = ""
  }

  width: (parent.width * 0.9)
  height: (parent.height * 0.5)
  x: (parent.width * 0.1) / 2
  y: (parent.height * 0.5) / 2
  modal: true
  focus: true
  padding: 0  // Remove white borders
  closePolicy: Popup.NoAutoClose
  background: Rectangle { anchors.fill: parent; color: popupBgColor; radius: 10 }

  Column {
    anchors.fill: parent
    spacing: 30
    topPadding: 40

    Text {
      id: warningText
      anchors.horizontalCenter: parent.horizontalCenter
      horizontalAlignment: Text.AlignHCenter
      color: "#FFFFFF"
      font.pixelSize: 14.0
      text: "This is your seed for this Wallet. Please note it down.<br>"
      + "You can view it at any time in the Settings menu.<br>"
      + "<br><br><b>YOU ARE FULLY RESPONSIBLE FOR GUARDING YOUR SEED."
      + "<br>KEEP IT AWAY FROM PRYING EYES AND DO NOT SHARE IT WITH ANYONE."
      + "<br>WE ARE NOT HELD LIABLE FOR ANY POTENTIAL FUND LOSSES CAUSED BY THIS."
      + "<br>PROCEED AT YOUR OWN RISK.</b>"
    }

    TextArea {
      id: seedText
      width: parent.width - 100
      height: 50
      anchors.horizontalCenter: parent.horizontalCenter
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      readOnly: true
      selectByMouse: true
      selectionColor: popupSelectionColor
      color: "#FFFFFF"
      background: Rectangle {
        width: parent.width
        height: parent.height
        color: popupSeedBgColor
        radius: 10
      }
    }

    AVMEButton {
      id: btnOk
      anchors.horizontalCenter: parent.horizontalCenter
      text: "OK"
      onClicked: {
        newWalletSeedPopup.clean()
        newWalletSeedPopup.close()
      }
    }
  }
}
