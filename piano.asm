;piano project: Steve Paytosh and Dustin Gregory 
.model small
.586

.stack 100h

.data
keyboard_ledge	db    	10,13,'----------------------------------------$'
keyboard_row1	db    	10,13,'| |  |#|  |  |#| |#|  |  |#| |#| |#|  ||$'
keyboard_row2	db    	10,13,'| |  |w|  |  |r| |t|  |  |u| |i| |o|  ||$'
keyboard_row3	db    	10,13,'| | A | B | C | D | E | F | G | A | B ||$'
keyboard_row4	db    	10,13,'| | a | s | d | f | g | h | j | k | l ||$'
info_text    	db    	10,13,'| x=exit	< or > =move octave    	|$'
brand_text    	db    	10,13,'|  	BlameCo Pianos & Organs     	|$'
newline        	db    	10,13, '$'
frequency    	dw    	0d
octave        	dw    	0d 	;octave detemines how to multiply and divide the input frequency
input        	dw    	'a','s','d','f','g','h','j','k','l','w','r','t','u','i','o'
input2        	dw    	0,440,494,523,587,659,698,784,880,988,466,554,622,740,831,932

.code
main    	proc
mov        	dx,@data
mov        	ds,dx

main_label:
;call	print_keyboard

;call	play_mary
;jmp    	break_loop

play_loop:
call	clear_screen
call	print_keyboard
call	get_char

cmp    	al,'x'
je    	break_loop
cmp    	al,'<'
je    	decrement_octave ;jump to decrement octave
cmp    	al,'>'
je    	increment_octave ;jump to increment octave
cmp    	al, ','
je    	decrement_octave ;jump to decrement octave
cmp    	al, '.'
je    	increment_octave ;jump to increment octave

call	set_frequency
call	clear_screen
call	print_pressed_keyboard
call	play_sound
jmp    	play_loop

increment_octave:
inc    	octave
jmp    	play_loop
decrement_octave:
dec    	octave
jmp    	play_loop
break_loop:

mov    	ah, 04ch ; needed to exit the interrupts
int    	21h

main	endp ; end main proc

;=================================================
; FUNCTIONS
;=================================================

print_ln	proc
; method prints a generic new line, but saves registers
push	dx
push	cx
push	bx
push	ax
mov    	dx,offset newline
call	print_out
pop    	ax
pop    	bx
pop    	cx
pop    	dx
ret
print_ln	endp

;-----------------------------
print_out proc
; method prints out a given string, which is placed in dx
mov    	ah, 09h
int    	21h
ret
print_out endp

;-----------------------------------
print_keyboard proc
; prints out a plain keboard, without showing any keys as pressed
call	print_ln
mov    	dx,offset keyboard_ledge
call	print_out
mov    	dx,offset brand_text
call	print_out
mov    	dx, offset info_text
call	print_out
mov    	dx, offset keyboard_ledge
call	print_out
mov    	dx,offset keyboard_row1
call	print_out
mov    	dx,offset keyboard_row2
call	print_out
mov    	dx,offset keyboard_row3
call	print_out
mov    	dx,offset keyboard_row4
call	print_out
mov    	dx,offset keyboard_ledge
call	print_out

call	print_ln
call	print_ln
ret
print_keyboard endp

;------------------------------------
print_pressed_keyboard proc
;prints keyboard with pressed key (in al) in different color (yellow)
;preserves registers
push	ax
push	bx
push	cx
push	dx
mov    	bl, al
call	print_ln
mov    	dx,offset keyboard_ledge
call	print_out
mov    	dx,offset brand_text
call	print_out
mov    	dx, offset info_text
call	print_out
mov    	dx, offset keyboard_ledge
call	print_out

;row_1
mov    	dx, offset keyboard_row1
call	print_out
call	print_ln

;row_2
mov    	dl, '|'
mov    	ah, 02h
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
int    	21h
cmp    	bl, 'w'
jnz    	not_w
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, 'w'
call	key_pressed
int    	21h
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
int    	21h
jmp    	not_r
not_w:
mov    	dl, '|'
int    	21h
mov    	dl, 'w'
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
int    	21h
cmp    	bl, 'r'
jnz    	not_r
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, 'r'
call	key_pressed
int    	21h
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_t
not_r:
mov    	dl, '|'
int    	21h
mov    	dl, 'r'
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 't'
jnz    	not_t
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, 't'
call	key_pressed
int    	21h
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
int    	21h
jmp    	not_u
not_t:
mov    	dl, '|'
int    	21h
mov    	dl, 't'
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
int    	21h
cmp    	bl, 'u'
jnz    	not_u
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, 'u'
call	key_pressed
int    	21h
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_i
not_u:
mov    	dl, '|'
int    	21h
mov    	dl, 'u'
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'i'
jnz    	not_i
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, 'i'
call	key_pressed
int    	21h
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_o
not_i:
mov    	dl, '|'
int    	21h
mov    	dl, 'i'
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'o'
jnz    	not_o
mov    	dl, '|'
call	key_pressed
int    	21h
mov    	dl, 'o'
call	key_pressed
int    	21h
mov    	dl, '|'
call	key_pressed
int    	21h
jmp    	end_row_2
not_o:
mov    	dl, '|'
int    	21h
mov    	dl, 'o'
int    	21h
mov    	dl, '|'
int    	21h
end_row_2:
mov    	dl, ' '
int    	21h
int    	21h
mov    	dl, '|'
int    	21h
int    	21h

;row_3
mov    	dx, offset keyboard_row3
call	print_out
call	print_ln

;row_4
mov    	ah, 02h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'a'
jnz    	not_a
mov    	dl, 'a'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_s
not_a:
mov    	dl, 'a'
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 's'
jnz    	not_s
mov    	dl, 's'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_d
not_s:
mov    	dl, 's'
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'd'
jnz    	not_d
mov    	dl, 'd'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_f
not_d:
mov    	dl, 'd'
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'f'
jnz    	not_f
mov    	dl, 'f'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_g
not_f:
mov    	dl, 'f'
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'g'
jnz    	not_g
mov    	dl, 'g'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_h
not_g:
mov    	dl, 'g'
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'h'
jnz    	not_h
mov    	dl, 'h'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_j
not_h:
mov    	dl, 'h'
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'j'
jnz    	not_j
mov    	dl, 'j'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_k
not_j:
mov    	dl, 'j'
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'k'
jnz    	not_k
mov    	dl, 'k'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
jmp    	not_l
not_k:
mov    	dl, 'k'
int    	21h
mov    	dl, ' '
int    	21h
mov    	dl, '|'
int    	21h
mov    	dl, ' '
int    	21h
cmp    	bl, 'l'
jnz    	not_l
mov    	dl, 'l'
call	key_pressed
int    	21h
mov    	dl, ' '
int    	21h
jmp    	end_row_4
not_l:
mov    	dl, 'l'
int    	21h
mov    	dl, ' '
int    	21h
end_row_4:
mov    	dl, '|'
int    	21h
int    	21h

mov 	dx,offset keyboard_ledge
call	print_out

call	print_ln
call	print_ln

pop    	dx
pop    	cx
pop    	bx
pop    	ax
ret
print_pressed_keyboard endp

;-----------------------------------
key_pressed proc
;prints pressed key in yellow
;preserves registers
push      	ax
push     	bx
push      	cx
push     	dx
mov    	ah, 09h
mov    	bx, 0eh
mov    	cx, 01h
int    	10h
pop    	dx
pop    	cx
pop    	bx
pop    	ax
ret
key_pressed endp

;-----------------------------------
speakers_on proc
in  	al,061h               	;get port 61h contents
or  	al,00000011b        	;enable speaker
out 	061h,al
ret
speakers_on endp

;--------------------------------------
speakers_off proc
in  	al,61h               	;get port contents
and 	al,11111100b        	;disable speaker
out 	61h,al    
ret
speakers_off endp

;------------------------------------------
play_sound	proc
; code has issues with divide overflows
push	ax
push	bx
push	cx
push	dx
push	ds

cmp    	frequency,0
je    	end_play

; Switch speaker on
   	 in     al,061h   		 ; get port 61h contents
   	 or     al,00000011b   	 ; enable speaker
   	 out    061h,al
   	 
   	 ; Switch speaker off
   	 in     al,61h   			 ; get port contents
   	 and    al,11111100b   	 ; disable speaker
   	 out    61h,al    

mov bx,frequency

    	mov eax,1234deh
    	div bx
    	mov cx,ax


    	cli                         	;no interrupts
    	mov 	al,10110110b        	;get ready byte
    	out 	043h,al
    	mov 	al,cl              	;frequency divisor low byte
    	out 	042h,al
    	mov 	al,ch              	;frequncy divisor high byte
    	out 	042h,al

; Switch speaker on

    	in  	al,061h               	;get port 61h contents
    	or  	al,00000011b        	;enable speaker
    	out 	061h,al
 
; Wait CX clock ticks

    	sti                         	;must allow clock interrupt
   	 
	mov cx,12            	; change to number in other students code   	 
; mov cx,38                   	;About 1 second (1/18.2*t=num) t=time num=number of clock ticks
    	mov ax,040h               	;point DS to BIOS
    	mov es,ax
    	mov si,06ch   	 
    	mov ds,ax
waitlp:   mov ax,[si]          	;get low word of tick counter
wait1:  cmp ax,[si]          	;wait for it to change
    	je  wait1
    	loop waitlp                	;count CX changes
   	 


; Switch speaker off

    	in  	al,61h               	;get port contents
    	and 	al,11111100b        	;disable speaker
    	out 	61h,al

end_play:    
pop  ds
pop 	dx
pop  cx
pop  bx
pop  ax
ret
play_sound endp

;-----------------------------------------------
clear_screen	proc
;function exists to clear the screen and allow the possibility of highlighting a key
;preserves registers
push	ax
push	bx
push	cx
push	dx

;clear the screen
mov    	ah,07h
mov    	bh,07h
xor    	cx,cx
mov    	dx, 184Fh
int    	10h

;set the cursor to the top left
mov    	ah,02h
xor    	bx,bx
xor    	dx,dx
int    	10h

pop    	dx
pop    	cx
pop    	bx
pop    	ax
ret
clear_screen	endp

;-----------------------------------------------
set_frequency	proc
;compares the input char to the values in input, and sets the frequency according to the matched key
;input - al
xor    	cx,cx
xor    	ah,ah
mov    	si, offset input
check_start:
inc    	cx
inc    	cx
cmp    	cx, 30
jg    	set_zero
mov    	bx, [si]
add    	si, 02h
cmp    	bx, ax
jne    	check_start
mov    	si, offset input2
add    	si, cx
mov    	bx, [si]
mov    	frequency, bx
jmp    	end_freq
set_zero:
mov    	frequency, 0
end_freq:
call	set_octave
ret
set_frequency	endp

;-------------------------------------------
set_octave	proc
;changes the frequency to the set octave
;preserves used registers
push	ax
push	bx
push	cx
push	dx
xor    	dx,dx
mov    	bx, 02h
cmp    	octave,0
je    	end_octave
cmp    	octave,0
jg    	higher
mov    	cx, octave
lower:
mov    	ax, frequency
div    	bx
inc    	cx
cmp    	cx,0
mov   		frequency,ax
jne    	lower
jmp    	end_octave
higher:
mov    	ax, frequency
mul    	bx
dec    	cx
cmp    	cx,0
mov    	frequency,ax
jne    	higher
end_octave:
pop    	dx
pop    	cx
pop    	bx
pop    	ax
ret
set_octave	endp

;-------------------------------------------
get_char proc
mov    	ah,07h
int    	21h
ret
get_char endp

;----------------------------------------------
play_mary	proc
; canned song: mary has a little lamb. method helps demonstrate quality of notes played
mov        	frequency,659
call    	play_sound
mov        	frequency,587
call    	play_sound
mov        	frequency,523
call    	play_sound
mov        	frequency,587
call    	play_sound
mov        	frequency,659
call    	play_sound
mov        	frequency,659
call    	play_sound
mov        	frequency,659
call    	play_sound

ret
play_mary 	endp
end 	main ; end program
