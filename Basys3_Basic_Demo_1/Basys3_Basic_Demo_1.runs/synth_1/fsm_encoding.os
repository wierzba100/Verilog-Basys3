
 add_fsm_encoding \
       {Ps2Interface.state} \
       { }  \
       {{00000 00000} {00001 00011} {00010 00010} {00011 00001} {00100 00100} {00101 00101} {00110 00110} {00111 00111} {01000 01000} {01001 01001} {01010 01010} {01011 01011} {01100 10000} {01101 01100} {01110 01101} {01111 01110} {10000 01111} }

 add_fsm_encoding \
       {MouseCtl.state} \
       { }  \
       {{000000 000000} {000001 000001} {000010 000010} {000011 000011} {000100 000100} {000101 000101} {000110 000110} {000111 000111} {001000 001000} {001001 001001} {001010 001010} {001011 001011} {001100 001100} {001101 001101} {001110 001110} {001111 001111} {010000 010000} {010001 010001} {010010 010010} {010011 010011} {010100 010100} {010101 010101} {010110 010110} {010111 010111} {011000 011000} {011001 011001} {011010 011010} {011011 011011} {011100 011100} {011101 011101} {011110 011110} {011111 011111} {100000 100000} {100001 100010} {100010 100011} {100011 100100} {100100 100001} }

 add_fsm_encoding \
       {GPIO_demo.uartState} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} {101 101} {110 110} }