#include <QString>

class MoveList
{
public:
    MoveList(const QString &in) { mPlies = in.count(R"(\n)"); };
    int plies() { return mPlies; };

private:
    int mPlies;
};
