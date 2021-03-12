#include <stdio.h>

int main()
{
    const char password[] = "thequickbrownfoxjumpsoverthelazydog";
    for (int i_ch = 0; i_ch < sizeof (password); i_ch++)
    {
        printf ("%c", password[password[i_ch] - 'a']);
    }
    printf("\n");
    return 0;
}
