from contextlib import suppress
from typing import List


def packages_to_acks(packages: dict) -> List[dict]:
	"""Return a list of acknowledgements from a dict of packages.

	The packages can be generated from a Buildroot manifest.
	"""
	acks = []
	for name, package in packages.items():
		ack = {
			'name': name,
			'title': name,
			'version': package['version'],
			'sourceUrl': package['sourceUrl'],
			'license': {
				'names': package['license']['names'],
				'files': package['license']['files'],
			},
		}
		acks.append(ack)
	return acks


def executables_to_acks(executables: set,
                        overlay: dict,
                        packages: dict,
                        *,
						ignore: set) -> List[dict]:
	"""Return a list of acknowledgements from a set of executables.

	The dependencies of the executables will be traversed recursively
	and all will be given acknowledgement.

	The packages can be generated from a Buildroot manifest.
	The overlay is used to "patch" the packages dict.
	"""
	software = _add_dependencies(executables, overlay, ignore=ignore)
	acks = []
	for name in sorted(software):
		over = overlay[name]
		pack = packages[name]
		ack = {
			'name': name,
			'title': over.get('title', name),
			'version': pack['version'],
			'sourceUrl': pack['sourceUrl'],
			'license': {
				'names': pack['license']['names'],
				'files': pack['license']['files'],
			},
		}
		license_names = ack['license']['names']
		license_files = ack['license']['files']

		# Overrides
		with suppress(KeyError):
			license_override = over['override']['license']
			ack['license'].update(license_override)
		with suppress(KeyError):
			ack['sourceUrl'] = over['override']['sourceUrl']

		# Additions
		with suppress(KeyError):
			ack['license']['text'] = over['add']['license']['text']

		# License selection
		try:
			ack['license']['selected'] = over['license']['selected']
		except KeyError:
			if len(license_names) > 1:
				raise ValueError(f'You must choose a specific license for {name}. Choices: {license_names}')
		else:
			selected_license_name = ack['license']['selected']['name']
			if selected_license_name not in license_names:
				raise ValueError(f'Selected license "{selected_license_name}" does not exist for {name}. Choices: {license_names}')

		try:
			ack['license']['selected']['file']
		except KeyError:
			# Sometimes, there are multiple licenses, but only a single license file.
			# Other times, we need to choose a specific license file.
			if len(license_names) > 1 and len(license_files) > 1:
				raise ValueError(f'You must choose a specific license file for {name}. Choices: {license_files}')
		else:
			selected_license_file = ack['license']['selected']['file']
			if selected_license_file not in license_files:
				raise ValueError(f'Selected license file "{selected_license_file}" does not exist for {name}. Choices: {license_files}')

		acks.append(ack)
	return acks


def _add_dependencies(software: set, overlay: dict, *, ignore: set) -> set:
	"""Return a set of the given software including the dependencies resolved recursively."""
	unresolved = software.copy()
	resolved = set()
	while unresolved:
		name = unresolved.pop()
		resolved.add(name)
		deps = overlay[name].get('dependencies', set())
		unresolved = unresolved.union(deps)
	return resolved - ignore

