# Ubuntu Mirror Changer

A bash script for easily managing Ubuntu repository mirrors with support for Iranian mirrors, custom URLs, and automatic regional detection.

## 🌟 Features

- Pre-configured Iranian mirrors
- Automatic regional mirror detection
- Custom mirror URL support
- Current mirror status display
- Simple command-line interface
- Easy installation and usage
- Official Ubuntu mirror support
- Automatic package list updating
- Command shortcut `mirror` for quick access

## 📋 Pre-configured Mirrors

- Faraso (`mirror.faraso.org`)
- Pishgaman (`ubuntu.pishgaman.net`)
- IranServer (`mirror.iranserver.com`)
- ArvanCloud (`mirror.arvancloud.ir`)
- Sindad (`ir.ubuntu.sindad.cloud`)
- Shatel (`ubuntu.shatel.ir`)
- HostIran (`ubuntu.hostiran.ir`)
- IUT (`repo.iut.ac.ir`)
- ParsVDS (`ubuntu.parsvds.com`)

## 🚀 Installation

1. Make the script executable:
```bash
curl -o install.sh https://raw.githubusercontent.com/smaghili/mirrorchanger/main/install.sh && chmod +x install.sh && ./install.sh
```

The script will automatically create a command shortcut `mirror` for easier access.

## 📖 Usage

After installation, you can run the tool in two ways:

1. Using the shortcut command:
```bash
sudo mirror
```

### Menu Options

1. **Iranian Mirrors**: Choose from pre-configured Iranian mirrors
2. **Ubuntu Official**: Use the official Ubuntu mirror
3. **Ubuntu Regional**: Automatically detect and use your regional mirror
4. **Custom Mirror**: Enter a custom mirror URL
5. **Mirror List**: View all available Ubuntu mirrors for Iran
6. **Exit**: Exit the program

## 💡 Tips

- The current mirror is displayed at the top of the menu
- Custom URLs must start with `http://` or `https://`
- The script automatically adds trailing slashes to URLs if missing
- Package lists are automatically updated after changing mirrors
- Use the regional mirror option for best performance based on your location

## 🔧 Configuration

The script modifies the following file:
- `/etc/apt/sources.list`

A backup of your original `sources.list` is recommended before first use.

## 📝 Example Custom Mirror URLs

- `http://security.ubuntu.com/ubuntu/`
- `http://archive.ubuntu.com/ubuntu/`
- `http://[country-code].archive.ubuntu.com/ubuntu/`

## ⚙️ Requirements

- Ubuntu-based Linux distribution
- Root access (sudo)
- Internet connection
- `curl` package installed

## 🆘 Troubleshooting

If you encounter issues:

1. Check your internet connection
2. Verify the mirror URL is correct
3. Ensure you have root access
4. Check the mirror status in the official list
5. Try using the Ubuntu Official mirror as a fallback

## 🔄 Updates

To update the script:
1. Navigate to the script directory
2. Pull the latest version:
```bash
git pull
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Disclaimer

Please make sure to backup your `sources.list` file before using this tool. While the script is designed to be safe, system modifications always carry some risk.

## 📞 Support

If you encounter any issues or have suggestions:
1. Open an issue on GitHub
2. Provide detailed information about your system and the problem
3. Include any error messages

---
Created with ❤️ for the Ubuntu community
