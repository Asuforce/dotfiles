# dotfiles

設定ファイル

## Usage

```sh
# xoce setting
xcode-select --install
sudo xcodebuild -license

# do setup script
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Asuforce/dotfiles/master/setup.sh)"

# chnage shell
echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh

# set token
vi ~/.netrc
```
