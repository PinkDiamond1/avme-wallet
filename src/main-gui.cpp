// Copyright (c) 2020-2021 AVME Developers
// Distributed under the MIT/X11 software license, see the accompanying
// file LICENSE or http://www.opensource.org/licenses/mit-license.php.
#include "main-gui.h"

// Implementation of AVME Wallet as a GUI (Qt) program.

int main(int argc, char *argv[]) {
  // Set logging options to default to suppress debug strings (e.g. when reading key files).
  dev::LoggingOptions loggingOptions;
  loggingOptions.verbosity = 0; // No WARN messages
  dev::setupLogging(loggingOptions);

  // Create the application and register our custom class into it

  // TODO: This display DPI fix is an workaround. But Qt have few bugs that doesn't allow much to be done beside this ifdef.
  #ifdef __MINGW32__
  	::SetProcessDPIAware();
  #endif
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QApplication app(argc, argv);
  QQmlApplicationEngine engine;
  System sys;
  engine.rootContext()->setContextProperty("System", &sys);

  // Set the app's text font and icon
  QFontDatabase::addApplicationFont(":/fonts/RobotoMono-Bold.ttf");
  QFontDatabase::addApplicationFont(":/fonts/RobotoMono-Italic.ttf");
  QFontDatabase::addApplicationFont(":/fonts/RobotoMono-Regular.ttf");
  QFont font("Roboto Mono");
  font.setStyleHint(QFont::Monospace);
  QApplication::setFont(font);
  app.setWindowIcon(QIcon(":/img/avme_logo.png"));

  // Load the main screen and start the app
  engine.load(QUrl(QStringLiteral("qrc:/qml/screens/main.qml")));
  if (engine.rootObjects().isEmpty()) return -1;
  return app.exec();
}

