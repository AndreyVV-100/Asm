#include <stdio.h>

const char BACKSPACE = 0x08;
const char ENTER = 0x0D;

int main()
{
    char mass[1000] = {};

    int byte = 0x01CE;
    int pos = 0;

    for (byte; byte != 0x0172; byte--)
    {
        mass[pos] = BACKSPACE;
        pos++;
    }

    mass[pos] = 0x00;
    pos++;
    byte++;

    for (byte; byte != 0x015B; byte--)
    {
        mass[pos] = BACKSPACE;
        pos++;
    }

    mass[pos] = 0x17;
    pos++;
    mass[pos] = ENTER;
    pos++;

    FILE* text = fopen ("hp1.txt", "wb");
    fwrite (mass, sizeof (char), pos, text);
    fclose (text);

    return 0;
}
