import csv
import re


# Test data:
# bzip2 [bzip2 license]
_DEP_RE = re.compile(r'([a-zA-Z0-9_\.\-]+ \[[a-zA-Z0-9_\.\- ]+\])')
# Test data:
# Apache-2.0 (library), GPL-3.0+ (test, build)
# BSD-2-Clause or BSL-1.0
# SIP license or GPL-2.0 or GPL-3.0
# GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
# GPL-2.0, MIT-like with advertising clause (libss and libet)
# Public domain
_DEP_LIC_RE = re.compile(r'[\w\d+\-_\.]+(?: license| with exception| with advertising clause| domain)?(?: ?\([\w\d+\-_\., +]+\))?')


def read_manifest(manifest_path):
	"""Return a dict of packages from a Buildroot manifest file.
	
	The manifest can be created by running "make legal-info" in a Buildroot
	project.
	"""
	packages = {}
	with open(manifest_path, newline='') as manifest_file:
		reader = csv.DictReader(manifest_file)
		for row in reader:
			name = row['PACKAGE']
			dependencies_str = row['DEPENDENCIES WITH LICENSES']
			dependencies_list = _DEP_RE.findall(dependencies_str)
			dependencies = {}
			for dep in dependencies_list:
				dep_name, license = dep.split(' ', 1)
				dependencies[dep_name] = {'license': license}
			license_names = [l for l in _DEP_LIC_RE.findall(row['LICENSE']) if l != 'or']
			packages[name] = {
				'version': row['VERSION'],
				'license': {
					'names': license_names,
					'files': row['LICENSE FILES'].split(),
				},
				'sourceUrl': row['SOURCE SITE'] + '/' + row['SOURCE ARCHIVE'],
				'dependencies': dependencies,
			}
	return packages

