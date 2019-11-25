# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit distutils-r1

DESCRIPTION="Easy, clean, reliable Python 2/3 compatibility"
HOMEPAGE="http://python-future.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

distutils_enable_sphinx docs \
	dev-python/sphinx-bootstrap-theme
distutils_enable_tests pytest

# TODO: make numpy unconditional when it supports py3.8
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' \
			python{2_7,3_{5,6,7}})
	)
"

python_prepare_all() {
	# tests requiring network access
	rm tests/test_future/test_requests.py || die
	sed -i -e 's:test.*request_http:_&:' \
		tests/test_future/test_standard_library.py || die

	distutils-r1_python_prepare_all
}
