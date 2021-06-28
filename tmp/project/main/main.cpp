
//#include <iostream>
//#include "gnuplot.h"

//int main() {
//    std::cout << "Hello, World !" << std::endl;
//
//    return 0;
//}

//int main(){
//    GnuplotPipe gp;
//    gp.sendLine("plot [-pi/2:pi] cos(x),-(sin(x) > sin(x+1) ? sin(x) : sin(x+1))");
//    return 0;
//}

#include <stdio.h>
#include <iostream>
#include "function.h"
#include "../common/libtest.h"

using namespace std;

int main() {
    cout << "hello world" << endl;

    // 다른 cpp의 함수를 호출
    function();

    // 라이브러리의 함수 호출
    libtest();
}