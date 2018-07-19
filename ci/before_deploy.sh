set -ex

main() {
    local src=$(pwd) \
          stage=

    case $TRAVIS_OS_NAME in
        linux)
            stage=$(mktemp -d)
            ;;
        osx)
            stage=$(mktemp -d -t tmp)
            ;;
    esac

    test -f Cargo.lock || cargo generate-lockfile

    cross rustc --bin stuxsonos --target $TARGET --release -- -C lto

    cp target/$TARGET/release/stuxsonos $stage/

    cd $stage
    tar czf $src/stuxsonos-$TRAVIS_TAG-$TARGET.tar.gz *
    cd $src

    rm -rf $stage
}

main
