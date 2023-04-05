# Log parsing

## Prerequisites

To use answer script, you'll need to have the following tools installed:

- Q_A
  - wc
- Q_B
  - awk, cut, head, sort, uniq
- Q_C
  - Bash (version 4 or later)
  - awk, cut, uniq, sort 
  - geoip-bin


## Explanations

- Q_C
  - In [attemppts] folder, the program should work but there is rate limit on the external call 
  - Change to use geoiplookup as the solution since local lookup will be much faster without limit
  - The database should be not outdated in the packaged database, but should be sufficient to handle the log data in 2019.
  
## Usage

- Q_A
  - ```bash
    # Permission
    ./chmod +x a.sh
    
    # Run
    ./a.sh
  
- Q_B
  - ```bash
    # Permission
    ./chmod +x b.sh
    
    # Run
    ./b.sh
- Q_C
  - ```bash
    # Permission
    ./chmod +x c.sh
    
    # Run
    ./c.sh

  