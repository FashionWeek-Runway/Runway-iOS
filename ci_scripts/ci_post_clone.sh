#!/bin/sh

#  ci_post_clone.sh
#  Runway-iOS
#
#  Created by 김인환 on 2023/02/15.
#  

brew update
brew install rbenv ruby-build
rbenv install -l
rbenv install 3.1.3
rbenv global 3.1.3

echo ">>> SETUP LOCAL GEM PATH"
echo 'export GEM_HOME=$HOME/gems' >>~/.bash_profile
echo 'export PATH=$HOME/gems/bin:$PATH' >>~/.bash_profile
export GEM_HOME=$HOME/gems
export PATH="$GEM_HOME/bin:$PATH"

gem install bundler
bundle install
brew install git-lfs

git lfs install --skip-smudge
git lfs pull
git lfs install --force

bundle exec pod cache clean NMapsMap

# Install dependencies you manage with CocoaPods.
bundle exec pod install --repo-update
