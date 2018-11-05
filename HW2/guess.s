#include <stdio.h>
#include <stdlib.h>

#int main(){
#    srand(time(NULL));
#    int guessNum = rand() % 10 + 1;
#    int userNum;
#    printf("Choose num (1-9): ");
#    printf("%d\n", guessNum);
#    scanf("%d", &userNum);
#    while(userNum != guessNum){
#        printf("Wrong\n");
#        scanf("%d", &userNum);
#    }   
#    printf("Correct! Congratulations!\n");
#    return 0;
#}

.code16
.globl start

start: #choose random num
	 movb $0x0E,%ah
	inb $0x70
	outb $0x71
	int $0x10
	mov %al, %cl

ask_input: #set up to print question
    movw $question, %si
    movb $0x00,%ah
    movb $0x03,%al
    int $0x10

print_ques: #prints question
	lodsb
    testb %al,%al
    jz take_input #if question fully printed move on to take input from use
    movb $0x0E,%ah
    int $0x10
	jmp print_ques

take_input: #reads user input
	movb $0x00, %ah
	int $0x16
	mov %al, %bl
	movw $wrong, %si
	cmp %cl, %bl
	jne wrong_ans #if !=: print wrong else: skip
	movw $correct, %si
	jmp correct_ans #comparison is equal, print correct
	
wrong_ans: #prints wrong then restarts from begining
	lodsb
    testb %al,%al
    jz ask_input #returns to begining and asks question again
    movb $0x0E,%ah
    int $0x10
	jmp wrong_ans

correct_ans: #prints correct then jumps to done
	lodsb
    testb %al,%al
    jz done #user found answer and game = done
    movb $0x0E,%ah
    int $0x10
	jmp correct_ans

done:
    jmp done 

#strings
question:
	.string "What number am I thinking of (0-9)? "
wrong:
	.string "Wrong!\n"
correct:
	.string "Right! Congratulations"


.fill 510 - (. - start), 1, 0
.byte 0x55
.byte 0xAA