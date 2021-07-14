# THE HALFLING

Prototipo de videojuego desarrollado con el framework **khawy** (basado en Kha) por **Federico Rodriguez (151563)**, para la materia **Programación de Videojuegos** de la Universidad ORT.

El juego está ligeramente basado en la historia **"El Hobbit"**, y tiene como personaje a un mediano (halfling), que recorre 3 escenarios de bosques y cuevas, enfrentandose a diferentes enemigos, que puede matar saltando sobre ellos o atacandolos con la espada.

## Características

### Escenarios
* **Bosque inicial**: al salir de su hogar, el mediano debe encontrar la entrada a la cueva, mientras evita caerse al vacío o ser comido por los lobos
* **Cueva**: lugar de reposo del anillo único custodiado por goblins y murcielagos
* **Bosque de elfos**: al salir de la cueva, el mediano se encontrará con elfos que disparan a todo lo que ven, y a algunos goblins que están lejos de su cueva

### Power-Ups
* **Espada**: permite matar a los enemigos presionando la tecla 'A'
* **Anillo Único**: al obtener el anillo único, el mediano podrá pasar sin ser visto por los enemigos, y no recibirá daño

### Controles
* **Desplazamiento**: flechas de direccion
* **Salto**: barra espaciadora
* **Ataque con espada**: tecla 'A'

## Errores conocidos (Bugs)
1. Cuando el personaje está en el aire y tiene contacto con un enemigo, este siempre muere sin importar el lado que haga contacto
2. El power-up de la espada funciona únicamente en el primer nivel (bosque inicial). Se detectó que las colisiones del ataque no se generan correctamente en los otros niveles, pero no se pudo solucionar.
3. El ladrido del lobo, continúa a veces incluso si el mismo ya está muerto
4. Las flechas de los elfos, pueden quedar en la pantalla si el mismo muere antes de finalizar su recorrido 

## Recursos
Todos los recursos gráficos y de sonido fueron obtenidos en los sitios:
* https://itch.io/game-assets/
* https://opengameart.org/

## Autoría
Desarrollado por **Federico Rodríguez** (**151563**) en Julio 2021



