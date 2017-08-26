# 1

# looking at the flags for mkdir in 'man mkdir' shows that
# -p flag is what you need
mkdir -p ~/projects/drought

# 2

# again, look in 'man ls'
ls -S  # for decreasing size (the default)

ls -Sr
ls -S -r         # same as ls -Sr
ls -S --reverse  # this won't work on a Mac, but the same as ls -Sr on Linux

# 3

cd ~/stat243-fall-2015/units
chmod gu+r,u+w,guo+x unit1-unix.sh
# if you didn't realize you could use commas, you could do in separate lines:
chmod gu+r unit1-unix.sh
chmod u+w unit1-unix.sh
chmod guo+x unit1-unix.sh

# 4

zip -R class.zip stat243-fall-2015
tar -cvzf class.tgz stat243-fall-2015

# 5

df -BM

df -h  # shows in easily-readable units though not always in megabytes

# 6

which ls  # returns /bin/ls; many basic commands are in /bin

# 7

which python # results will vary depending on your system
which python3  # you may only have 'python3' and not 'python'

# often python will be in /usr/bin/python

ls /usr/bin  # likely will have 'gcc', 'zip', 'less'



