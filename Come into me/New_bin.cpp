#include <stdio.h>

int main()
{
    unsigned char code[] = 
    #include "Char_files.txt" 
    ;

    char old_bit = 0;

    for (int i_ch = sizeof (code) - 1; i_ch >= 0; i_ch--)
    {
        char prev_bit = old_bit;
        old_bit = ((code [i_ch]) & 0x80) >> 7;
        code[i_ch] = code[i_ch] << 1;
        code[i_ch] = code[i_ch] | prev_bit;
    }

    for (int i_ch = 0; i_ch < sizeof (code); i_ch++)
    {
        printf ("%u", (unsigned int) code[i_ch]);
        if (i_ch % 10 == 0)
            printf ("\n");
        else
            printf (", ");
    }

    printf ("\n");

    return 0;
}
