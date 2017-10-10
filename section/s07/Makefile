all: intro.html intro_slides.html

intro.html: intro.md
	pandoc -s -o intro.html intro.md

intro_slides.html: intro.md
	pandoc -s --webtex -t slidy -o intro_slides.html intro.md

clean:
	rm -rf intro.html
