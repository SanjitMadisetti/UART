The UART receives the serial bit stream of data, removes the start-bit and transfers the data in a parallel format to a storage register connected to the host data bus. In receiver the issue of synchronization is resolved by generating a *local* clock at a higher frequency using it to sample the received data in a manner that preserves the integrity of the data. In the scheme used here hte data assumed to be in a 10-bit format, will be sampled at a rate determined by *Sample_clock* which is generated at the receiver's host. The cycles of *Sample_clock* will be counted to ensure that the data are sampled in the middle of a bit time. The sampling algorithm must
(1) verify that bit has been received
(2) generate samples from 8 bits of the data
(3) load the sampled data onto the local bus

Although a higher sampling frequency could be used, the frequency of *Sample_clock* in this example is 8 times the (known) frequency of the bit clock that transmitted the data. This ensures that a slight misalignment between the leading edge of a cycle of *Sample_clock* and the arrival of the start-bit will not compromise the sampling scheme because the sample will still be taken within the interval of time corresponding to a transmitted bit. The arrival of a start-bit will be determined by the detection of successive samples of value 0 after the serial input data goes low. Then three additional samples will be taken to confirm that a valid start-bit has arrived. Thereafter, 8 successive bits will be sampled at approximately the center of their bit times. Under worst-case conditions of misalignment, the sample is taken a full cycle of *Sample_clock* ahead of the actual center of the bit time, which is a tolerable skew. 

The datapath unit holds the counters which implement this scheme and its status signals are reported to the control unit. 

The state machine has the following primary (external) inputs and status inputs:

*ready_not_ready_in* : signals that the host is not ready to receive data

*Ser_in_0* : asserts while *Serial_in* is 0

*SC_eq_3* : asserts while *Sample_counter* = 3

*SC_lt_7* : asserts while *Sample_counter* < 7

*BC_eq_8* : asserts while *Bit_counter* = 8

*Sample_counter* : counts the samples of a bit

*Bit_counter* : counts the bits that have been sampled

The state machine produces the following outputs:

The state machine produces the following outputs

*read_not_ready_out* : signals that the receiver has received 8 bits

*clr_Sample_counter* : clears *Sample_counter*

*inc_Sample_counter* : increments *Sample_counter*

*clr_Bit_counter* : clears *Bit_counter*

*inc_Bit_counter* : increments *Bit_counter*

*shift* : causes *RCV_shftreg* to shift towards the LSB

*load* : causes *RCV_shftreg* to transfer data to *RCV_datareg*

*Error1* : asserts if host is not ready to receive data after last bit has been sampled

*Error2* : asserts if the stop-bit is missing

The machine has three states: *idle, starting and receiving*. Transitions between states are synchronized by *Sample_clk*. Assertion of a synchronous active-low reset puts the machine in the *idle* state. It remains there until the status signal *Ser_in_0* is low and then makes a transition to *starting*. In *starting*, the machine samples *Serial_in* repeatedly to determine whether the first bit is a valid start-bit (it must be 0). Depending on the sampled values, *inc_Sample_counter* and *clr_Sample_counter* may be asserted to increment or clear the counter at the next active edge of *Sample_clock*. If the next three samples of *Serial_in* are 0, the machine treats the bit as a valid start-bit and goes to the state *receiving*. *Sample_counter* is cleared on the transition to *receiving*. IN this state, eight successive samples are taken (one for each bit of the byte, at each active edge of *Sample_clk*), with *inc_Sample_counter* asserted. The *Bit_counter* is incremented. If the sampled bit is not the last (parity) bit, *inc_Bit_counter* and *shift* are asserted. The assertion of shift will cause the sample value to be loaded into the MSB of *RCV_shftreg*, the receiver shift register and willl shift the 7 leftmost bits of the register toward the LSB. 

After the last bit has been sampled, the machine will assert *read_not_ready_out*, a handshake output signal to the processor and clear the bit counter. At this time, the machine also checks the integrity of the data and the status of the host processor. If *read_not_ready_in* is asserted, the host processor is not ready to receive the data (*Error1*). If a stop bit is not the next bit (detected by *Ser_in_0* = 1), there is an error in the format of the received data (*Error2*). Otherwise, *load* is asserted to cause the contents of the shift register to be transferred as a parallel word to *RCV_datareg*, a data register in the host machine, with a direct connection to *data_bus*. 
