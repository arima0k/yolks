#!/bin/bash

# MIT License
#
#Copyright (c) 2022 Luis Vera
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Switch to the container's working directory
cd /home/container || exit 1

# Print Java version
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0mjava -version\n"
java -version

PROJECT=velocity

VER_EXISTS=$(curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r --arg VERSION $VELOCITY_VERSION '.versions[] | contains($VERSION)' | grep true)
LATEST_VERSION=$(curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r '.versions' | jq -r '.[-1]')

# check VELOCITY_VERSION variable
if [[ "${VER_EXISTS}" == "true" ]]; then
    echo -e "Version is valid. Using version ${VELOCITY_VERSION}"
else
    echo -e "Using the latest ${PROJECT} version"
    VELOCITY_VERSION=${LATEST_VERSION}
fi

# Check auto update is on
if [ "${AUTO_UPDATE}" == "1" ]; then
        echo "Checking for updates..."

        LATEST_BUILD=`curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${VELOCITY_VERSION} | jq -r '.builds' | jq -r '.[-1]'`
        CURRENT_BUILD=`cat .build 2>/dev/null`

        if [ "$LATEST_BUILD" != "$CURRENT_BUILD" ]; then
                echo "Update available!"
                echo "Updating from '$CURRENT_BUILD' -> '$LATEST_BUILD'"
                JAR_NAME="${PROJECT}-${VELOCITY_VERSION}-${LATEST_BUILD}.jar"
                DOWNLOAD_URL="https://api.papermc.io/v2/projects/${PROJECT}/versions/${VELOCITY_VERSION}/builds/${LATEST_BUILD}/downloads/${JAR_NAME}"
                curl -o "${SERVER_JARFILE}" "${DOWNLOAD_URL}"


        echo "$LATEST_BUILD" > ".build"
                echo "Updated!"
        else
                echo "No update available"
        fi
fi

# Convert all of the "{{VARIABLE}}" parts of the command into the expected shell
# variable format of "${VARIABLE}" before evaluating the string and automatically
# replacing the values.
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

# Display the command we're running in the output, and then execute it with the env
# from the container itself.
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"
# shellcheck disable=SC2086
exec env ${PARSED}
