/* Copyright (c) 2020-2021 AVME Developers
   Distributed under the MIT/X11 software license, see the accompanying
   file LICENSE or http://www.opensource.org/licenses/mit-license.php. */
import QtQuick 2.15 // Gradient.orientation requires QtQuick 2.15
import QtQuick.Controls 2.2

// Template for basic info/data/etc.
Rectangle {
  id: overviewBalance
  property alias currentAccount: account.text
  property alias totalFiatBalance: fiatBalance.text
  property alias totalCoinBalance: coinBalance.text
  property alias totalTokenBalance: tokenBalance.text

  // Due to usage of global variables, we can only tell the screen
  // to read from them in the appropriate time using a signal
  Component.onCompleted: {
    currentAccount = qmlSystem.getCurrentAccount()
    if (!accountHeader.coinRawBalance) {
      totalFiatBalance = "Loading..."
      totalCoinBalance = "Loading..."
      totalTokenBalance = "Loading..."
    } else { updateBalances() }
  }
  Connections {
    target: accountHeader
    function onUpdatedBalances() { updateBalances() }
  }

  function updateBalances() {
    totalFiatBalance = "$" + accountHeader.totalFiatBalance
    totalCoinBalance = accountHeader.coinRawBalance + " AVAX"
    var totalTokenWorth = 0.0
    for (var token in accountHeader.tokenList) {
      var currentTokenWorth = (+accountHeader.tokenList[token]["rawBalance"] *
      +accountHeader.tokenList[token]["derivedValue"])
      // Due to some unknown reason, if you sum something to 0, it will return 0
      // So we need to check if the currentTokenWorth is not 0
      if (+currentTokenWorth != 0)
        totalTokenWorth += +currentTokenWorth
    }
    totalTokenBalance = totalTokenWorth + " AVAX (Tokens)"
  }

  function qrEncode() {
    qrcodePopup.qrModel.clear()
    var qrData = qmlSystem.getQRCodeFromAddress(currentAccount)
    for (var i = 0; i < qrData.length; i++) {
      qrcodePopup.qrModel.set(i, JSON.parse(qrData[i]))
    }
  }

  implicitWidth: 500
  implicitHeight: 120
  gradient: Gradient {
    orientation: Gradient.Horizontal
    GradientStop { position: 0.0; color: "#9300f5" }
    GradientStop { position: 1.0; color: "#00d6f6" }
  }
  radius: 10

  Column {
    id: dataCol
    width: parent.width * 0.8
    anchors {
      left: parent.left
      verticalCenter: parent.verticalCenter
      margins: 10
    }
    spacing: 5

    Text { id: account; color: "white"; font.pixelSize: 18.0; font.bold: true }
    Text { id: fiatBalance; color: "white"; font.pixelSize: 24.0; font.bold: true }
    Text { id: coinBalance; color: "white"; font.pixelSize: 18.0; font.bold: true }
    Text { id: tokenBalance; color: "white"; font.pixelSize: 18.0; font.bold: true }
  }

  Column {
    id: iconCol
    width: parent.width * 0.2
    anchors {
      right: parent.right
      verticalCenter: parent.verticalCenter
      margins: 10
    }
    spacing: 10

    Rectangle {
      id: copyClipRect
      property alias timer: addressTimer
      enabled: (!addressTimer.running)
      color: "transparent"
      radius: 5
      width: 48
      height: 48
      anchors.right: parent.right
      Timer { id: addressTimer; interval: 1000 }
      ToolTip {
        id: copyClipTooltip
        parent: copyClipRect
        visible: copyClipRect.timer.running
        text: "Copied!"
        contentItem: Text {
          font.pixelSize: 12.0
          color: "#FFFFFF"
          text: copyClipTooltip.text
        }
        background: Rectangle { color: "#1C2029" }
      }
      Image {
        id: copyClipImage
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        antialiasing: true
        smooth: true
        source: "qrc:/img/icons/clipboard.png"
      }
      MouseArea {
        id: copyClipMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: { copyClipImage.source = "qrc:/img/icons/clipboardSelect.png" }
        onExited: { copyClipImage.source = "qrc:/img/icons/clipboard.png" }
        onClicked: { qmlSystem.copyToClipboard(currentAccount); parent.timer.start() }
      }
    }

    Rectangle {
      id: qrCodeRect
      color: "transparent"
      radius: 5
      width: 48
      height: 48
      anchors.right: parent.right

      Image {
        id: qrCodeImage
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectFit
        antialiasing: true
        smooth: true
        source: "qrc:/img/icons/qrcode.png"
      }
      MouseArea {
        id: qrCodeMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: { qrCodeImage.source = "qrc:/img/icons/qrcodeSelect.png" }
        onExited: { qrCodeImage.source = "qrc:/img/icons/qrcode.png" }
        onClicked: { qrEncode(); qrcodePopup.open() }
      }
    }
  }
}
