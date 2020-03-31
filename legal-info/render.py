#!/usr/bin/python3
import logging
from contextlib import suppress
from pathlib import Path
from .acknowledgement import packages_to_acks, executables_to_acks
from .buildroot import read_manifest
from .overlay import PACKAGE_OVERLAY
from .proprietary import PROPRIETARY_EXECUTABLES as PROP_EXES
from .sections import SEC_OVERVIEW, SEC_ACKNOWLEDGEMENTS


_LOGGER = logging.getLogger()


def render_html(device: str):
	sections = [SEC_OVERVIEW]

	manifest_path = f'buildroot/output/{device}/legal-info/manifest.csv'
	host_manifest_path = f'buildroot/output/{device}/legal-info/host-manifest.csv'
	packages = read_manifest(manifest_path)
	host_packages = read_manifest(host_manifest_path)
	all_packages = {
		**packages,
		**host_packages,
	}

	ignore = {
		# Virtual packages. Will resolve to actual packages.
		# E.g., python-zlib (virtual) -> zlib (virtual) -> libzlibz (actual)
		'python3-zlib',
		'zlib',
		# Proprietary
		'alg',
		'python-algpy',
		'python-baxter',
		'python-cellmate',
		'python-dash',
		'python-geist',
		'python-maskin',
		'python-mester',
	}
	prop_acks = executables_to_acks(PROP_EXES,
	                                PACKAGE_OVERLAY,
	                                all_packages,
	                                ignore=ignore)
	log_acks(prop_acks)
	prop_acks_html = render_acks(prop_acks, device)

	nonprop_packages = {name: p
	                    for name, p in packages.items()
	                    if 'PROPRIETARY' not in p['license']['names']}
	nonprop_acks = packages_to_acks(nonprop_packages)
	nonprop_acks_html = render_acks(nonprop_acks, device)

	sections.append(SEC_ACKNOWLEDGEMENTS.format(prop_acks=prop_acks_html,
	                                            nonprop_acks=nonprop_acks_html))
	return '\n\n'.join(sections)


def log_acks(acks):
	for ack in acks:
		_LOGGER.debug(f'{ack["name"]}')
		_LOGGER.debug(f'\tlicense names: {ack["license"]["names"]}')
		_LOGGER.debug(f'\tlicense files: {ack["license"]["files"]}')
		with suppress(KeyError):
			_LOGGER.debug(f'\tlicense text: {ack["license"]["text"]}')


def render_acks(acks, device: str) -> str:
	return '\n'.join(render_ack(ack, device) for ack in acks)


def render_ack(ack: dict, device: str) -> str:
	name = ack['name']
	title = ack['title']
	ver = ack['version']
	source_url = ack['sourceUrl']
	license_names = ack['license']['names']
	license_files = ack['license']['files']

	licenses = ', '.join(license_names)
	selected_license_row = ''
	if len(license_names) > 1:
		with suppress(KeyError):
			selected_license_name = ack['license']['selected']['name']
			selected_license_row = f"""
			<tr>
				<td class="header">
					License used in this device
				</td>
				<td>
					{selected_license_name}
				</td>
			</tr>
			"""

	text = ''
	with suppress(KeyError):
		text += f"<p>{ack['license']['text']}</p>"
	if len(license_files) > 1:
		with suppress(KeyError):
			selected_license_file = ack['license']['selected']['file']
			license_files = [selected_license_file]

	for license_file in license_files:
		license_paths = [
			f'buildroot/output/{device}/legal-info/licenses/{name}-{ver}/{license_file}',
			f'buildroot/output/{device}/legal-info/host-licenses/{name}-{ver}/{license_file}',
			f'buildroot/output/{device}/legal-info/host-licenses/{name}/{license_file}',
		]
		license_content = None
		for license_path in license_paths:
			try:
				with open(license_path) as f:
					license_content = f.read()
			except FileNotFoundError:
				pass
		if license_content is None:
			raise RuntimeError(f'Could not find license for "{name}"')
		text += f'<pre>{license_content}</pre>'

	return f"""
		<h3>{title}</h3>
		<table>
			<tr>
				<td class="header">
					Source URL
				</td>
				<td>
					{source_url}
				</td>
			</tr>
			<tr>
				<td class="header">
					Version
				</td>
				<td>
					{ver}
				</td>
			</tr>
			<tr>
				<td class="header">
					License(s)
				</td>
				<td>
					{licenses}
				</td>
			</tr>
			{selected_license_row}
		</table>
		{text}
	"""

