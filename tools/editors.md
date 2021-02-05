# Editors

## comparing files

### vimdiff

> vimdiff - edit two, three or four versions of a file with Vim and
> show differences

```bash
vim -d file1 file2
vimdiff file1 file2
```

```
:diffthis           activate diff mode
:windo diffthis
:diffoff            return to normal mode
:windo diffoff

]c      next difference 
[c      previews diff

do      obtain the current line from the other buffer
dp      put the current line to the other buffer

zo      open folded text
zc      close folded text

zm      close all folds
zr      open all folds

:diffupdate             update vim
:set diffopt+=iwhite    disable whitespace comparison
:set wrap               wrap too long lines
```

### comm

> comm - compare two sorted files line by line

```
-1     suppress column 1 (lines unique to FILE1)
-2     suppress column 2 (lines unique to FILE2)
-3     suppress column 3 (lines that appear in both files)
```

```bash
# print only common lines
comm -12 file1 file2

# print lines that are unique to the second file
comm -3 file1 file2
```

### diff

The least readable of the three IMO.

## sorting files (uniq, sort)

```bash
# sort file, display each entry only once
sort -u file.txt

# sort file, display each entry only once with number occurences
uniq -c file.txt
```

## text file editors

### sed

> [sed](https://linux.die.net/man/1/sed) - stream editor for filtering and transforming text

Manpage offers only limited reference, better documentation can be displayed with
`info sed`.

```
sed OPTIONS... [SCRIPT] [INPUTFILE...]

-e  SCRIPT
-f  SCRIPT-FILE both can be specified multiple times
-i  edit in-place, change the file instead of outputting a new one
```

Syntax of `sed` scripts: `[addr]X[options]`. X is a lingle letter command.

```bash
# delete line 30
sed '30d' input.txt

# also delete line 40
sed '30,40d' input.txt

# quits when a line starts with foo and exit with code 42
sed '/^foo/q42' intput.txt
```

#### 's' command

```
s/REGEXP/REPLACEMENT/FLAGS
```

#### other examples

```bash
# change all occurrences of 10.0.0.1 to 192.168.0.1:
cat req | sed 's/10.0.0.1/192.168.0.1/g' > req.changed

# print 45th line of file.txt
sed -n '45p' file.txt

# sed considers files a single continuous long stream, therefore this 
# will print the first line of first.txt and last line of second.txt
sed -n '1p ; $p' first.txt second.txt

# but there's also a switch to treat files separately
sed -s '1p ; $p' first.txt second.txt
```

### cut

> Print selected parts of lines from each FILE to standard output.

A simple tool for simple parsing. Supports only one-character delimiters. For more complex processing, use awk.

```
cut OPTION... [FILE]...

-d DELIM	use DELIM as a field delimiter (can be only one character)
-f LIST		select only these fields (comma-separated, indexing from 1)
-s			don't print lines without DELIM character
```

```bash
# print only username and shell of each user
cut -d: -f1,7 /etc/passwd
```

### gawk

> gawk - pattern scanning and processing language

```
gawk [ POSIX or GNU style options ] -f program-file [ -- ] file ...
gawk [ POSIX or GNU style options ] [ -- ] program-text file ...
```

```
-F fs		field separator (can be multiple characters long)
```

```bash
# print usernames in /etc/passwd file
awk -F ":" '{ print $1 }' /etc/passwd
```
