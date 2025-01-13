# rock-paper-scissors-x86

This project is a recreation of the classic **Rock-Paper-Scissors** game, written in **x86_64 Assembly**.

The goal is simple: compete against the computer in a match where both players make a choice, and see who wins based on the traditional rules of the game.

## Installation and Compilation

To play the game, you need to compile the Assembly file first. Follow these steps:

```bash
nasm -f elf64 -o pierre_papier_ciseaux.o pierre_papier_ciseaux.asm
gcc -o pierre_papier_ciseaux pierre_papier_ciseaux.o -no-pie
```

## Running the Game

After compiling, you can start the game with the following command:

```bash
./pierre_papier_ciseaux
```

## Game Rules

The game is very straightforward. Each round, you'll enter a number corresponding to your choice:

- **`0`** for **Rock**
- **`1`** for **Paper**
- **`2`** for **Scissors**
- **`3`** to **Quit the game**

The computer will make a random choice each turn. The rules to determine the winner are as follows:

- **Rock** beats **Scissors**
- **Scissors** beat **Paper**
- **Paper** beats **Rock**
- If both choices are the same, it’s a tie.

Have fun !
# Ameliorations 

 - Scoreboard
