#include "symb_form.hpp"

#include <cctype>
#include <memory>

shared_ptr<Symbol> Symbol::multiply(const shared_ptr<Symbol>& other) const {
    return make_shared<Symbol>("scMul(" + literal + ", " + other->literal + ")");
}
shared_ptr<Symbol> Symbol::subtract(const shared_ptr<Symbol>& other) const {
    return make_shared<Symbol>("scSub(" + literal + ", " + other->literal + ")");
}
shared_ptr<Symbol> Symbol::add(const shared_ptr<Symbol>& other) const {
    return make_shared<Symbol>("scAdd(" + literal + ", " + other->literal + ")");
}
shared_ptr<Symbol> Symbol::addOne() const {
    return make_shared<Symbol>("scAdd(" + literal + ", 1)");
}

shared_ptr<Symbol> Symbol::one() {
    return make_shared<Symbol>("1");
}

bool Symbol::substitute(string original, string with){
    size_t pos = 0;
    bool changed = false;
    while ((pos = literal.find(original, pos)) != std::string::npos) {
        bool atStart = (pos == 0);
        bool atEnd = (pos + original.length() == literal.length());
        bool beforeOK = atStart || !std::isalnum(literal[pos - 1]) && literal[pos - 1] != '.';
        bool afterOK = atEnd || !std::isalnum(literal[pos + original.length()]) && literal[pos + original.length()] != '.';
        if (beforeOK && afterOK) {
            literal.replace(pos, original.length(), with);
            pos += with.length();
            changed = true;
        } else {
            pos += original.length();
        }
    }
    return changed;
}

void Symbol::show(std::ostream& os) const {
    os << literal << std::endl;
}
