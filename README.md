# dotfiles

設定ファイル

## Usage

```sh
# xcode setting
xcode-select --install
sudo xcodebuild -license accept

# do setup script
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Asuforce/dotfiles/master/setup.sh)"

# chnage shell
chsh -s /usr/local/bin/zsh

# set token
vi ~/.netrc

# generate key
ssh-keygen -t ed25519 -C '<my-email-address>'
```
