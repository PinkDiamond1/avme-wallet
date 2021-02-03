import QtQuick 2.9
import QtQuick.Controls 2.2

/**
 * Custom list for a wallet's addresses and amounts.
 * Requires a ListModel with the following items:
 * - "name": the account's name/label
 * - "account": the account's actual address
 * - "amount": the account's amount
 */

ListView {
  id: list
  highlight: Rectangle { color: "#7AC1EB"; radius: 5 }
  implicitWidth: 500
  implicitHeight: 500
  highlightMoveDuration: 100
  highlightMoveVelocity: 1000
  highlightResizeDuration: 100
  highlightResizeVelocity: 1000
  focus: true
  clip: true

  header: Rectangle {
    id: listHeader
    color: "#58A0C9"
    width: parent.width
    height: 30
    anchors.horizontalCenter: parent.horizontalCenter
    z: 2

    Row {
      id: headerNameRow
      anchors.verticalCenter: parent.verticalCenter
      width: parent.width / 8
      Text {
        text: "Name"; font.pixelSize: 18; color: "white"; padding: 5;
      }
    }
    Row {
      id: headerAccountRow
      anchors.verticalCenter: parent.verticalCenter
      width: parent.width / 2
      x: headerNameRow.width
      Text {
        text: "Account"; font.pixelSize: 18; color: "white"; padding: 5;
      }
    }
    Row {
      id: headerAmountRow
      anchors.verticalCenter: parent.verticalCenter
      width: parent.width / 4
      x: headerNameRow.width + headerAccountRow.width
      Text {
        text: "Amount"; font.pixelSize: 18; color: "white"; padding: 5;
      }
    }
  }
  headerPositioning: ListView.OverlayHeader // Prevent header scrolling along

  delegate: Component {
    id: listDelegate
    Item {
      id: listItem
      property alias listItemName: itemName.text
      property alias listItemAccount: itemAccount.text
      property alias listItemAmount: itemAmount.text
      width: parent.width
      height: 40
      z: 1
      Row {
        id: delegateNameRow
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width / 8
        Text { id: itemName; text: name; elide: Text.ElideRight; font.pixelSize: 18; color: "white"; padding: 5; }
      }
      Row {
        id: delegateAccountRow
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width / 2
        x: delegateNameRow.width
        Text { id: itemAccount; text: account; elide: Text.ElideRight; font.pixelSize: 18; color: "white"; padding: 5; }
      }
      Row {
        id: delegateAmountRow
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width / 4
        x: delegateNameRow.width + delegateAccountRow.width
        Text { id: itemAmount; text: amount; elide: Text.ElideRight; font.pixelSize: 18; color: "white"; padding: 5; }
      }
      MouseArea {
        anchors.fill: parent
        onClicked: list.currentIndex = index
      }
    }
  }
}
