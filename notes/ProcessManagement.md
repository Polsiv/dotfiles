# Basic commands

## Ps
`ps`: display active process
`ps a`: display active processes from all users
`ps u`: display detailed info from the user
`ps x`: display process that doesnt include an associated terminal

## top
`top`: displays in real time all the processes in execution

## kill

# Unix/Linux System Signals

## Standard Signals
- **SIGHUP (Signal 1):** Restarts the process
- **SIGINT (Signal 2):** Interrupts a process, equivalent to `Ctrl+C` in the terminal.
- **SIGQUIT (Signal 3):** Exits a process and generates a memory dump.
- **SIGILL (Signal 4):** Indicates an illegal instruction.
- **SIGTRAP (Signal 5):** Used for debugging traps.
- **SIGABRT (Signal 6):** Signals an abnormal interruption, typically due to aborts.
- **SIGBUS (Signal 7):** Indicates a bus error, such as memory alignment issues.
- **SIGFPE (Signal 8):** Reports floating-point errors, such as division by zero.
- **SIGKILL (Signal 9):** Immediately terminates a process and cannot be ignored.
- **SIGUSR1 and SIGUSR2 (Signals 10 and 12):** User-defined signals.
- **SIGSEGV (Signal 11):** Indicates segmentation violation, such as accessing restricted memory.
- **SIGPIPE (Signal 13):** Occurs when a process writes to a pipe without readers.
- **SIGALRM (Signal 14):** Alarm signal, used for timers.
- **SIGTERM (Signal 15):** Termination signal, allows safe process shutdown.

## Less Common Signals
- **SIGSTKFLT (Signal 16):** Indicates stack fault on coprocessors.
- **SIGCHLD (Signal 17):** Sent to a process when one of its child processes terminates.
- **SIGCONT (Signal 18):** Continues a stopped process.
- **SIGSTOP (Signal 19):** Stops a process.
- **SIGTSTP (Signal 20):** Stops a process via keyboard, similar to `Ctrl+Z`.
- **SIGTTIN (Signal 21) and SIGTTOU (Signal 22):** Signals for terminal input/output handling.

## Advanced Signals
- **SIGURG (Signal 23):** Indicates urgent data on a socket.
- **SIGXCPU (Signal 24):** Exceeded CPU time limit.
- **SIGXFSZ (Signal 25):** Exceeded file size limit.
- **SIGVTALRM (Signal 26) and SIGPROF (Signal 27):** Signals for timers and profiling.
- **SIGWINCH (Signal 28):** Indicates a change in terminal window size.
- **SIGIO (Signal 29):** Indicates asynchronous input/output.
- **SIGPWR (Signal 30):** Power failure.
- **SIGSYS (Signal 31):** Incorrect system call argument.

