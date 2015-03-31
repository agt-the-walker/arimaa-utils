#include <QString>

class MoveList
{
public:
    MoveList(const QString &in) { mPlies = in.count(QLatin1String("\\n")); };
    int plies() { return mPlies; };

private:
    int mPlies;
};
