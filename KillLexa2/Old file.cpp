#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
// #include <SFML/Graphics/Image.hpp>
// #include <SFML/Graphics/Texture.hpp>
#include <string>

const std::string BG_NAME = "BG.png";

int main()
{
    sf::RenderWindow window(sf::VideoMode(1920, 1080), "LeXa Crack");

    sf::Texture bg_texture;
    bg_texture.loadFromFile (BG_NAME, sf::IntRect(0, 0, 1920, 1080));
    
    sf::Sprite bg;
    bg.setTexture (bg_texture);
    
//----------------------

    sf::Music music;
    if (!music.openFromFile("8bit.ogg"))
        return -1; // error
    music.play();

//----------------------

    while (window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }

        window.clear();
        window.draw(bg);
        window.display();
    }

    return 0;
}
