# My .tmux.conf

# Left side status line
![tmux_status_line_left](/tmux_status_line_left.png)

# Right side status line
![tmux_status_line_right](/tmux_status_line_right.png)

# Tmux version 3.3a

# Requirements

* sensors

# Installation

```
$ sudo apt install sensors 

$ sudo dnf install lm_sensors
```

# Status line displays information for:

* hostname
* ip address
* color-changing battery percentage level 
* CPU core temperature
* VPN ip address
* amount of memory used / total memory
* memory percentage
* CPU load average
* current date
* current time
* timezone
