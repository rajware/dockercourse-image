#!/bin/sh -e

echo "Setting up xorg..."
setup-xorg-base

echo "Installing XFCE, apps and dbus..."
apk add xfce4 xfce4-terminal gvfs \
        xfce4-taskmanager xfce4-screenshooter \
        adwaita-xfce-icon-theme \
        mousepad chromium \
        dbus

echo "Configuring xfce..."
# Switch off unwanted buttons in the logout dialog
# Interactively, this could have been done with
#   xfconf-query -c xfce4-session -np '/shutdown/ShowHibernate' -t 'bool' -s 'false' --create
#   xfconf-query -c xfce4-session -np '/shutdown/ShowSuspend' -t 'bool' -s 'false'
#   xfconf-query -c xfce4-session -np '/shutdown/ShowHybridSleep' -t 'bool' -s 'false'
#   xfconf-query -c xfce4-session -np '/shutdown/ShowSwitchUser' -t 'bool' -s 'false'
# Not available in unattended install because xfconf-query requires a dbus session
cat >/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml <<"EOXFCESESSION"
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-session" version="1.0">
  <property name="general" type="empty">
    <property name="FailsafeSessionName" type="string" value="Failsafe"/>
    <property name="LockCommand" type="string" value=""/>
  </property>
  <property name="sessions" type="empty">
    <property name="Failsafe" type="empty">
      <property name="IsFailsafe" type="bool" value="true"/>
      <property name="Count" type="int" value="5"/>
      <property name="Client0_Command" type="array">
        <value type="string" value="xfwm4"/>
      </property>
      <property name="Client0_Priority" type="int" value="15"/>
      <property name="Client0_PerScreen" type="bool" value="false"/>
      <property name="Client1_Command" type="array">
        <value type="string" value="xfsettingsd"/>
      </property>
      <property name="Client1_Priority" type="int" value="20"/>
      <property name="Client1_PerScreen" type="bool" value="false"/>
      <property name="Client2_Command" type="array">
        <value type="string" value="xfce4-panel"/>
      </property>
      <property name="Client2_Priority" type="int" value="25"/>
      <property name="Client2_PerScreen" type="bool" value="false"/>
      <property name="Client3_Command" type="array">
        <value type="string" value="Thunar"/>
        <value type="string" value="--daemon"/>
      </property>
      <property name="Client3_Priority" type="int" value="30"/>
      <property name="Client3_PerScreen" type="bool" value="false"/>
      <property name="Client4_Command" type="array">
        <value type="string" value="xfdesktop"/>
      </property>
      <property name="Client4_Priority" type="int" value="35"/>
      <property name="Client4_PerScreen" type="bool" value="false"/>
    </property>
  </property>
  <property name="shutdown" type="empty">
    <property name="ShowHibernate" type="bool" value="false"/>
    <property name="ShowHybridSeep" type="bool" value="false"/>
    <property name="ShowSuspend" type="bool" value="false"/>
    <property name="ShowSwitchUser" type="bool" value="false"/>
  </property>
</channel>

EOXFCESESSION
# Set chromium as the default browser
sed -i -e 's/^WebBrowser=.*$/WebBrowser=chromium/' \
        /etc/xdg/xfce4/helpers.rc
# Set the deault UI to resemble Windows 2000
cat >/etc/xdg/xfce4/panel/default.xml <<"ENDPANELXML"
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-panel" version="1.0">
    <property name="configver" type="int" value="2" />
    <property name="panels" type="array">
        <value type="int" value="1" />
        <value type="int" value="2" />
        <property name="dark-mode" type="bool" value="true" />
        <property name="panel-1" type="empty">
            <property name="position" type="string" value="p=8;x=400;y=576" />
            <property name="length" type="uint" value="100" />
            <property name="position-locked" type="bool" value="true" />
            <property name="icon-size" type="uint" value="16" />
            <property name="size" type="uint" value="26" />
            <property name="plugin-ids" type="array">
                <value type="int" value="1" />
                <value type="int" value="2" />
                <value type="int" value="3" />
                <value type="int" value="6" />
                <value type="int" value="9" />
                <value type="int" value="11" />
                <value type="int" value="12" />
            </property>
            <property name="background-style" type="uint" value="1" />
            <property name="background-rgba" type="array">
                <value type="double" value="0.752941" />
                <value type="double" value="0.749020" />
                <value type="double" value="0.737255" />
                <value type="double" value="1.000000" />
            </property>
        </property>
        <property name="panel-2" type="empty">
            <property name="autohide-behavior" type="uint" value="1" />
            <property name="position" type="string" value="p=9;x=392;y=24" />
            <property name="length" type="uint" value="1" />
            <property name="position-locked" type="bool" value="true" />
            <property name="size" type="uint" value="48" />
            <property name="plugin-ids" type="array">
                <value type="int" value="15" />
                <value type="int" value="16" />
                <value type="int" value="17" />
                <value type="int" value="18" />
                <value type="int" value="19" />
                <value type="int" value="20" />
                <value type="int" value="21" />
                <value type="int" value="22" />
            </property>
        </property>
    </property>
    <property name="plugins" type="empty">
        <property name="plugin-1" type="string" value="applicationsmenu" />
        <property name="plugin-2" type="string" value="tasklist">
            <property name="grouping" type="uint" value="0" />
            <property name="window-scrolling" type="bool" value="false" />
        </property>
        <property name="plugin-3" type="string" value="separator">
            <property name="expand" type="bool" value="true" />
            <property name="style" type="uint" value="0" />
        </property>
        <property name="plugin-6" type="string" value="systray">
            <property name="square-icons" type="bool" value="true" />
        </property>
        <property name="plugin-8" type="string" value="pulseaudio">
            <property name="enable-keyboard-shortcuts" type="bool" value="true" />
            <property name="show-notifications" type="bool" value="true" />
        </property>
        <property name="plugin-9" type="string" value="power-manager-plugin" />
        <property name="plugin-10" type="string" value="notification-plugin" />
        <property name="plugin-11" type="string" value="separator">
            <property name="style" type="uint" value="0" />
        </property>
        <property name="plugin-12" type="string" value="clock">
            <property name="digital-format" type="string" value="%I:%M %p" />
            <property name="mode" type="uint" value="2" />
        </property>
        <property name="plugin-15" type="string" value="showdesktop" />
        <property name="plugin-16" type="string" value="separator" />
        <property name="plugin-17" type="string" value="launcher">
            <property name="items" type="array">
                <value type="string" value="xfce4-terminal-emulator.desktop" />
            </property>
        </property>
        <property name="plugin-18" type="string" value="launcher">
            <property name="items" type="array">
                <value type="string" value="xfce4-web-browser.desktop" />
            </property>
        </property>
        <property name="plugin-19" type="string" value="launcher">
            <property name="items" type="array">
                <value type="string" value="xfce4-file-manager.desktop" />
            </property>
        </property>
        <property name="plugin-20" type="string" value="launcher">
            <property name="items" type="array">
                <value type="string" value="org.xfce.mousepad.desktop" />
            </property>
        </property>
        <property name="plugin-21" type="string" value="separator" />
        <property name="plugin-22" type="string" value="directorymenu" />
    </property>
</channel>
ENDPANELXML

echo "Adding user1 to audio, video, dialout and users groups..."
adduser user1 audio
adduser user1 video
adduser user1 dialout
adduser user1 users

echo "Adding dbus to startup..."
rc-update add dbus
