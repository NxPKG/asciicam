VERSION=`python3 -c "import asciicam; print(asciicam.__version__)"`

asciicam.1: asciicam.1.md
	pandoc asciicam.1.md -s -t man -o asciicam.1 -V header:"Version $(VERSION), `date +%Y-%m-%d`"
