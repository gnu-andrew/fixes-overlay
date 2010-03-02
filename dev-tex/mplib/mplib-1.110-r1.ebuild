# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/mplib/mplib-1.110.ebuild,v 1.9 2009/03/18 20:48:15 ranger Exp $

EAPI=2

inherit eutils libtool

DESCRIPTION="New, revamped version of the MetaPost interpreter"
HOMEPAGE="http://foundry.supelec.fr/projects/metapost"
SRC_URI="http://foundry.supelec.fr/frs/download.php/696/${PN}-beta-${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
# We enable lua by default because it will be needed by luatex
IUSE="+lua"

RDEPEND="virtual/tex-base
	lua? ( dev-lang/lua )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-beta-${PV}/src/texk/web2c/mpdir

src_prepare() {
	elibtoolize
	cd ../../..
	epatch "${FILESDIR}/${P}-texlive-2009.patch"
}

src_configure() {
	econf $(use_enable lua)
}

src_compile() {
	# parallel make fails from time to time... needs to be fixed
	emake KPSESRCDIR=/usr/include/kpathsea KPSELIB=-lkpathsea \
		AM_CFLAGS="-I. -I/usr/include/kpathsea" -j1 || die "failed to build mplib"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	mv "${D}/usr/bin/mpost" "${D}/usr/bin/mpost-${P}" || die "failed to rename mpost"
	dodoc "${WORKDIR}/${PN}-beta-${PV}/CHANGES"	"${WORKDIR}/${PN}-beta-${PV}/README"
}
