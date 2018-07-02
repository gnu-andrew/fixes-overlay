# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools ltprune multilib-minimal

DESCRIPTION="AAC audio decoding library"
HOMEPAGE="http://www.audiocoding.com/faad2.html"
SRC_URI="mirror://sourceforge/faac/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="digitalradio static-libs"
DOCS=( AUTHORS ChangeLog NEWS README TODO )
RDEPEND=""
DEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-2.8.5-libmp4ff-shared-lib.patch
	"${FILESDIR}"/${PN}-faad_version.patch
)

src_prepare() {
	default

	sed -i -e 's:iquote :I:' libfaad/Makefile.am || die

	# bug 466986
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die

	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--without-xmms
		$(use_with digitalradio drm)
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	# do not build the frontend for non default abis
	if [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
		sed -i -e 's/frontend//' Makefile || die
	fi
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}
