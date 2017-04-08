#!/bin/bash -xe

# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

source /usr/local/jenkins/slave_scripts/common_translation_update.sh

setup_git

setup_review
setup_translation
setup_horizon

# Download new files that are at least 75 % translated.
# Also downloads updates for existing files that are at least 75 %
# translated.
tx pull -a -f --minimum-perc=75

# Pull upstream translations of all downloaded files but do not
# download new files.
tx pull -f

# Invoke run_tests.sh to update the po files
# Or else, "../manage.py makemessages" can be used.
./run_tests.sh --makemessages -V

# Add all changed files to git
git add horizon/locale/* openstack_dashboard/locale/*

filter_commits

send_patch
