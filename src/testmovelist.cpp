#include "movelist.h"
#include "testmovelist.h"

void TestMoveList::plies()
{
    QFETCH(QString, path);
    QFETCH(int, plies);

    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        QFAIL("Cannot open file");
    QTextStream in(&file);

    MoveList moveList(in.readAll());
    QCOMPARE(plies, moveList.plies());
}

void TestMoveList::plies_data()
{
    QTest::addColumn<QString>("path");
    QTest::addColumn<int>("plies");

    QDir dir(QStringLiteral(QT_TESTCASE_BUILDDIR) + QLatin1String("/testdata"));
    QList<int> plies { 122, 61, 82, 134, 92 };

    for (auto &entry: dir.entryList(QDir::Files))
        QTest::newRow(qPrintable(entry)) << dir.filePath(entry)
                                         << plies.takeFirst();
    QVERIFY(plies.isEmpty());
}

QTEST_MAIN(TestMoveList)
