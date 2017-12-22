# gomoku-swift
gomoku done in swift

Simple app for playing gomoku, or "Connect 4" of any length, versus an AI.

The app uses a collection view for its game board, using custom cell logic as defined in the BoardSquareViewLayout file.
The cell size is determined by the size of the board; if there are too many cells to be displayed on screen, the collection view will allow the user to scroll in both directions.

The game starting options may seem a little unwieldy, but I couldn't think of a better way to keep it simple while preventing the user from impossible inputs (e.g. requiring 5 in a row on a 3x3 board).

The app is written using the MVC approach: the GameBoardViewController adheres to the GameUpdateDelegate protocol to be informed of changes to the game state made by the game engine (AI).

The app uses a relatively naive AI adapted from a simple Unity implementation I made last year.
It uses 1 ply depth searching, but tends to play fairly well, and you will lose if you don't pay close attention.
The decision model is mostly one long branch - essentially a priority list (if A, do A; otherwise if B, do B, etc).
A more detailed description of the AI behavior is found in the GameEngine file and copied at the bottom of this readme.
The game is best played as "Connect 5" in my opinion.


    /* AI implentation:
     * 0) If no friendly pieces are placed, pick an unoccupied center square
     * 1) If move would win, play that move
     * 2) If move would prevent opponent from winning, play that move
     * 3) If move would create an unstoppable threat, play that move
     * 4) If move would prevent opponent from creating said unstoppable threat, play that move
     * 4b/c) Play or prevent a threat that might be unstoppable, but I didn't gather enough score data to tell   
     * 5) Evaluate using naive and arbitrary score based on maximizing size of open-ended own-color chains and likely forcing moves
     * 6) If score is tied in 5, pick a random qualifying square (unimplemented: pick one closest to the "center" of our pieces?)
     *
     * For pruning purposes, do not consider moves more than two places (row or column) away from an existing piece
     * The AI only looks for two different "unstoppable threats".
     *   There are likely many more that the machine does not currently look for specifically, but might find with step 5.
     * The AI only looks 1 ply deep.
     */
