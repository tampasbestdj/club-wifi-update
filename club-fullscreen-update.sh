#!/bin/bash
# Already-installed Club Link desktop: open Club Link full screen at startup.
# From the club computer:
#   curl -fsSL https://raw.githubusercontent.com/tampasbestdj/club-wifi-update/main/club-fullscreen-update.sh | sudo bash
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run: curl -fsSL https://raw.githubusercontent.com/tampasbestdj/club-wifi-update/main/club-fullscreen-update.sh | sudo bash"
  exit 1
fi

cat > /usr/local/bin/club-link-open << 'EOF'
#!/bin/sh
# Full screen, no browser bars. Alt+F4 closes it. The desktop stays underneath.
sleep 1
exec firefox-esr --kiosk "https://clublinkpro.com"
EOF
chmod 755 /usr/local/bin/club-link-open

cat > /etc/xdg/autostart/club-link.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Club Link
Comment=Club Link full screen. Alt+F4 closes it.
Exec=/usr/local/bin/club-link-open
Terminal=false
X-XFCE-Autostart-enabled=true
EOF

cat > /usr/share/applications/club-link.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Club Link
Comment=Open Club Link full screen
Exec=/usr/local/bin/club-link-open
Terminal=false
Categories=Network;
Icon=firefox-esr
EOF

if id owner >/dev/null 2>&1; then
  install -d -o owner -g owner /home/owner/Desktop /home/owner/.config/xfce4/xfconf/xfce-perchannel-xml
  cat > /home/owner/Desktop/club-link.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Club Link
Exec=/usr/local/bin/club-link-open
Terminal=false
EOF
  cat > /home/owner/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-session" version="1.0">
  <property name="general" type="empty">
    <property name="SaveOnExit" type="bool" value="false"/>
    <property name="AutoSave" type="bool" value="false"/>
  </property>
</channel>
EOF
  chown owner:owner /home/owner/Desktop/club-link.desktop
  chown owner:owner /home/owner/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
  rm -rf /home/owner/.cache/sessions
fi

echo
echo "Done. Reboot."
echo "Club Link opens full screen by itself."
echo "Alt+F4 closes it. The Club Link icon opens it again."
