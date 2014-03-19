TicTacToe
=========
An implementation of a TicTacToe game. Includes light server built on top of core Ruby TCPServer class, a light framework Router, Controller, Request, and Response objects, the game logic, and a web based UI.

Requirements
------------
Tested on Ruby 1.9.3 and Ruby 2.0.0. Will not work on 1.8.7 or lower.

Running Application
-------------------
You can open the application from the command line by running `ruby tictactoe.rb` from the root directory of the
application. Optionally, pass in a port number as such: `ruby tictactoe.rb 703`. Default port is 8000. 

Potential Future Improvements
-----------------------------
* Routing by configuration (controller, action, and http verb)
* Make server multi threaded
* Improvements to user interface
* Improve determination of mime-type
