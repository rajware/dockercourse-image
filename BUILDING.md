# Manual Build Instructions

## Specifications
Alpine version 3.21.2-virtual with:
  - Swap accounting on
  - sudo, curl, bash, bash-completion
  - docker v27.3.1
  - Compose plugin v2.31.0
  - Buildx plugin v0.19.1
  - Virtualbox guest additions on VirtualBox
  - XOrg-base
  - XFCE 4
  - Chromium browser
  - MousePad editor

## Instructions for VirtualBox
1. Download alpine-virt-3.21.2-x86_64.iso (Alpine "virtual" image) from https://alpinelinux.org/. 
2. Create a virtual machine, with Type: Linux, Version: Other Linux (64-bit) and at least 2 Cores, 4GB RAM, 100GB hard disk and VMSVGA graphics controller with 16MB video memory. 
3. Add Port Forwarding for the NAT network interface, with Host Port:50022 and Guest Port:22. 
4. Mount the iso from step 1 on the CDROM device. 
5. Boot. Login as root, no password, and issue the `setup-alpine` command.
6. For keyboard layouts, choose **us** and for variant, choose **us**.
7. For hostname, specify **matsya**
8. Initialize the first available network interface with DHCP and no manual network configuration.
9. When asked for preferred repository mirror, choose 1. Do NOT choose "fastest".
10. When asked, create a user with full name:User 1, username: user1 and password: Pass@word1.
11. When the setup is over, issue the `poweroff` command. Go to VM settings and remove the ISO file from the CDROM device. Start the VM. Login as root.
12. Edit **/etc/update-extlinux.conf**, and add 'swapaccount=1' to the variable **default_kernel_opts**. Change the value of the variable **timeout** to 1.
13. Run `update-extlinux`. Reboot the VM with the `reboot` command. Log in as root.
14. Edit **/etc/apk/repositories**. Uncomment the line ending in **v3.21/community**.
15. Run `apk update`
16. Run `apk add sudo`
17. Use `visudo` to allow sudo access to "wheel" group.
18. Run `apk add curl bash bash-completion`
19. Run `apk add docker docker-cli docker-cli-compose docker-cli-buildx`
20. Run `service docker start`
21. Run `docker system info`. Verify there is no warning for no swap limit support. 
22. If the last two steps work, run `rc-update add docker` to ensure docker runs at system startup.
22. Run `reboot`. Log in as root. Verify that docker has started.
23. Edit **/etc/passwd**, and change the login shell of user1 to `/bin/bash`.
24. Run `adduser user1 docker`
25. Log out and login as user1. Run `unset HISTFILE`. Run that every time you log on as user1 during setup. 
26. Run `docker version`. Verify that it works without sudo.
27. Run `docker compose`. Verify that it works. Run `docker buildx`. Verify that it is works.
28. Logout and login as root.
29. Run `apk add virtualbox-guest-additions virtualbox-guest-additions-x11`. Verify the presence of **/usr/sbin/VBoxService**, **/usr/sbin/VBoxClient** and **/etc/init.d/virtualbox-guest-additions**.
30. Run `service virtualbox-guest-additions start`. Verify that it has started by running `ps aux | grep VBoxService`.
31. If the last two steps have succeeded, run `rc-update add virtualbox-guest-additions` to ensure required VirtualBox guest functionality at startup.
32. Run `adduser user1 vboxsf`
33. Reboot the VM. Login as root.
34. Copy the accompanying file **attachments/manual-build-filesystem/usr/sbin/vbox-integration** to **/usr/sbin/vbox-integration**. Run `chmod +x /usr/sbin/vbox-integration`.
35. Run `setup-xorg-base`
36. Run `apk add xfce4 xfce4-terminal gvfs xfce4-taskmanager xfce4-screenshooter`
37. Run `apk add adwaita-xfce-icon-theme`
38. Run `apk add dbus`
39. Run `service dbus start`
40. Run `startx`. Verify GUI is working.
41. If the GUI works, exit by choosing Log Out from the Applications menu.
42. Run `rc-update add dbus`
43. Run `apk add chromium mousepad`
44. Run `apk add lxdm`
45. Edit **/etc/lxdm/lxdm.conf**. Change the default session variable (line 10) to **session=/usr/bin/startxfce4**, the bottom_pane variable (line 40) to **bottom_pane=0** and the show language select control variable (line 43) to **lang=0**. Finally, change the bg variable (line 37) to **bg=/usr/share/backgrounds/matsya/matsya-background.jpeg**
46. Copy the accompanying files **attachments/manual-build-filesystem/etc/xdg/xfce4/panel/default.xml** to **/etc/xdg/xfce4/panel/default.xml**, and **attachments/vbox-filesystem/usr/share/backgrounds/matsya/matsya-background.jpeg** to **/usr/share/backgrounds/matsya/matsya-background.jpeg**.
47. Edit **/etc/xdg/xfce4/helpers.rc**. Change the WebBrowser variable (line 7) to **WebBrowser=chromium**.
48. Edit **/etc/lxdm/PreLogin**. Add the following line: `/usr/sbin/vbox-integration`.
49. Run `adduser user1 audio`
50. Run `adduser user1 video`
51. Run `adduser user1 dialout`
52. Run `service lxdm start`
53. Verify login as user1 is successful. 
54. Put the VM window into full-screen mode. Put it back to normal mode and resize the window. Verify that the GUI resizes in all cases.
55. Enable bidirectional shared clipboard on the VM. Verify that guest additions for shared clipboard has started by running `ps aux | grep "VBoxClient --clipboard"`. Test copy/paste in and out of the VM.
56. Start a terminal and check if docker autocomplete is working. If not, run `shopt -q login_shell || echo source /etc/profile >> /home/user1/.bashrc` in the terminal, and close and restart the terminal. Check again.
57. Start Chromium. Verify it works. Close Chromium. 
58. If everything works, log out, click "Shutdown" from the LXDM greeter screen, and run `rc-update add lxdm`
59. Reboot. Login as Root.
60. Copy the accompanying file **attachments/vbox-filesystem/etc/motd** to **/etc/motd**.
61. Remove history by typing `history -c && rm ~/.bash_history` for user1 and `rm ~/.ash_history` for root. Shut down.
62. Modify the VM icon using the accompanying file **attachments/icon/matsya.png**.
63. Export the VM. 

## Instructions for Hyper-V
1. Download alpine-virt-3.21.2-x86_64.iso (Alpine "virtual" image) from https://alpinelinux.org/. 
2. Create a virtual machine, with Generation: 2 and at least 2 Cores, 4GB RAM and 100GB hard disk. **Disable Secure Boot**.
3. Mount the iso from step 1 on the CDROM device. 
4. Boot. Login as root, no password, and issue the `setup-alpine` command.
5. For keyboard layouts, choose **us** and for variant, choose **us**.
6. For hostname, specify **matsya**
7. Initialize the first available network interface with DHCP and no manual network configuration.
8. When asked for preferred repository mirror, choose 1. Do NOT choose "fastest".
9. When asked, create a user with full name:User 1, username: user1 and password: Pass@word1.
10. When the setup is over, issue the `poweroff` command. Go to VM settings and remove the ISO file from the CDROM device. Start the VM. Login as root.
11. Edit **/etc/apk/repositories**. Uncomment the line ending in **v3.21/community**.
12. Run `apk update`
13. Run `apk add sudo`
14. Use `visudo` to allow sudo access to "wheel" group.
15. Run `apk add curl bash bash-completion`
16. Run `apk add docker docker-cli docker-cli-compose docker-cli-buildx`
17. Run `service docker start` 
18. Run `docker system info`. Verify there is no warning for no swap limit support. 
19. If the last two steps work, run `rc-update add docker` to ensure docker runs at system startup.
20. Run `reboot`. Log in as root. Verify that docker has started.
21. Edit **/etc/passwd**, and change the login shell of user1 to `/bin/bash`
22. Run `adduser user1 docker`
23. Log out and login as user1. Run `unset HISTFILE`. Run that every time you log on as user1 during setup. 
24. Run `docker version`. Verify that it works without sudo.
25. Run `docker compose`. Verify that it works. Run `docker buildx`. Verify that it is works.
26. Logout and login as root.
27. Run `apk add hvtools`
28. Run `rc-service hv_fcopy_daemon start`
29. Run `rc-service hv_kvp_daemon start`
30. Run `rc-service hv_vss_daemon start`
31. Run `rc-update add hv_fcopy_daemon`
32. Run `rc-update add hv_kvp_daemon`
33. Run `rc-update add hv_vss_daemon`
34. Run `setup-xorg-base`
35. Run `apk add xfce4 xfce4-terminal gvfs xfce4-taskmanager xfce4-screenshooter`.
36. Run `apk add adwaita-xfce-icon-theme`
37. Run `apk add dbus`
38. Run `service dbus start`
39. Run `apk add xrdp xorgxrdp`
40. Copy the accompanying files **attachments/hyperv-filesystem/etc/xrdp/xrdp.ini** to **/etc/xrdp/xrdp.ini**, and **attachments/hyperv-filesystem/usr/share/xrdp/xrdp_logo.bmp** to **/usr/share/xrdp/xrdp_logo.bmp**, and **attachments/hyperv-filesystem/usr/share/backgrounds/matsya/matsya-background.bmp** to **/usr/share/backgrounds/matsya/matsya-background.bmp**.
41. Run `service xrdp start` 
42. Run `service xrdp-sesman start`
43. Run `rc-update add xrdp`
44. Run `rc-update add xrdp-sesman`
45. Run `rc-update add dbus`
46. Run `apk add chromium mousepad`
47. Copy the accompanying file **attachments/manual-build-filesystem/etc/xdg/xfce4/panel/default.xml** to **/etc/xdg/xfce4/panel/default.xml**.
48. Edit **/etc/xdg/xfce4/helpers.rc**. Change the WebBrowser variable (line 7) to **WebBrowser=chromium**.
49. Run `adduser user1 audio`
50. Run `adduser user1 video`
51. Run `adduser user1 dialout`
52. Open "Remote Desktop Connection", and attempt to connect to the Hyper-V VM using its IP address. Do the next few steps in that session.
53. Verify login as user1 is successful. 
54. Start a terminal and check if docker autocomplete is working. If not, run `shopt -q login_shell || echo source /etc/profile >> /home/user1/.bashrc` in the terminal, and close and restart the terminal. Check again.
55. Start Chromium. Verify it works. Close Chromium. 
56. If everything works, log out of the Remote Desktop session. Continue on the Hyper-V VM console. 
57. Reboot. Login as Root.
58. Copy the accompanying file **attachments/hyperv-filesystem/etc/motd** to **/etc/motd**.
59. Remove history by typing `history -c && rm ~/.bash_history` for user1 and `rm ~/.ash_history` for root. Shut down.
60. Export the VM.
