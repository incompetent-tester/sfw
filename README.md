
# SFW - Sensible Firewall Logs

SFW is a no frills ufw/iptable log parser with geolocation identification. It is fully written in bash script. No need to install any other dependencies such as python, etc. As long as it supports bash, SFW will work.

SFW parses log and outputs:
- .ods (recommended)
- .csv 

```
Usage: SFW.sh [-o] [-h] [-g] [-c] <log_file>

options:
        -g                  Determine IP geolocation
        -ge <excluded_ips>  Specific excluded ips for geolocation e.g. "172.16.32.1,172.16.32.2"
        -h                  Show help
        -c                  Output .csv instead of .ods
        -o  <output_name>   Specific output file name

Examples: 
        ./SFW.sh -o mylog -g ./example/ufw.log
        ./SFW.sh -o mylog -g -c ./example/ufw.log
        ./SFW.sh -o mylog -ge "172.16.32.10,172.16.32.5" -g ./example/syslog.log
```

## Examples

1. Parse logs with Geolocation checking and generate an .ods file
```
./SFW.sh -o mylog -g ./example/ufw.log
```

2. Parse logs with Geolocation checking and generate .csv files
```
./SFW.sh -o mylog -g -c ./example/ufw.log
```

## Generated .ods file preview 
![Example1](https://github.com/incompetent-tester/sfw/blob/master/doc/image1.png)

### Feel free to contribute to this project.

### Wanna buy me a beer ?
I do accept monero. Thank you very much.
```
41fezqfD3syGsUQNnR8t4hQghCJG61YWmHkYHMmYcNFoMgAg3VPhpXi7J94zdqqW7uBMrTTJS1FwNEZhCsoGMa2T3vQq82A
```
