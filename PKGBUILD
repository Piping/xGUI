# Maintainer: Derek Taylor (DistroTube) <derek@distrotube.com>
pkgname=dwm-distrotube
pkgver=6.2
pkgrel=1
pkgdesc="A heavily-patched and customized build of dwm from DistroTube."
arch=(x86_64 i386)
url="git://gitlab.com/dwt1/dwm-distrotube.git"
license=('MIT')
groups=()
depends=(libx11 libxinerama libxft freetype2 st dmenu)
makedepends=(git make)
checkdepends=()
optdepends=()
provides=(dwm)
conflicts=()
replaces=()
backup=()
options=()
source=("git+$url")
noextract=()
md5sums=('SKIP')
validpgpkeys=()

package() {
	cd dwm-distrotube
	make DESTDIR="$pkgdir/" install
}
