#!/bin/bash
set -euxo pipefail
build_type=$1
curr_d=$(pwd)
full=$(readlink -f "$0")
webkit="$(dirname $full)"/src/bun.js/WebKit
getzig="$(dirname $full)"/getzig.sh
git submodule update --init --depth 1 --checkout $webkit
cd $webkit && git checkout patches && git config pull.rebase true && git pull origin patches

chmod +x install.sh && ./install.sh $build_type
if [[ $build_type == "Release" ]]; then
    mv "$webkit/WebKitBuild/bun-webkit" "$(dirname $full)/build-release/bun-webkit"
else
    mv "$webkit/WebKitBuild/bun-webkit" "$(dirname $full)/build/bun-webkit"
fi
chmod +x $getzig && ./$getzig
cd $curr_d