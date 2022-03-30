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

cd /home/container

# Output Current Java Version
java -version

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $(NF-2);exit}'`

# Check auto update is on
if [ "${AUTO_UPDATE}" == "1" ]; then
	echo "Checking for updates..."

	LATEST_HASH=`curl -s https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/${UPDATE_BRANCH}/lastSuccessfulBuild/api/xml?xpath=//lastBuiltRevision/SHA1 | sed 's/.*>\(.*\)<.*/\1/'`
	CURRENT_HASH=`cat .currenthash 2>/dev/null`

	if [ "$LATEST_HASH" != "$CURRENT_HASH" ]; then
		echo "Update available!"
		echo "Updating from '$CURRENT_HASH' -> '$LATEST_HASH'"
		curl -s -o ${SERVER_JARFILE} https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/${UPDATE_BRANCH}/lastSuccessfulBuild/artifact/bootstrap/standalone/target/Geyser.jar

		echo "$LATEST_HASH" > ".currenthash"
		echo "Updated!"
	else
		echo "No update available"
	fi
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
