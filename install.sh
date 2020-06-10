#if [ ! brew ls --versions librsvg > /dev/null ]; then
  # The package is not installed
  #brew install librsvg
#fi

swift build -c release
cd .build/release
cp -f SwiftyAssetsCommandLineTool /usr/local/bin/swiftyassets
