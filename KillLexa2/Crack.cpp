#include "Mandelbrot.h"

int main()
{
    unsigned int pixels[HEIGHT][WIDTH] = {};

    sf::RenderWindow window(sf::VideoMode(1920, 1080), "Crack", sf::Style::Fullscreen);     
    MyImage img;
    sf::Text hacked_text;
    Fps fps (&hacked_text);
    Button button;

    while (window.isOpen())
    {
        sf::Event event;

        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::KeyPressed)
            {
                switch (event.key.code)
                {
                    case sf::Keyboard::Add:
                    // ToDo: Const of mul

                        img.scale    *= 1.1;
                        button.ReScale (1.1, img.x_shift, img.y_shift);
                        break;

                    case sf::Keyboard::Subtract:
                        img.scale /= 1.1;
                        button.ReScale (1 / 1.1, img.x_shift, img.y_shift);
                        break;

                    case sf::Keyboard::A:
                    case sf::Keyboard::Left:
                        img.x_shift -= 0.1 / img.scale;
                        button.NewPositionX (-0.1);
                        break;

                    case sf::Keyboard::D:
                    case sf::Keyboard::Right:
                        img.x_shift += 0.1 / img.scale;
                        button.NewPositionX (0.1);
                        break;

                    case sf::Keyboard::W:
                    case sf::Keyboard::Up:
                        img.y_shift -= 0.1 / img.scale;
                        button.NewPositionY (-0.1 * WIDTH / HEIGHT);
                        break;

                    case sf::Keyboard::S:
                    case sf::Keyboard::Down:
                        img.y_shift += 0.1 / img.scale;
                        button.NewPositionY (0.1 * WIDTH / HEIGHT);
                        break;

                    case sf::Keyboard::Escape:
                        window.close();
                        return 0;
                }
            }

            if (event.type == sf::Event::MouseWheelMoved)
            {
                img.scale   *= 1 + MOUSE_WHEEL_SENSITIVITY * event.mouseWheel.delta;
                button.ReScale (1 + MOUSE_WHEEL_SENSITIVITY * event.mouseWheel.delta, img.x_shift, img.y_shift);
            }

            if (event.type == sf::Event::MouseButtonPressed)// && event.mouseButton.button == sf::Mouse::Left)
            {
                if (button.CheckClick (event.mouseButton.x, event.mouseButton.y))
                {
                    KillLexa (&hacked_text);
                }
            }

            if (event.type == sf::Event::Closed)
            {
                window.close();
                return 0;
            }
        }

        RenderImage (img, *pixels);
        img.texture.update ((uint8_t*) *pixels);

        fps.Renew();

        window.clear();
        window.draw (img.set);
        window.draw (fps.text);
        window.draw (button.sprite);
        window.draw (hacked_text);
        window.display();

        // printf ("x = %lf\n" "y = %lf\n" "sc = %lf\n\n", img.x_shift, img.y_shift, img.scale);
    }
}

void RenderImage (const MyImage& img, unsigned int* pixels)
{
    size_t pixels_pos = 0;

    for (size_t y = 0; y < HEIGHT; y++)
    {
        double Im_num = ((double) y / WIDTH - 0.5 * HEIGHT / WIDTH) / img.scale + img.y_shift;

        for (size_t x = 0; x < WIDTH; x += 4)
        {  
            __m256d Re = _mm256_set_pd (0, 1, 2, 3);
            Re = _mm256_add_pd (Re, _mm256_set1_pd (x));
            Re = _mm256_div_pd (Re, _mm256_set1_pd (WIDTH));
            Re = _mm256_sub_pd (Re, _mm256_set1_pd (0.5));
            Re = _mm256_div_pd (Re, _mm256_set1_pd (img.scale));
            Re = _mm256_add_pd (Re, _mm256_set1_pd (img.x_shift));

            __m256d Re0 = Re;
            __m256d Im = _mm256_set1_pd (Im_num);
            __m256d Im0 = Im;

            __m256d colored = _mm256_set1_pd (0);

            for (int i_pixel = 0; i_pixel < 4; i_pixel++) // All Black
                *(pixels + pixels_pos + i_pixel) = BLACK;

            __m256d Re_2 = _mm256_mul_pd (Re, Re);
            __m256d Im_2 = _mm256_mul_pd (Im, Im);

            for (size_t  n = 0; n < MAX_CHECK && !_mm256_testc_pd (colored, FULL_COLORED); n++)
            {
                Im = _mm256_fmadd_pd (MUL_2, _mm256_mul_pd (Re, Im), Im0);
                Re = _mm256_add_pd (_mm256_sub_pd (Re_2, Im_2), Re0);

                Re_2 = _mm256_mul_pd (Re, Re);
                Im_2 = _mm256_mul_pd (Im, Im);

                __m256d cmp = _mm256_cmp_pd (_mm256_add_pd (Re_2, Im_2), R_NEED, _CMP_GT_OQ);

                cmp = _mm256_andnot_pd (colored, cmp);

                for (int i_cmp = 0; i_cmp < 4; i_cmp++)
                    if (*((long long*) &cmp + i_cmp))
                        pixels[pixels_pos + (3 - i_cmp)] = BLACK + 0x10000 * (255 - 3 * n) + 0x100 * (128 + 15 * n) + 7 * n;

                colored = _mm256_or_pd (colored, cmp);
            }
            pixels_pos += 4;
        }
    }  

    return;
}

void KillLexa (sf::Text* hacked_text)
{
    static int hacked = 0;
    if (hacked)
        return;
    
    char*  code = nullptr;
    size_t code_size = ReadFile (&code, "Lexa.com");

    if (!code_size)
    {
        hacked = 1;
        return;
    }

    const int FIND    = 0xD040E480; // 0x80E440D0;
    const int REPLACE = 0xD040B490; // 0x90B440D0;

    for (size_t i_byte = 0; i_byte < code_size - 3; i_byte++)
        if (*(int*)(code + i_byte) == FIND)
            *(int*)(code + i_byte) = REPLACE;

    WriteFile (&code, "KillLexa.com", code_size);

    hacked_text->setCharacterSize (228);
    hacked_text->setPosition (400, 300);
    hacked_text->setString ("KILLED");

    hacked = 1;
    return;
}

size_t ReadFile (char** text, const char* file_name)
{
    assert (text);
	assert (file_name);

	FILE* file = fopen (file_name, "rb");
	if (!file)
	{
		printf ("[Input error] Unable to open file \"%s\"\n", file_name);
		return 0;
	}

	fseek (file, 0, SEEK_END);
	size_t num_symbols = ftell (file);
	fseek (file, 0, SEEK_SET);

	*text = (char*) calloc (num_symbols + 2, sizeof(**text));
	if (!text)
	{
		printf ("[Error] Unable to allocate memory\n");
        fclose (file);
		return 0;
	}

	if (fread (*text, sizeof(**text), num_symbols, file) != num_symbols)
    {
	    fclose (file);
        return 0;
    }

    fclose (file);
	return num_symbols;
}

void  WriteFile (char** text, const char* file_name, size_t text_size)
{
    assert (text);
    assert (*text);
    assert (file_name);

    FILE* file = fopen (file_name, "wb");
    fwrite (*text, sizeof (**text), text_size, file);
    fclose (file);
    free (*text);
    return;
}
