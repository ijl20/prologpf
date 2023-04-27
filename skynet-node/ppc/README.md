# Path Processor control

This program (in C) connects to Skynet and awaits commands.

It is designed to launch programs locally and pipe the output back across a socket to Skynet.

The commands allow sub-programs to be started and interrupted.

## Make

`gcc -o ppc ppc.c`

## Commands received from Skynet server

These commands have first word `ppc`.


`ppc connect`
`ppc read_var`
`ppc set_var`
`ppc start`
`ppc child_send`
`ppc kill`
`ppc split`
`ppc close`
`ppc shutdown`

## Messages to child process

If the message from the skynet server does not begin `ppc`, then the message is sent directly to the child process.
