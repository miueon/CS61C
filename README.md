# CS61CPU

Look ma, I made a CPU! Here's what I did:

- Using the abstract mind to separate complexity
- a

- Cause the component is reused. For each stage we need a signal to determine which built-in function to use
- Thus we need a controller to oversee these.

- abstraction with interface, observability, both are critical to debug
    - with abstraction, you can introduce the unit-testing to ensure each part works correctly
    - with observability :like printing, logging, from the state to infer the error
- how can I build it from scratch? 
    - To re-use the common circuit, you need an ALU 
    - Then every thing else build upon it in order to feed in data and get data.

- CPU also just a bunch of `functions` nothing more
