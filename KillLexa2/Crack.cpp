#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <SFML/Graphics/Image.hpp>
// #include <SFML/Image.hpp>
#include <string>

int main()
{
    sf::RenderWindow window(sf::VideoMode(1920, 1080), "LeXa Crack");
    // sf::CircleShape shape(500.f);
    // shape.setFillColor(sf::Color::Green);

    sf::Image bg;
    std::string background = "Background.png";
    if (!bg.loadFromFile (background))
        return -1; 	

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
    //    window.draw(shape);
        window.display();
    }

    return 0;
}
