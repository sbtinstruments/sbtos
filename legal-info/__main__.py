import logging
from sys import argv, stdout
from . import render_html


logging.basicConfig(stream=stdout, level=logging.DEBUG)
_LOGGER = logging.getLogger()


def main():
	device = argv[1]  # E.g., 'zeus' or 'bactobox'
	if '--debug' in argv or '-d' in argv:
		_LOGGER.setLevel(logging.DEBUG)
	else:
		_LOGGER.setLevel(logging.INFO)
	# Render HTML
	html = render_html(device)
	# Write HTML to file
	html_path = f'{device}-legal-info.html'
	with open(html_path, 'w') as f:
		f.write(html)


# This file always executes
main()
