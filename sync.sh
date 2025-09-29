rm -rf ./fetch
rm -rf ./nvim
rm -rf ./aerospace
rm .zshrc

cp -r ../fetch .
cp -r ~/.config/nvim .
mkdir aerospace
cp /Applications/AeroSpace.app/Contents/Resources/default-config.toml ./aerospace
cp ~/.zshrc .
