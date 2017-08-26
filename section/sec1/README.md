# Section 1: Git basics and formatting

## Git

First, we will go through some git basics. This will hopefully help prevent the
['final.doc'](http://www.phdcomics.com/comics/archive.php?comicid=1531) version
control style. We will refer to the tutorial by Jarrod Millman available on the
[Berkeley SCF github
repo](https://github.com/berkeley-scf/tutorial-git-basics).

```
git clone https://github.com/berkeley-scf/tutorial-git-basics
```

We will not cover the entire tutorial, only the basics. We'll come back to it in a later section,
but I recommend you read through the entire tutorial over the next week or two.

There are two ways to start a repository and link the local copy on your machine to a remote copy on Github:

- create the repository on Github using your browser and then use `git clone`
- use `git init` on your machine and then set up the remote as discussed in the Git tutorial section titled "Using remotes as a single user".

We'll probably focus on the first method in this lab. 

### Code organization

There are lots of ways you might organize your repositories. At a basic level, you may want subdirectories named: 'code', 'data', 'output', 'figs' or the like.

Or, you might find the
[ProjectTemplate](http://www.johnmyleswhite.com/notebook/2010/08/26/projecttemplate/)
package in R helpful.

## Submitting problem sets

We will go over submitting problem sets. You can find more info at
`howtos/submitting-electronically.txt` in this repo.

## Formatting

We will go over how to format problem sets using LaTeX + knitr or RMarkdown.

Some references that may be useful:

- [Dynamic docs](https://github.com/berkeley-scf/tutorial-dynamic-docs)
- [Knitr in a knutshell](http://kbroman.org/knitr_knutshell/)

We will take points off if your code is hard to read. Here are some style tips you can consider when formatting your code:

- The file `ps/goodCode.R` provides an example of how to format your code for readability.
- Here is [Hadley Wickham's perspective on good style](http://adv-r.had.co.nz/Style.html).
- Here is [Google's R style guide](https://google.github.io/styleguide/Rguide.xml).

You don't need to follow the exact style of any of those - use your own judgment and figure out what style you like and be consistent in using that style. But you should do the following:

 - use white space to make it easier to read your code
 - have your code lines be no more than 80 characters
 - give your objects and functions meaningful (and not overly long) names
 - comment your code
 - indent your code as needed so one can see what lines of code go together in a block

I do somewhat strongly suggest that you NOT include periods in names of objects (this contradicts Google's style guide). The reason is that periods are used to means something specific in R's S3 object oriented programming syntax (e.g., `predict.lm`) and that periods are used in other languages specifically for object-oriented syntax. So I'd suggest either `calculate_mle` or `calculateMLE`, not `calculate.mle`. 
