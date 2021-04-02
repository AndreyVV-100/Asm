#include <stdio.h>
#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <immintrin.h>
#include <assert.h>

const double MOUSE_WHEEL_SENSITIVITY = 0.05; 

const size_t WIDTH  = 1920;
const size_t HEIGHT = 1080;
const size_t MAX_CHECK = 256;
const double R2 = 100;

const unsigned int BLACK = 0xFF000000;

const __m256d FULL_COLORED = _mm256_cmp_pd (_mm256_set1_pd (0), _mm256_set1_pd (0), _CMP_EQ_OQ);
const __m256d MUL_2  = _mm256_set1_pd (2.0);
const __m256d R_NEED = _mm256_set1_pd (100);

struct MyImage
{
    sf::Texture texture;
    sf::Sprite  set;
    sf::Music music;

    double scale = 0.23;
    double x_shift = -0.3, y_shift = 0; 

    MyImage ()
    {
        texture.create (WIDTH, HEIGHT);
        set.setTextureRect (sf::IntRect (0, 0, WIDTH, HEIGHT));
        set.setTexture (texture, false);
        music.openFromFile("music.ogg");
        music.play();       
    }
};

struct Fps
{
    sf::Font  font;
    sf::Text  text;
    sf::Clock clock;
    sf::Time  time = clock.getElapsedTime();

    double time_prev = time.asSeconds();
    double time_now  = 0;
    double time_last_out = 0;

    const double FPS_DELAY = 0.15;

    char str[16] = "fps = 000.00";

    Fps (sf::Text* hacked_text)
    {
        if (!font.loadFromFile ("font.ttf"))
            return;

        hacked_text->setFont (font);
        text.setFont (font);
        text.setCharacterSize (24); 
        text.setFillColor (sf::Color::Red);
    }

    void Renew()
    {
        time = clock.getElapsedTime();
        time_now = time.asSeconds();
        if (time_now - time_last_out > FPS_DELAY)
        {
            sprintf (str + 6, "%.2lf\n", 1 / (time_now - time_prev));
            text.setString (str);
            time_last_out = time_now;
        }
        time_prev = time_now;
    }
};

class Button
{
    const double x_center = 200, y_center = 200;
    const double R_2 = 40000;


    double x = 538.076, y = 708.673;
    double scale = 1.0 / 610;
    // double scale = 1.0 / 100;
    char str[5] = "Hack";

    sf::Texture texture;
    
    public:

    sf::Sprite sprite;

    Button()
    {
        texture.loadFromFile ("Button.png", sf::IntRect(x, y, 0, 0));
        sprite.setTexture (texture);
        sprite.setScale (scale, scale);
        sprite.setPosition (x, y);
    }    

    void ReScale (const double coef, double x_shift, double y_shift)
    {
        scale *= coef;
        x -= (1 - coef) * (x - WIDTH / 2);
        y -= (1 - coef) * (y - HEIGHT / 2);
        sprite.setPosition (x, y);
        sprite.setScale (scale, scale);
    }

    void NewPositionX (double shift)
    {
        x -= shift * WIDTH;
        sprite.setPosition (x, y);
    }

    void NewPositionY (double shift)
    {
        y -= shift * HEIGHT;
        sprite.setPosition (x, y);
    }

    int CheckClick (double mouse_x, double mouse_y)
    {
        // printf ("\n""x = %lf\n" "y = %lf\n" "mouse_x = %lf\n" "mouse_y = %lf\n" "scale = %lf\n",
        // x, y, mouse_x, mouse_y, scale);
        if ((x + scale * x_center - mouse_x) * (x + scale * x_center - mouse_x) +
            (y + scale * y_center - mouse_y) * (y + scale * y_center - mouse_y) <= scale * scale * R_2)
            return 1;
        return 0;
    }
};

void RenderImage (const MyImage& img, unsigned int* pixels);
void KillLexa (sf::Text* hacked_text);
size_t ReadFile (char** text, const char* file_name);
void  WriteFile (char** text, const char* file_name, size_t text_size);
