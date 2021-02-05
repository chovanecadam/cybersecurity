# Useful linux tools

| name          | description                                   |
| ------------- | --------------------------------------------- |
| rdesktop      | lighweight RDP client                         |
| axel 			| download file over multiple connections		|
| find			| find files									|
| which         | find executable in PATH                       |
| where         | find all executables in PATH                  |
| locate        | find files from updatedb(8) database          |
| file          | determine file type                           |
| stat          | display file or file system status            |

## Examples

### find

It's very beneficial to redirect error output to /dev/null.

```bash
# find file modified in between 2020-10-5 and 2020-10-6
find / -newermt "2020-10-5" ! -newermt "2020-10-6" -type f

# find files with SUID bit set
find / -perm -4000 2>/dev/null

# find files with GUID bit set
find / -perm -2000 2>/dev/null

# recursively print names of all files from the currect directory
find .
```
