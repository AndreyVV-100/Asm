#include <stdio.h>

const int MAGIC1 = 1488;
const int MAGIC2 = 228;

extern void Start();

int main()
{
    for (int i = 0; i < MAGIC1; i++)
        fprintf (stdin, "%c", 0);
    
    fprintf (stdin, "%c%c", MAGIC2, 0);
    Start();
    return 0;
}
