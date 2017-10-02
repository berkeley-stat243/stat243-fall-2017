# Code Review

Today we will practice paired code review for PS2.  In order for this of benefit, you will need to be as honest with your partner as possible.  If something is actually hard to follow, tell them!  If you thought that something they did was clever, also tell them!

# Procedure
You will each spend 10 minutes reading your partner's code while he/she will be available to answer questions you have about their work.

# Some guiding questions

1.  Is the code visually easy to break apart?  Can you see the entire body of the functions without scrolling up/down left/right?  The general rule-of-thumb is no more than 80 in either direction (80 character width, 80 lines.  The first restriction should be practiced more religiously)

2.  Are there "magic numbers" present in the code?  i.e. Hard-coded values or indices.  In this assignment, some indices are acceptable given the structure of the scraped page, but they should be accompanied by some documentation about the assumed structure of the data.

3.  Is it clear why each variable is being created?  Names are good guidance here.

4.  Is the code separated into logical "steps"?  Or is it just one big blob?  If you have descriptive function names, then you can get away without comments.  Otherwise, each chunk of code should have a short comment explaining its purpose.

5.  Are the input tests reasonable?  Do they seem to catch every case that came to your mind as you wrote your function?