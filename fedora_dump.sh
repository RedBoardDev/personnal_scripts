#!/bin/bash

function asking_action() {
    local message="$1"
    local action="$2"

    read -p "$message (Y/N): " choice
    choice="${choice:-Y}"

    if [[ $choice == [Yy] ]]; then
        echo "You choose yes."
        eval "$action"
    else
        echo "You choose no."
    fi
}

clear
echo "INSTALLING USEFULL PACKAGES FOR NEW DUMP"
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[teams]\nname=teams\nbaseurl=https://packages.microsoft.com/yumrepos/ms-teams\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/teams.repo'
dnf -y install dnf-plugins-core
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf upgrade -y

# remove docker
dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

packages_list=(boost-devel.x86_64
    boost-static.x86_64
    ca-certificates.noarch
    clang.x86_64
    cmake.x86_64
    CUnit-devel.x86_64
    curl.x86_64
    flac-devel.x86_64
    freetype-devel.x86_64
    gcc.x86_64
    gcc-c++.x86_64
    gdb.x86_64
    git
    glibc.x86_64
    glibc-devel.x86_64
    glibc-locale-source.x86_64
    gmp-devel.x86_64
    ksh.x86_64
    elfutils-libelf-devel.x86_64
    libjpeg-turbo-devel.x86_64
    libvorbis-devel.x86_64
    SDL2.x86_64
    SDL2-static.x86_64
    SDL2-devel.x86_64
    libX11-devel.x86_64
    libXext-devel.x86_64
    ltrace.x86_64
    make.x86_64
    nasm.x86_64
    ncurses.x86_64
    ncurses-devel.x86_64
    ncurses-libs.x86_64
    net-tools.x86_64
    openal-soft-devel.x86_64
    python3-numpy.x86_64
    python3.x86_64
    rlwrap.x86_64
    ruby.x86_64
    strace.x86_64
    tar.x86_64
    tcsh.x86_64
    tmux.x86_64
    sudo.x86_64
    tree.x86_64
    unzip.x86_64
    valgrind.x86_64
    which.x86_64
    xcb-util-image.x86_64
    xcb-util-image-devel.x86_64
    zip.x86_64
    zsh.x86_64
    avr-gcc.x86_64
    qt-devel
    docker
    docker-compose
    java-17-openjdk
    java-17-openjdk-devel
    boost
    boost-math
    boost-graph
    autoconf
    automake
    tcpdump
    wireshark
    nodejs
    libvirt
    libvirt-devel
    virt-install
    haskell-platform
    golang
    systemd-devel
    libgudev-devel
    php.x86_64
    php-devel.x86_64
    php-bcmath.x86_64
    php-cli.x86_64
    php-gd.x86_64
    php-mbstring.x86_64
    php-mysqlnd.x86_64
    php-pdo.x86_64
    php-pear.noarch
    php-xml.x86_64
    php-gettext-gettext.noarch
    php-phar-io-version.noarch
    php-theseer-tokenizer.noarch
    SFML.x86_64
    SFML-devel.x86_64
    CSFML.x86_64
    CSFML-devel.x86_64
    irrlicht.x86_64
    irrlicht-devel.x86_64
    rust.x86_64
    cargo.x86_64
    mariadb-server.x86_64
    x264.x86_64
    lightspark.x86_64
    lightspark-mozilla-plugin.x86_64
    teams.x86_64
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
    fedora-workstation-repositories
    htop
    gh
    gource)

asking_action "Do you want to install discord?" "packages_list+=(discord)"

dnf -y install ${packages_list[@]}

# google chrome

asking_action "Do you want to install google-chrome?" "dnf config-manager --set-enabled google-chrome && dnf install google-chrome-stable"

# config and start docker
systemctl enable docker
systemctl start docker
usermod -aG docker $USER
systemctl daemon-reload
systemctl restart docker

# Criterion
curl -sSL "https://github.com/Snaipe/Criterion/releases/download/v2.4.2/criterion-2.4.2-linux-x86_64.tar.xz" -o criterion-2.4.2.tar.xz
tar xf criterion-2.4.2.tar.xz
cp -r criterion-2.4.2/* /usr/local/
echo "/usr/local/lib" >/etc/ld.so.conf.d/usr-local.conf
ldconfig
rm -rf criterion-2.4.2.tar.xz criterion-2.4.2/

# Sbt
curl -sSL "https://github.com/sbt/sbt/releases/download/v1.3.13/sbt-1.3.13.tgz" | tar xz
mv sbt /usr/local/share
ln -s '/usr/local/share/sbt/bin/sbt' '/usr/local/bin'

# Gradle
wget https://services.gradle.org/distributions/gradle-7.2-bin.zip
mkdir /opt/gradle && unzip -d /opt/gradle gradle-7.2-bin.zip && rm -f gradle-7.2-bin.zip
echo 'export PATH=$PATH:/opt/gradle/gradle-7.2/bin' >>/etc/profile

# Stack
curl -sSL https://get.haskellstack.org/ | sh

# snap
dnf install snapd
ln -s /var/lib/snapd/snap /snap
sleep 5

# youtube music
asking_action "Do you want to install youtube-music?" "snap install youtube-music-desktop-app"

# spotify
asking_action "Do you want to install spotify?" "snap install spotify"

# postman
asking_action "Do you want to install postman?" "snap install postman"

dnf upgrade -y

asking_action "Do you want to install sshs?" "cd /tmp && git clone https://github.com/quantumsheep/sshs.git sshs && cd sshs && make && make install"

asking_action "Do you want to reboot now?" "reboot"
