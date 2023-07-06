#!/bin/sh

#  ci_post_clone.sh
#  Runway-iOS
#
#  Created by 김인환 on 2023/02/15.
#
brew install cocoapods

pod cache clean --all

pod install

