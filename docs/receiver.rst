The UART receives the serial bit stream of data, removes the start-bit and transfers the data in a parallel format to a storage register connected to the host data bus. In receiver the issue of synchronization is resolved by generating a *local* clock at a higher frequency using it to sample the received data in a manner that preserves the integrity of the data. In the scheme used here hte data assumed to be in a 10-bit format, will be sampled at a rate determined by *Sample_clock* which is generated at the receiver's host. The cycles of *Sample_clock* will be counted to ensure that the data are sampled in the middle of a bit time. The sampling algorithm must
(1) verify that bit has been received
(2) generate samples from 8 bits of the data
(3) load the sampled data onto the local bus

