FROM redroid/redroid:13.0.0-latest
ADD --unpack=true https://github.com/MindTheGapps/13.0.0-arm64/releases/download/MindTheGapps-13.0.0-arm64-20231025_200931/MindTheGapps-13.0.0-arm64-20231025_200931.zip /mindthegapps
ADD https://github.com/topjohnwu/Magisk/releases/download/v30.7/Magisk-v30.7.apk /magisk/