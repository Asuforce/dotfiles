# dotfiles

設定ファイル

VSCode の [cloudSettings](https://gist.github.com/Asuforce/3803eedb0aaeda0bf875d6583e0cf753) はこれ

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
