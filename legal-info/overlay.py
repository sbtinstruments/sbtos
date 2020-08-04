def _normalize(deps):
	result = {}
	for name, value in deps.items():
		if isinstance(value, set):
			result[name] = {
				'dependencies': value
			}
		else:
			result[name] = value
	return result

# Includes all software (executables, libraries, etc.) that is either:
#  * using a proprietary license, or,
#  * a dependency of proprietary software (including recursive dependencies).
#
# We call this an overlay, since it relies on additional information found
# in the Buildroot manifest. That is, we rely on the Buildroot manifest to
# fill in the blanks. E.g., license name, license file, source URL, version,
# etc.
#
# The overlay includes:
#  * Mapping of package name to dependencies. This is necessary since
#    the dependencies in the Buildroot manifest include software, that
#    is not part of a "larger work" or "derivative work". E.g., the
#    Python interpreter is not part of software written in Python,
#    but Buildroot still includes it as a dependency of all Python
#    programs.
#  * License selection in case of multi-licensed software.
#  * Overrides/additions in case of inaccuracies in the Buildroot manifest.
#
# In practice, this overlay contains all software that is compatible
# with a proprietary license. I.e., software that is either:
#  * Using a proprietary license itself (for which we own a license),
#  * using a compromise between a permissive and a copyleft license (e.g.,
#    MPL or LGPL),
#  * using a permissive license (e.g., MIT, Apache, BSD-3-Clause), or,
#  * released into the public domain.
#
# There isn't any software in this overlay that uses a strictly copyleft
# license (e.g., GPL). If you find one, then let me know as soon as
# possible at fpa@sbtinstruments.com.
#
PACKAGE_OVERLAY = _normalize({
	# 2.0.0-rc.1
	'alg': {
		'boost',
		'concurrentqueue',
	},
	# 1.71.1
	'boost': {},
	# 2.4.2
	'pybind11': {},
	# 2.0.0-beta.5
	'python-algpy': {
		'alg',
		'pybind11',
	},
	# 5.0.0
	'python-dash': {
		'python-asyncqt',
		'python-geist',
		'python-psutil',
		'python-pyqt5',
		'qt5svg',
	},
	# 5.0.2
	'python-cellmate': {
		'python-geist',
		'python-msgpack',
	},
	# 3.0.0-rc.6
	'python-baxter': {
		'python-algpy',
		'python-geist',
	},
	# 3.0.0-rc.3
	'python-maskin': {
		'python-geist',
	},
	# 2.0.0-rc.3
	'python-mester': {
		'python-geist',
	},
	# 0.1.0
	'python-staten': {
		'python-geist',
		'python-asyncio-mqtt',
	},
	# 3.0.0-rc.5
	'python-geist': {
		'python-aiohttp-sbt',
		'python-aiosql',
		'python-daemon-sbt',
		'python-jmespath',
		'python-jsonpatch',
		'python-jsonschema',
		'python-restrictedpython',
	},
	# 3.6.2-sbt.1
	'python-aiohttp-sbt': {
		'title': 'aiohttp',
		'dependencies': {
			'python-attrs',
			'python-cchardet',
			'python-multidict',
			'python-async-timeout',
			'python-yarl',
			'python-aiodns',
			'python-typing-extensions',
			'python3-zlib',
		},
	},
	# 2.2.4
	'python-daemon-sbt': {
		'title': 'python-daemon',
		# The library itself is licensed under Apache-2.0.
		# The test and build software is under GPL-3.0+.
		# In other words, only Apache-2.0-licensed software code is used
		# at runtime and only Apache-2.0-licensed software is stored on
		# the device.
		'license': {
			'selected': {
				'name': 'Apache-2.0 (library)',
				'file': 'LICENSE.ASF-2',
			},
		},
		# Note that docutils is required for building but not at runtime.
	},
	# 1.23
	'python-jsonpatch': {
		'title': 'jsonpatch',
		'dependencies': {
			'python-jsonpointer',
		},
	},
	# 2.0
	'python-jsonpointer': {
		'title': 'jsonpointer',
	},
	# 0.9.3
	'python-jmespath': {
		'title': 'jmespath',
	},
	# 1.0.0
	'python-idna': {
		'title': 'idna',
	},
	# 4.0b4
	'python-restrictedpython': {
		'title': 'RestrictedPython',
	},
	# 19.3.0
	'python-attrs': {
		'title': 'attrs',
	},
	# 2.1.5:
	'python-cchardet': {
		'title': 'cchardet',
		# Depends on libstdcpp which is GPLed with a runtime library exception.
	},
	# 4.5.2
	'python-multidict': {
		'title': 'multidict',
	},
	# 3.0.1
	'python-async-timeout': {
		'title': 'async-timeout',
	},
	# 1.3.0
	'python-yarl': {
		'title': 'yarl',
		'dependencies': {
			'python-multidict',
			'python-idna',
		},
	},
	# 2.0.0
	'python-aiodns': {
		'title': 'aiodns',
		'dependencies': {
			'python-pycares',
		},
	},
	# 2.5.1
	'python-jsonschema': {
		'title': 'jsonschema',
		'override': {
			# Buildroot supplies two license files: One for the library itself
			# and one for the test suite. We do not use the test suite on the
			# device. Therefore, we only include the license for the library
			# itself.
			'license': {
				'files': ['COPYING'],
			},
		},
	},
	# 5.6.4
	'python-psutil': {
		'title': 'psutil',
	},
	# 3.7.4.1
	'python-typing-extensions': {
		'title': 'typing-extensions',
	},
	# 3.0.0
	'python-pycares': {
		'title': 'pycares',
		# The python-cffi dependency is only needed during the build.
		# It is not needed at runtime.
	},
	# 5.7
	'python-pyqt5': {
		'title': 'Riverbank PyQt',
		'override': {
			# Buildroot assumes that we use the GPL version. We do not.
			'license': {
				'names': ['Riverbank Commercial License Agreement'],
				'files': [],
			},
		},
		'add': {
			'license': {
				'text': 'Customer ID: 01-019914',
			},
		},
		'dependencies': {
			'qt5base',
			'python-sip',
		},
	},
	# Virtual package: Ensures that zlib is linked into python
	'python3-zlib': {
		'zlib',
	},
	# Virtual package: Chooses between libzlib and zlib-ng
	'zlib': {
		# We use libzlib
		'libzlib',
	},
	# 1.2.11
	'libzlib': {
		'title': 'zlib',
	},
	# ffda5a47ffa8c8f4aa411f933b18509234dd4ab4
	'concurrentqueue': {
		'title': 'moodycamel::ConcurrentQueue',
		'license': {
			'selected': {
				'name': 'BSL-1.0',
			},
		},
		'override': {
			# Buildroot fails to produce a working source URL. We provide a working one.
			'sourceUrl': 'https://github.com/cameron314/concurrentqueue/tree/ffda5a47ffa8c8f4aa411f933b18509234dd4ab4',
		},
	},
	# 4.18
	'python-sip': {
		'title': 'SIP',
		'license': {
			'selected': {
				'name': 'SIP license',
				'file': 'LICENSE',
			},
		},
	},
	# 5.12
	'qt5base': {
		'title': 'Qt',
		'license': {
			'selected': {
				'name': 'LGPL-3.0',
				'file': 'LICENSE.LGPLv3',
			},
		},
		'add': {
			'license': {
				'text': """
					<p>
						Qt contains some code that is not provided under the GNU Lesser
						General Public License (LGPL) or the Qt Commercial License, but
						rather under specific licenses from the original authors.
					</p>
					<p>
						For the full list of additional licenses and acknowledgements,
						please refer to the document at the following URL:
						<br>
						<br>
						https://doc.qt.io/qt-5/licenses-used-in-qt.html
					</p>
				""",
			},
		},
	},
	'qt5svg': {
		'title': 'Qt SVG',
		'license': {
			'selected': {
				'name': 'LGPL-3.0',
				'file': 'LICENSE.LGPLv3',
			},
		},
	},
	# 0.8.0
	'python-asyncqt': {
		'title': 'asyncqt'
	},
	# 1.0.0
	'python-msgpack': {
		'title': 'msgpack'
	},
	# 3.0.0
	'python-aiosql': {
		'title': 'aiosql'
	},
	# 0.6.0
	'python-asyncio-mqtt': {
		'title': 'asyncio-mqtt',
		'dependencies': {
			'python-paho-mqtt-sbt',
		},
	},
	# 1.5.0
	'python-paho-mqtt-sbt': {
		'title': 'paho-mqtt',
		'license': {
			'selected': {
				'name': 'EDLv1.0',
				'file': 'edl-v10',
			},
		},
	},
})

