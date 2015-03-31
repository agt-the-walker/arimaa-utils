#include "movelist.h"
#include "testmovelist.h"

void TestMoveList::plies()
{
    QFETCH(QString, in);
    QFETCH(int, plies);

    MoveList moveList(in);
    QCOMPARE(plies, moveList.plies());
}

void TestMoveList::plies_data()
{
    QTest::addColumn<QString>("in");
    QTest::addColumn<int>("plies");

    QTest::newRow("Game 87015") << R"(1w Ra1 Db1 Rc1 Rd1 De1 Rf1 Rg1 Rh1 Ra2 Hb2 Cc2 Md2 Ee2 Cf2 Hg2 Rh2\n1b ra7 hb7 cc7 ed7 me7 df7 hg7 rh7 ra8 rb8 rc8 dd8 ce8 rf8 rg8 rh8\n2w Ee2n Ee3n Ee4n Hg2n\n2b ed7s ed6s ed5s hg7s\n3w De1n Ee5w Ed5n Hb2n\n3b ed4s hb7s ra7e rh7w\n4w Db1n Hb3n Hb4n Db2n\n4b ed3n Md2n ed4w Md3n\n5w Hb5w De2w Rc1w Rd1w\n5b ec4n Md4w ec5w Mc4n\n6w Ed6s Mc5s Ed5w Mc4e\n6b eb5s eb4e Db3n me7w\n7w Ec5e Md4s Ha5s Db4s\n7b ec4e Md3e ed4s ce8s\n8w Dd2e Me3n Me4w Md4w\n8b ed3n Mc4n ed4w ec4w\n9w Mc5s Ed5w Mc4s Ec5w\n9b eb4e ec4w Mc3n md7s\n10w Eb5e Mc4s Mc3e Ec5w\n10b eb4e Ha4e ec4e Hb4e\n11w Eb5e Hc4s Md3s Ec5w\n11b hg6e hh6s hh5s hh4s\n12w hb6w Eb5n Eb6s rb7s\n12b hh3n Rh2n hh4n Rh3n\n13w Eb5e rb6s rb5s Ec5w\n13b hh5n Rh4n ed4w rb4w\n14w Eb5e Ec5e Ed5e md6s\n14b ec4e Hc3n md5w hh6w\n15w Db3e Hc4w Hb4s ra4e\n15b ed4w ec4e Dc3n ha6s\n16w Md2n Hb3s rb4s Ee5w\n16b Md3s ed4s ha5e dd8s\n17w rb3e Hb2n Ed5n mc5e\n17b hb5e md5s Dc4w md4w\n18w Ra2e Ed6s Db4w Da4s\n18b hc5w hb5w ha5s mc4w\n19w Ed5w De2s Md2e Me2n\n19b ha4n Da3n Hb3w mb4s\n20w Ec5w Ra1n De1n De2w\n20b mb3n rc3w mb4e mc4s\n21w Da4e Db4e Eb5e Cf2w\n21b hg6e hh6w Rh5n rh8s\n22w Me3e Mf3n Mf4e Mg4n\n22b hg6w Rh6w hf6w Rg6w Rf6x\n23w Mg5w Hg3n Hg4n Hg5n\n23b ed3e ee3n ee4e mc3e\n24w Ec5e Ed5s Hg6s Mf5w\n24b ef4n ha5e hb5s rg7s\n25w Ha3n rb3w md3w mc3x Ed4s\n25b ef5s Me5e Mf5n Mf6x ef4n\n26w Ed3n Dc4s Dc3w Ed4w\n26b ef5w Hg5w Hf5n Hf6x ee5e\n27w Ec4e hb4e hc4s hc3x Ed4w\n27b ef5w ee5s ee4s he6w\n28w Ce2e Cf2e Db3n ra3e\n28b ee3w df7s df6s df5e\n29w rb3e Db4s Ec4e Dd2e\n29b dg5s dg4s Cg2w dg3s\n30w De2n Cf2n Rf1n Cf3e\n30b hd6w hc6w hb6s rb8s\n31w Ha4e Hb4e Hc4n Hc5e\n31b hb5s Db3w hb4s rf8s\n32w Hd5e He5e Hf5s Hf4s\n32b ed3s rc3e Cc2n Cc3x ed2w\n33w Ed4w rd3n Rf2w Hf3s\n33b ec2e ed2n dd7s dd6s\n34w Rb2e Ec4s hb3s Ec3w\n34b dd5w dc5s rb7s rb6s\n35w De3n rd4n De4w Re2w\n35b ed3e ee3s Hf2s ee2e\n36w Rd2n Rd3e Rc2e Rd2n\n36b Cg3e dg2n rg6s rg5s\n37w Dd4e De4e Rd3n Rc1n\n37b ef2n Df4n ef3n dc4n\n38w Hf1n Hf2n dg3s Hf3e\n38b Df5n Df6x ef4n ef5s rg4e\n39w Eb3e hb2n Ec3n hb3e hc3x\n39b ef4e eg4w Hg3n dg2n\n40w Ec4s dc5s Ec3e dc4s dc3x\n40b ef4s ef3n Re3e Rf3x ce7s\n41w Ed3e Da3n Da4n Da5n\n41b rf7s rf6s rd5e ce6w\n42w Da6e Ra2n Ra3n Ra4n\n42b rc8w Hg4n ef4e rf5s\n43w Ee3n rf4n Ee4e Rg1w\n43b re5s cd6s cd5e re4s\n44w Ef4w re3w Ee4s Rf1n\n44b rf5s dg3s Ch3w rh4s\n45w rd3w rc3x Ee3w Ed3e Ra5n\n45b eg4e rh3s\n46w Rb1w\n46b dg2s dg1n Rh1w rh2s\n47w)" << 92;
}

QTEST_MAIN(TestMoveList)
