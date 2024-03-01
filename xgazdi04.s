; Autor reseni: xgazdi04

; xgazdi04-r22-r29-r13-r9-r0-r4

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data
login:          .asciiz "xgazdi04"  ; sem doplnte vas login
key:            .asciiz "ga"  
cipher:         .space  17  ; misto pro zapis sifrovaneho loginu

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:

loopstart:  
                lb r29, login(r13); nacita to znak
                xor r4, r4, r4
                daddi r4, r4, 0
                lb r22, key(r4); nacita to druhy znak (ako kluc)
                addi r9, r29, -97; do r9 to da znak minus 96 (pozre ci to je pismenko alebo cislo)
                ; ak to nie je cislo pokracuje sa ak je koniec
                bgez r9, loopcontinue
                b end


loopcontinue:   
                addi r22, r22, -96; pripocita to aby vedel o kolko to ma posunut
                xor r9, r9, r9
                add r29, r22, r29; pripocita to k ciselku aby nasiel nove
                addi r9 , r29, -123; pozre ci to po pricitani nie je viac ako z 
                bgez r9,overflow  
                b no_overflow
overflow:   
                addi r29, r29, -26
no_overflow:
                sb r29, cipher(r13); tu to ulozi to nove pismenko 


                daddi r13, r13, 1; tu to pripocita 1 aby sa posunul ukazatel



                
loopstart2:  
                lb r29, login(r13); nacita to 2 pismenko
                xor r4, r4, r4
                daddi r4, r4, 1
                lb r22, key(r4); nacita to druhy kluc
                addi r9, r29, -97;
                bgez r9, loopcontinue2
                b end

loopcontinue2:   
                addi r22, r22, -96
                ; negacia
                sub r22, r0, r22

                xor r9, r9, r9

                ;tu to kontrolujem
                add r29, r22, r29

                addi r9 , r29, -97 
                sub r9, r0, r9

                ;kontrola ci sa overflowlo
                bgez r9, overflow2  
                b no_overflow2
overflow2:   
                addi r29, r29, 26
no_overflow2:
                sb r29, cipher(r13)

                daddi r13, r13, 1
                b loopstart


end:
                xor r4, r4, r4
                daddi r4, r4, cipher
                jal     print_string    ; vypis pomoci print_string - viz nize


                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
