# Tools and commands for jobs or process control

## jobs

```bash
# send jobs to the background
sleep 60 &
sleep 60; ^Z; bg

# bring back to the foreground
fg

# disown (continue after the closing of the terminal)
sleep 60 &|
sleep 60 &!
sleep 60; diswon
nohup sleep 60;
```

Jobs can be referred to by number or string

```
%NUMBER     NUMBER of the job
%STRING     last command started with STRING
%?STRING    last command which contains STRING
```

```bash
sleep 20 &; fg %sleep
(nmap bob; ping google.com -c 2) &; fg %?bob
gobuster dir -u example.com -w wordlist &; kill %gobuster
```

## ps

> ps displays information about a selection of the active processes.

Following options affect selected shown processes. Arguments of these 
options can be comma or space separated lists.

```
-A              select all processes
123             select process with pid 123

-C cmdlist      select by command (executable) name

-G grplist      select by real group ID or group name
-g grplist      select by effective group ID or group name

-U userlist     real user ID or name
-u userlist     effective user ID or name

-p pidlist      select by PID
-s sesslist     session ID (default current session)
-t ttylist      tty ID (default current tty)
```

Following options control formatting.

```
--format F  user-defined format

-f      full format
j       BSD job cotrnol format
u       user oriented format
f       process hierarchy (forest)
-H      process hierarchy (spaces)
```

## top

> The top program provides a dynamic real-time view of a running system.

```
-U USER         display processes with a user ID or a username equal to USER.
-u USER         same as above, but only effective user
```
