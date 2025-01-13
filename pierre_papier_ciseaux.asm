bits 64

extern scanf
extern printf
extern time
extern rand
extern srand
extern getchar
global main


; text declaration
section .rodata
    welcome db "Bienvenue dans le jeu Rock-Paper-Scissors!", 10, 0
    instructions db "0 = Pierre, 1 = Feuille, 2 = Ciseaux, 3 = Quitter", 10, 0
    prompt db "Votre choix : ", 0
    bot_choice_msg db "Le bot a choisi : %d", 10, 0
    user_win_msg db "Vous gagnez!", 10, 0
    bot_win_msg db "Le bot gagne!", 10, 0
    draw_msg db "Egalite!", 10, 0
    quit_msg db "Merci d'avoir joue!", 10, 0
    invalid_msg db "Choix invalide, reessayez.", 10, 0
    input_formatstr db "%d", 0

; declare null variable
section .bss
    user_choice resd 1 ; Réserve 4 octets pour stocker le choix de l'utilisateur
    bot_choice resd 1  ; Réserve 4 octets pour stocker le choix du bot

section .text
main:
    ; stack prepare
    push rbp
    mov rbp, rsp
    sub rsp, 16 ; keep space for local variable 

    ; welcome message
    mov rdi, welcome
    xor rax, rax ; clear rax
    call printf

    ; print game instructions
    mov rdi, instructions
    xor rax, rax
    call printf

.loopGame:
    ; print user prompt
    mov rdi, prompt
    xor rax, rax
    call printf

    ; read user input
    mov rdi, input_formatstr ; rdi for the first arg of printf
    lea rsi, [user_choice] ; rsi for the second arg of print f
    xor rax, rax ;clear rax
    call scanf ;then scanf

    ; check if scanf read an integer
    cmp rax, 1              ; scanf return one if an int is read
    je .check_user_choice   ; then go to the processing part

    ; if valid, clear buffer. The issue was clearing the cache when a letter was in the user input. That cause a infinity loop
.clear_input:
    call getchar            ; read one char from buffer (user choice)
    cmp al, 10              ; check if is a new line "\n" 
    jne .clear_input        ; empty the buffer until new line

    mov rdi, invalid_msg
    xor rax, rax
    call printf
    jmp .loopGame           ; loop

.check_user_choice:
    
    mov eax, [user_choice]
    cmp eax, 3
    je .quit_game           ; quit if it's 3
    cmp eax, 0
    jl .invalid_choice      ; reject if <0
    cmp eax, 2
    jg .invalid_choice      ; reject if >2

    ; continue
    jmp .play_game

.invalid_choice:
    mov rdi, invalid_msg
    xor rax, rax
    call printf
    jmp .loopGame           ; Recommencer la boucle

.play_game:
    ; init srand with time(NULL) 
    xor rdi, rdi
    call time
    mov rdi, rax
    call srand

    ; generate randomness for the bot (0-2)
    call rand
    xor edx, edx         ; prepare the modulo
    mov ecx, 3           ; divide by 3
    div ecx              ; edx contains rand() % 3
    mov [bot_choice], edx

    mov eax, [bot_choice]
    mov rsi, rax
    mov rdi, bot_choice_msg
    xor rax, rax
    call printf

    ; compare user and bot choice
    mov eax, [user_choice]
    cmp eax, [bot_choice]
    je .players_draw     ; if equal then draw

    cmp eax, 0           ; compare user choice to 0 (rock)
    je .check_rock

    cmp eax, 1           ; compare user choice to 1 (paper)
    je .check_paper

    cmp eax, 2           ; // scissors
    je .check_scissors

    ; loooooping
    jmp .loopGame

.check_rock:
    ; rock against scissors
    mov eax, [bot_choice]
    cmp eax, 2           ; rock > scissors
    je .user_win
    jmp .bot_win

.check_paper:
    ; paper against rock 
    mov eax, [bot_choice]
    cmp eax, 0           ; paper > rock
    je .user_win
    jmp .bot_win

.check_scissors:
    ; scisscors against paper
    mov eax, [bot_choice]
    cmp eax, 1           ; scissors > paper
    je .user_win
    jmp .bot_win

.user_win:
    mov rdi, user_win_msg
    xor rax, rax
    call printf
    jmp .loopGame

.bot_win:
    mov rdi, bot_win_msg
    xor rax, rax
    call printf
    jmp .loopGame

.players_draw:
    mov rdi, draw_msg
    xor rax, rax
    call printf
    jmp .loopGame

.quit_game:
    mov rdi, quit_msg
    xor rax, rax
    call printf

    ; clearing the stack
    leave
    ret
