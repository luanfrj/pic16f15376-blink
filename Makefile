
ASM := gpasm

blink.hex: blink.asm
	$(ASM) -p16f15376 $^

clean:
	rm blink.hex blink.cod blink.lst
