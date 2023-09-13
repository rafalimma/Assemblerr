section .data
    prompt1 db "Digite o primeiro número: ", 0
    prompt2 db "Digite o segundo número: ", 0
    result db "O MMC dos números é: ", 0
    prompt3 db "Deseja calcular novamente? (S/n): ", 0
    newline db 10, 0

section .bss
    num1 resd 1
    num2 resd 1
    choice resb 1
    mmc resd 1

section .text
    global _start

_start:
    ; Loop principal
    loop_start:
        ; Solicitar o primeiro número
        mov eax, 4
        mov ebx, 1
        mov ecx, prompt1
        mov edx, 27
        int 0x80

        ; Ler o primeiro número
        mov eax, 3
        mov ebx, 0
        mov ecx, num1
        mov edx, 4
        int 0x80

        ; Solicitar o segundo número
        mov eax, 4
        mov ebx, 1
        mov ecx, prompt2
        mov edx, 27
        int 0x80

        ; Ler o segundo número
        mov eax, 3
        mov ebx, 0
        mov ecx, num2
        mov edx, 4
        int 0x80

        ; Calcular o MMC
        mov eax, [num1]
        mov ebx, [num2]
        call calculate_mmc

        ; Salvar o resultado em mmc
        mov [mmc], eax

        ; Exibir o resultado
        mov eax, 4
        mov ebx, 1
        mov ecx, result
        mov edx, 23
        int 0x80

        mov eax, 4
        mov ebx, 1
        mov ecx, [mmc]
        add ecx, '0'
        mov edx, 4
        int 0x80

        ; Pular uma linha
        mov eax, 4
        mov ebx, 1
        mov ecx, newline
        mov edx, 2
        int 0x80

        ; Perguntar se deseja calcular novamente
        mov eax, 4
        mov ebx, 1
        mov ecx, prompt3
        mov edx, 31
        int 0x80

        ; Ler a escolha
        mov eax, 3
        mov ebx, 0
        mov ecx, choice
        mov edx, 1
        int 0x80

        ; Verificar se a escolha é 'S' ou 's'
        cmp byte [choice], 'S'
        je loop_start
        cmp byte [choice], 's'
        je loop_start

    ; Sair do programa
    exit_program:
        mov eax, 1
        xor ebx, ebx
        int 0x80

calculate_mmc:
    ; Função para calcular o MMC (Mínimo Múltiplo Comum)
    ; Entradas: eax = a, ebx = b
    ; Saída: eax = MMC(a, b)
    push ebp
    mov ebp, esp
    mov ecx, eax
    mov edx, ebx

    ; Usar um loop para encontrar o MMC
    mmc_loop:
        cmp ecx, edx
        je mmc_done
        jl mmc_increment_ecx
        jmp mmc_increment_edx

    mmc_increment_ecx:
        add ecx, eax
        jmp mmc_loop

    mmc_increment_edx:
        add edx, ebx
        jmp mmc_loop

    mmc_done:
        mov eax, ecx  ; O MMC está em ecx
        pop ebp
        ret
